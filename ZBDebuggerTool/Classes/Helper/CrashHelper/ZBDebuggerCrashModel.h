//
//  ZBDebuggerCrashModel.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseModel.h"

@interface ZBDebuggerCrashModel : ZBDebuggerBaseModel
/**
 * Crash 名字
 */
@property (copy , nonatomic) NSString *name;

/**
 * Crash 原因
 */
@property (copy , nonatomic) NSString *reason;

/**
 * Crash 用户信息
 */
@property (strong , nonatomic) NSDictionary *userInfo;

/**
 * Crash 堆栈信息
 */
@property (strong , nonatomic) NSArray <NSString *>*stackSymbols;

/**
 * Crash 时间
 */
@property (copy , nonatomic) NSString *crashDate;

/**
 * 常量标识
 */
@property (copy , nonatomic, readonly) NSString *identity;

/**
 * App 信息
 */
@property (strong , nonatomic) NSArray *appInfos;


@end
