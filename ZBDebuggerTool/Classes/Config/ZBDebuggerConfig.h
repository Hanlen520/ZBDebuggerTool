//
//  ZBDebuggerConfig.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerToolMacros.h"
#import "ZBDebuggerNotifationDef.h"
#import "ZBBuggerImageName.h"




@interface ZBDebuggerConfig : NSObject

/**
  默认配置
 */
+ (instancetype)defaultDebuggerConfig;


#pragma mark - window

/**
 悬浮球的主题
 */
@property (nonatomic, strong)  UIColor *ballThemeColor;
/**
 悬浮球的背景颜色
 */
@property (nonatomic, strong)   UIColor *ballBackgroundColor;

//正常透明度
@property (nonatomic, assign)  CGFloat  ballNormalAlpha;

//拖动透明度
@property (nonatomic, assign)  CGFloat  ballActiveAlpha;


/**
 悬浮球是否支付随意移动，默认YES
 */
@property (nonatomic, assign)   BOOL isSuportMoveEnabled;

/**
 悬浮球的直径，默认70, 设置值不能小于70
 */
@property (nonatomic, assign)   CGFloat ballDiameter;

/**
 悬浮球的初始化位置X，默认10, 设置值不能小于10 ,Y默认
 */
@property (nonatomic, assign)   CGFloat ballInitFrameX;
/**
 悬浮球的初始化位置Y，默认
 */
@property (nonatomic, assign)   CGFloat ballInitFrameY;

/**
 用户ID 用户保存数据库的ID
 */
@property (nonatomic, strong) NSString *useIdentity;

#pragma Mark - network

/**
 忽略的API Host
 */
@property (strong , nonatomic) NSArray <NSString *>*ignoreHosts;



#pragma mark - crash

/**
 是否使能崩溃之后发送邮件默认是NO
 */
@property (nonatomic, assign)  BOOL enableCrashSendEmail;


/**
 如果是enableCrashSendEmail  = YES  ,设置邮箱地址
 */
@property (nonatomic, strong)  NSString *emailAddress;

@end
