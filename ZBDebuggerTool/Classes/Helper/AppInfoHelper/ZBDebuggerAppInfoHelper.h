//
//  ZBDebuggerAppInfoHelper.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseHelper.h"
#import <UIKit/UIKit.h>

@interface ZBDebuggerAppInfoHelper : ZBDebuggerBaseHelper
/**
 开始监听
 */
- (void)startMonitoring;

/**
  停止监听
 */
- (void)stopMonitoring;

/**
  获取APPinfo 信息
 */
- (NSMutableArray <NSDictionary *> *)getAppInfos;

/**
 获取APP启动时间
 */
- (NSString *)appLaunchDateTime;
@end


//APP使用CPU
UIKIT_EXTERN NSString * const ZBAppInfoHelperCPUKey;
//APP使用内存
UIKIT_EXTERN NSString * const ZBAppInfoHelperUsedMemoryKey;
//APP使用空余内存
UIKIT_EXTERN NSString * const ZBAppInfoHelperFreeMemoryKey;
//APP总消耗内存
UIKIT_EXTERN NSString * const ZBAppInfoHelperTotalMemoryKey;
//APP的FPS
UIKIT_EXTERN NSString * const ZBAppInfoHelperFPSKey;
//APP名字
UIKIT_EXTERN NSString * const ZBAppInfoHelperAPPNameKey;
//APP版本
UIKIT_EXTERN NSString * const ZBAppInfoHelperAPPVersionKey;
//APP启动时间
UIKIT_EXTERN NSString * const ZBAppInfoHelperAPPStartTimeKey;
//APP的bundleID
UIKIT_EXTERN NSString * const ZBAppInfoHelperAPPBundleIDKey;

//手机信息
//手机型号
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneTypeKey;
//手机系统
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneSystemKey;
//手机名称
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneNameKey;
//手机CPU类型
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneCPUTypeKey;
//手机电量
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneBatteryKey;
//手机语言
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneLangueKey;
//手机容量
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneDiskKey;
//手机网络状态
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneNetworkStateKey;
//手机颜色
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneUUIDKey;
//手机IP地址
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneIPAddressKey;
//手机MAC地址
UIKIT_EXTERN NSString * const ZBAppInfoHelperPhoneMacAddressKey;

