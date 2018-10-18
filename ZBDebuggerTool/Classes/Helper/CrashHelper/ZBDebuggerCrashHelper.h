//
//  ZBDebuggerCrashHelper.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseHelper.h"

@interface ZBDebuggerCrashHelper : ZBDebuggerBaseHelper

/**
 是否使能crash日志收集
 */
@property (nonatomic, assign) BOOL enableCrashMonitor;

@end
