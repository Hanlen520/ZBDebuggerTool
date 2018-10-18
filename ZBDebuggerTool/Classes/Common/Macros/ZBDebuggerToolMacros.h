//
//  ZBDebuggerToolMacros.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#ifndef ZBDebuggerToolMacros_h
#define ZBDebuggerToolMacros_h

//屏幕尺寸
#define ZBDEBUGGER_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define ZBDEBUGGER_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//悬浮窗口最小直径
#define  ZBDEBUGGERWINDOW_MIN_DIAMETER  70.0
//悬浮窗口初始化X
#define  ZBDEBUGGERWINDOW_MIN_WINDOWX  0
//悬浮窗口初始化Y
#define  ZBDEBUGGERWINDOW_MIN_WINDOWY  (ZBDEBUGGER_SCREEN_HEIGHT *0.75)


//导航条和状态栏的高度
#define getRectNavAndStatusHight \
({\
CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];\
CGRect rectNav = self.navigationController.navigationBar.frame;\
( rectStatus.size.height+ rectNav.size.height);\
})\


//是否开启打印
#ifdef DEBUG
#define ZBDebuggerLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ZBDebuggerLog(...)
#endif


#endif /* ZBDebuggerToolMacros_h */
