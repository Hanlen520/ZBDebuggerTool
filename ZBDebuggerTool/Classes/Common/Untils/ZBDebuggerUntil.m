//
//  ZBDebuggerUntil.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerUntil.h"

static  ZBDebuggerUntil *_instance = nil;

@interface ZBDebuggerUntil()
@property (nonatomic , strong) NSDateFormatter *dateFormatter;
@end
@implementation ZBDebuggerUntil
+ (instancetype)sharedDebuggerUntil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZBDebuggerUntil alloc]init];
    });
    return _instance;
}
- (NSString *)stringFromDate:(NSDate *)date {
    NSString *string = [self.dateFormatter stringFromDate:date];
    return string;
}

- (NSDate *)dateFromString:(NSString *)string {
    return [self.dateFormatter dateFromString:string];
}

- (NSString *)jsonStringWithFromData:(NSData *)data
{
    if ([data length] == 0) {
        return nil;
    }
    NSString *jsonString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
       
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

#pragma mark - Lazy load
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";;
    }
    return _dateFormatter;
}

+ (UIImage *)imageBundlePathWithName:(NSString *)imageName inDirectory:(NSString *)directoryPath
{
    //修改结果
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    imageName = [imageName stringByAppendingFormat:@"@%ldx.png",scale];
    NSString *path = [bundle pathForResource:imageName ofType:nil];
    if(path == nil){
      path = [bundle pathForResource:imageName ofType:nil inDirectory:@"ZBDebuggerTool.bundle/"];
    }
    UIImage *image =[UIImage imageWithContentsOfFile:path];
    return image;
}
/**
 bundle方式加载图片
 
 @param imageName 图片
 @return 图片
 */
+ (UIImage *)imageAutoSizeBundlePathWithName:(NSString *)imageName
{
    return  [self imageBundlePathWithName:imageName inDirectory:@""];
}
@end
