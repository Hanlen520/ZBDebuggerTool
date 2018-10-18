//
//  ZBDebuggerTool.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerTool.h"
#import "ZBDebuggerConfig.h"
#import "ZBDebuggerAppInfoHelper.h"
#import "ZBDebuggerNetworkHelper.h"
#import "ZBDebuggerCrashHelper.h"

static ZBDebuggerTool *_instance = nil;

@interface ZBDebuggerTool ()

//浮动窗口
@property (nonatomic , strong) ZBDebuggerWindow *debuggerWindow;

//是否正在工作
@property (nonatomic , assign) BOOL isWorking;

@end

@implementation ZBDebuggerTool
/**
 初始化调试工具，单例
 */
+ (instancetype)shareDebuggerTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZBDebuggerTool alloc]init];
        [_instance setupInitial];
    });
    return _instance;
}

/**
 开始工作
 */
- (void)startWorking
{
    if(!self.isWorking){
        self.isWorking = YES;
        [self.debuggerWindow showDebuggerWindow];
        //开启app信息
        [[ZBDebuggerAppInfoHelper shareHelper] startMonitoring];
        
        //网络监听
        [ZBDebuggerNetworkHelper shareHelper].enableNetworkMonitor = YES;
        
        //crash收集
        [ZBDebuggerCrashHelper shareHelper].enableCrashMonitor = YES;
        
    }
}

/**
 停止工作
 */
- (void)stopWorking
{
    if(self.isWorking){
        self.isWorking = NO;
         [self.debuggerWindow hiddenDebuggerWindow];
        //关闭app信息
        [[ZBDebuggerAppInfoHelper shareHelper] startMonitoring];
        
        //网络监听
        [ZBDebuggerNetworkHelper shareHelper].enableNetworkMonitor = NO;
        
        //crash收集
        [ZBDebuggerCrashHelper shareHelper].enableCrashMonitor = NO;
        
    }
}

#pragma mark - private
- (void)setupInitial
{
    ZBDebuggerConfig *config  = [ZBDebuggerConfig defaultDebuggerConfig];
    self.debuggerWindow = [[ZBDebuggerWindow alloc]initWithSuspensionBallConfig:config];
}
@end
