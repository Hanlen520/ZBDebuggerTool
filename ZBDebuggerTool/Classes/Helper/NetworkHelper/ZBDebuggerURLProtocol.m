//
//  ZBDebuggerURLProtocol.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerURLProtocol.h"
#import "ZBDebuggerConfig.h"
#import "ZBDebuggerNetworkModel.h"
#import "ZBDebuggerUntil.h"
#import "ZBDebuggerSQLManger.h"

static NSString *const HTTPHandledIdentifier = @"HTTPHandledIdentifier";

#define ZBDebuggerURLProtocol_SessionDelegateQueueID @"com.ZBDebuggerURLProtocol.queue"

@interface ZBDebuggerURLProtocol () <NSURLSessionTaskDelegate , NSURLSessionDataDelegate>

@property (nonatomic, strong)    NSURLSessionDataTask *dataTask;
@property (nonatomic, strong)    NSOperationQueue     *sessionDelegateQueue;
@property (nonatomic, strong)    NSURLResponse        *response;
@property (nonatomic, strong)    NSMutableData        *data;
@property (nonatomic, strong)    NSDate       *requestStartDate;
@property (nonatomic, strong)    NSError      *error;

@end

@implementation ZBDebuggerURLProtocol

#pragma mark - 子类必须实现方法
//每次有一个请求的时候都会调用这个方法，在这个方法里面判断这个请求是否需要被处理拦截，如果返回YES就代表这个request需要被处理，反之就是不需要被处理。
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *scheme = [[request URL] scheme];
    if (![scheme isEqualToString:@"http"] &&
        ![scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    //标记请求
    if ([NSURLProtocol propertyForKey:HTTPHandledIdentifier inRequest:request] ) {
        return NO;
    }
    
    //忽略域名
    if ([ZBDebuggerConfig defaultDebuggerConfig].ignoreHosts.count > 0) {
        NSString* url = [request.URL.absoluteString lowercaseString];
        for (NSString* ignoreUrl in [ZBDebuggerConfig defaultDebuggerConfig].ignoreHosts) {
            if ([url rangeOfString:[ignoreUrl lowercaseString]].location != NSNotFound)
                return YES;
        }
        return NO;
    }
    
    return YES;
}


//返回规范的请求
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //防止死循环
    [NSURLProtocol setProperty:@(YES)
                        forKey:HTTPHandledIdentifier
                     inRequest:mutableReqeust];
    NSURLRequest *req = [mutableReqeust copy];
    return req;
}


//开始加载之前，可以对请求进行处理，比如添加请求头，重定向网络，使用自定义的缓存等
- (void)startLoading
{
    //初始化
    self.requestStartDate = [NSDate date];
    self.data = [NSMutableData data];
    self.sessionDelegateQueue = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name = ZBDebuggerURLProtocol_SessionDelegateQueueID;
    
    //开始请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.sessionDelegateQueue];
    self.dataTask = [session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

//停止请求
- (void)stopLoading
{
    //停止请求
    [self.dataTask cancel];
    self.dataTask = nil;
    
    //获取数据
    ZBDebuggerNetworkModel *model = [[ZBDebuggerNetworkModel alloc]init];
    model.requestStartDate = [[ZBDebuggerUntil sharedDebuggerUntil] stringFromDate:self.requestStartDate];
    model.url = self.request.URL;
    model.method = self.request.HTTPMethod;
    model.headerFields = self.request.allHTTPHeaderFields;
    model.mineType = self.response.MIMEType;
    if (self.request.HTTPBody) {
        model.requestBody = [[ZBDebuggerUntil sharedDebuggerUntil] jsonStringWithFromData:self.request.HTTPBody];
    } else if (self.request.HTTPBodyStream) {
        NSData* data = [self dataFromInputStream:self.request.HTTPBodyStream];
        model.requestBody = [[ZBDebuggerUntil sharedDebuggerUntil] jsonStringWithFromData:data];
    }
    model.requestUseTime = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:self.requestStartDate]];
    model.error = self.error;
    
    //响应
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    model.httpStatusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseData = self.data;
    if (self.response.MIMEType) {
        model.isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    }
    NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
        model.isImage = YES;
    }
    
    [[ZBDebuggerSQLManger sharedSQLManger] saveNetworkModel:model];
    
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        //NSURLProtocolClient每一个NSURLProtocol的子类都有一个client对象来处理请求得到的response,UIWebView发送一个request  NSURLProtocolClient自动处理这个response回到webView。
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    self.dataTask = nil;
}
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}



#pragma mark - private
- (NSData *)dataFromInputStream:(NSInputStream *)stream {
    NSMutableData *data = [[NSMutableData alloc] init];
    if (stream.streamStatus != NSStreamStatusOpen) {
        [stream open];
    }
    NSInteger readLength;
    uint8_t buffer[1024];
    while((readLength = [stream read:buffer maxLength:1024]) > 0) {
        [data appendBytes:buffer length:readLength];
    }
    return data;
}
@end
