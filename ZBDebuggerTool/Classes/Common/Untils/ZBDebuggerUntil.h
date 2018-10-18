//
//  ZBDebuggerUntil.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBDebuggerUntil : NSObject

+ (instancetype)sharedDebuggerUntil;

//时间转化
- (NSString *)stringFromDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)string;


//data --> jsonstring
- (NSString *)jsonStringWithFromData:(NSData *)data;

/**
 bundle方式加载图片
 
 @param imageName 图片
 @param directoryPath 图片路径
 @return 图片
 */
+ (UIImage *)imageBundlePathWithName:(NSString *)imageName inDirectory:(NSString *)directoryPath;

/**
 bundle方式加载图片
 
 @param imageName 图片
 @return 图片
 */
+ (UIImage *)imageAutoSizeBundlePathWithName:(NSString *)imageName;
@end

