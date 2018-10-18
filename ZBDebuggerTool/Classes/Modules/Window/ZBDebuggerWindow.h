//
//  ZBDebuggerWindow.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerConfig.h"

@interface ZBDebuggerWindow : UIWindow

/**
 初始化悬浮球

 @param config 配置信息
 @return 实例对象
 */
- (instancetype)initWithSuspensionBallConfig:(ZBDebuggerConfig *)config;


/**
 显示悬浮球窗口
 */
- (void)showDebuggerWindow;

/**
 隐藏悬浮球窗口
 */
- (void)hiddenDebuggerWindow;
@end
