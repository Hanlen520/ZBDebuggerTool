//
//  ZBViewController.m
//  ZBDebuggerTool
//
//  Created by ZB on 10/18/2018.
//  Copyright (c) 2018 ZB. All rights reserved.
//

#import "ZBViewController.h"
#import "AFNetworking.h"
#import "ZBDebuggerSandboxHelper.h"

@interface ZBViewController ()

@end

@implementation ZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadArrayOutSide];
}



- (void)loadSandbox
{
    [[ZBDebuggerSandboxHelper shareHelper] getCurrentSandboxHomeDirectory];
}

- (void)loadArrayOutSide
{
    NSArray *arr = @[@(1),@(2),@(3),@(4)];
    NSNumber *number = arr[9];
    NSLog(@"---%@",number);
}

- (void)loadRequestData
{
    NSString *url = @"https://www.zetiansm.cn/index.php/Shop/api/carousel_api";
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //请求json
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                        @"text/html",
                                                        @"image/jpeg",
                                                        @"text/plain",
                                                        @"image/png",
                                                        @"application/octet-stream",
                                                        @"text/json",
                                                        nil];
    [manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
