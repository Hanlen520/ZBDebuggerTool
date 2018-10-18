//
//  NSURLSessionConfiguration+ZBURLProtocol_Swizzling.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSURLSessionConfiguration+ZBURLProtocol_Swizzling.h"
#import <objc/runtime.h>
#import "ZBDebuggerTool.h"
#import "ZBDebuggerURLProtocol.h"

@implementation NSURLSessionConfiguration (ZBURLProtocol_Swizzling)

+ (void)load
{
    Method  originalMethod =class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method relaceMehod = class_getClassMethod([NSURLSessionConfiguration class], @selector(zbDebugger_defaultSessionConfiguration));
    method_exchangeImplementations(originalMethod, relaceMehod);
}

+ (NSURLSessionConfiguration *)zbDebugger_defaultSessionConfiguration
{
     NSURLSessionConfiguration *config = [NSURLSessionConfiguration zbDebugger_defaultSessionConfiguration];
    if([ZBDebuggerTool shareDebuggerTool].isWorking){
        NSMutableArray *protocols = [[NSMutableArray alloc] initWithArray:config.protocolClasses];
        if (![protocols containsObject:[ZBDebuggerURLProtocol class]]) {
            [protocols insertObject:[ZBDebuggerURLProtocol class] atIndex:0];
        }
        config.protocolClasses = protocols;
    }
    return config;
    
}
@end
