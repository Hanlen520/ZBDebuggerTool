//
//  ZBDebuggerCrashHelper.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerCrashHelper.h"
#import "ZBDebuggerConfig.h"
#import "ZBDeviceInfo.h"
#import "ZBDebuggerCrashModel.h"
#import "ZBDebuggerUntil.h"
#import "ZBDebuggerAppInfoHelper.h"
#import "ZBDebuggerSQLManger.h"


static ZBDebuggerCrashHelper *_instance = nil;
@implementation ZBDebuggerCrashHelper
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
- (void)setEnableCrashMonitor:(BOOL)enableCrashMonitor
{
    if(_enableCrashMonitor != enableCrashMonitor){
        _enableCrashMonitor = enableCrashMonitor;
        if(enableCrashMonitor){
            [self regiterCrashMonitor];
        }else{
            [self unregisterCrashMonitor];
        }
    }
}

//注册监听
- (void)regiterCrashMonitor
{
    //NSException crash捕获
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    //mach exception crash 捕获
    
    //异常signal crash 捕获
    
    //非法地址。访问未分配内存、写入没有写权限的内存等
    signal(SIGSEGV, &signal_handler);
    //非法地址。比如错误的内存类型访问、内存地址对齐等
    signal(SIGBUS, &signal_handler);
    //调用abort产生
    signal(SIGABRT, &signal_handler);
    //断点指令或者其他trap指令产生
    signal(SIGTRAP, &signal_handler);
    //执行了非法指令，一般是可执行文件出现了错误
    signal(SIGILL, &signal_handler);
    //致命的算术运算。比如数值溢出、NaN数值等
    signal(SIGFPE, &signal_handler);
    
}

//取消监听
- (void)unregisterCrashMonitor
{
    NSSetUncaughtExceptionHandler(nil);
    //非法地址。访问未分配内存、写入没有写权限的内存等
    signal(SIGSEGV,SIG_DFL);
    //非法地址。比如错误的内存类型访问、内存地址对齐等
    signal(SIGBUS, SIG_DFL);
    //调用abort产生
    signal(SIGABRT, SIG_DFL);
    //断点指令或者其他trap指令产生
    signal(SIGTRAP, SIG_DFL);
    //执行了非法指令，一般是可执行文件出现了错误
    signal(SIGILL, SIG_DFL);
    //致命的算术运算。比如数值溢出、NaN数值等
    signal(SIGFPE, SIG_DFL);
}

//保存crash数据
- (void)saveCrashModelWithExcepetion:(NSException *)exception
{
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
   ZBDebuggerCrashModel *crashModel = [[ZBDebuggerCrashModel alloc]init];
    if(name.length > 0){
        crashModel.name = name;
    }
    if(reason.length > 0){
        crashModel.reason = reason;
    }
    if(exception.userInfo){
        crashModel.userInfo = exception.userInfo;
    }
    if(callStack.count > 0){
        crashModel.stackSymbols = callStack;
    }
    
    crashModel.crashDate = [[ZBDebuggerUntil sharedDebuggerUntil] stringFromDate:[NSDate date]];
    
    crashModel.appInfos = [[ZBDebuggerAppInfoHelper shareHelper] getAppInfos];
    
    [[ZBDebuggerSQLManger sharedSQLManger] saveCrashModel:crashModel];
    
}


/**
  发送crash 到开发者邮箱
 */
- (void)sendCrashToDeveloperWithExcepetion:(NSException *)exception
{
    if(![ZBDebuggerConfig defaultDebuggerConfig].enableCrashSendEmail){
        return;
    }
    if([ZBDebuggerConfig defaultDebuggerConfig].emailAddress.length == 0){
        return;
    }
    
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
     NSDictionary *infoSystemDict = [NSBundle mainBundle].infoDictionary;
    //APP名称
    NSString *appName = infoSystemDict[@"CFBundleDisplayName"] ?:  infoSystemDict[@"CFBundleName"]?:@"Unknown";
    //app版本
    NSString *appversion = [NSString stringWithFormat:@"%@(%@)",infoSystemDict[@"CFBundleShortVersionString"]?:@"Unknown",infoSystemDict[@"CFBundleVersion"]?:@"Unknown"];
    
    //设备信息
    NSString *devicePaltm = [ZBDeviceInfo getDevicePlatform];
    NSString *devicesystem = [ZBDeviceInfo getDeviceSystemVersion];
    
    NSString *content = [NSString stringWithFormat:@"\n========App名称:%@---版本号:%@========\n========设备信息  机型:%@- 系统:%@========\n========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",appName,appversion,devicePaltm,devicesystem,name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    NSString *email = [NSString stringWithFormat:@"mailto://%@",[ZBDebuggerConfig defaultDebuggerConfig].emailAddress];
    [mailUrl appendString:email];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:mailPath];
    if([[UIApplication sharedApplication] canOpenURL:url]){
       [[UIApplication sharedApplication] openURL:url];
    }
    

    
}

//监听到崩溃日志
void uncaughtExceptionHandler(NSException*exception){
    
    [[ZBDebuggerCrashHelper shareHelper] sendCrashToDeveloperWithExcepetion:exception];
    [[ZBDebuggerCrashHelper shareHelper] saveCrashModelWithExcepetion:exception];
    [exception raise];
    
}
//崩溃处理
void signal_handler(int signal) {
    
}


@end
