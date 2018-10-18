//
//  ZBDebuggerNetworkHelper.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkHelper.h"
#import "ZBDebuggerURLProtocol.h"
#import "ZBDebuggerToolMacros.h"

static  ZBDebuggerNetworkHelper *_instance = nil;

@implementation ZBDebuggerNetworkHelper

/**
 单例helper工具
 
 @return 单例对象
 */
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [[self alloc]init];
    });
    return _instance;
}

- (void)setEnableNetworkMonitor:(BOOL)enableNetworkMonitor
{
    if(_enableNetworkMonitor == enableNetworkMonitor) return;
    _enableNetworkMonitor = enableNetworkMonitor;
    if(enableNetworkMonitor){
        [self registerURLProtocolRequestMonitor];
    }else{
        [self unregisterURLProtocolRequestMonitor];
    }
}

//注册监听器
- (void)registerURLProtocolRequestMonitor
{
    if(![NSURLProtocol registerClass:[ZBDebuggerURLProtocol class]]){
        ZBDebuggerLog(@"ZBDebuggerNetworkHelper 注册协议失败");
    }
}

//关闭协议监听器
- (void)unregisterURLProtocolRequestMonitor
{
    [NSURLProtocol unregisterClass:[ZBDebuggerURLProtocol class]];
}
@end
