//
//  ZBDebuggerSQLManger.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBDebuggerNetworkModel;
@class ZBDebuggerCrashModel;


@interface ZBDebuggerSQLManger : NSObject


/**
 初始化数据库

 @return 操作数据库实例
 */
+ (instancetype)sharedSQLManger;


#pragma mark - 网络请求数据保存
/**
 保存网络请求模型

 @param model 模型
 @return 保存结果
 */
- (BOOL)saveNetworkModel:(ZBDebuggerNetworkModel *)model;

/**
 获取所有网络请求模型
 */
- (NSArray<ZBDebuggerNetworkModel *> *)getAllNetworkModels;

/**
 移除所有请求模型
 */
- (BOOL)removeAllNetworkModels;


#pragma mark - crash数据保存

/**
 保存crash模型
 
 @param model 模型
 @return 保存结果
 */
- (BOOL)saveCrashModel:(ZBDebuggerCrashModel *)model;

/**
 获取所有崩溃数据模型
 */
- (NSArray<ZBDebuggerCrashModel *> *)getAllCrashModels;

/**
 移除所有crash模型
 */
- (BOOL)removeAllCrashModels;
@end
