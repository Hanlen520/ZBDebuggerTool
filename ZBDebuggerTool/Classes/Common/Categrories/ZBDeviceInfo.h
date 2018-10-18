//
//  ZBDeviceInfo.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBDeviceInfo : NSObject

/**
 获取设备名称
 */
+ (NSString *)getDeviceName;
/**
 获取设备系统版本
 */
+ (NSString *)getDeviceSystemVersion;
/**
 获取设备类型
 */
+ (NSString *)getDevicePlatform;
/**
 获取设备语言
 */
+ (NSString *)getDeviceLanguage;
/**
 获取设备电量
 */
+ (NSString *)getDeviceBattery;
/**
 获取设备CPU类型
 */
+ (NSString *)getDeviceCPUType;
/**
 获取设备Disk
 */
+ (NSString *)getDeviceDisk;
/**
 获取设备网络状态
 */
+ (NSString *)getDeviceNetworkState;
/**
 获取设备IP地址
 */
+ (NSString *)getDeviceIPAddress;
/**
 获取设备MAC地址
 */
+ (NSString *)getDeviceMACAddress;

/**
 获取设备的UUID
 */
+ (NSString *)getDeviceUUID;
@end


