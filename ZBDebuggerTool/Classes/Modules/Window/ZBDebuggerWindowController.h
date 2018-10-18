//
//  ZBDebuggerWindowController.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerConfig.h"
#import "ZBDebuggerWindow.h"

@interface ZBDebuggerWindowController : UIViewController


/**
 初始化根控制器

 @param config 配置模型
 @return 控制器
 */
- (instancetype)initWithConfig:(ZBDebuggerConfig *)config;

//窗口
@property (nonatomic, strong) ZBDebuggerWindow *debuggerWindow;


//重置tabbarVC
- (void)resetTabBarViewController;

//增加观察者
- (void)addAppHelperObservers;

//移除观察者
- (void)removeAppHelperObservers;
@end
