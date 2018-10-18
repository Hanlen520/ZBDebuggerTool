//
//  ZBDebuggerTool.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBDebuggerWindow.h"

@interface ZBDebuggerTool : NSObject
/**
 是否在工作
 */
@property (nonatomic , assign , readonly) BOOL isWorking;

//浮动窗口
@property (nonatomic , strong, readonly) ZBDebuggerWindow *debuggerWindow;

/**
  初始化调试工具，单例
 */
+ (instancetype)shareDebuggerTool;

/**
   开始工作
 */
- (void)startWorking;

/**
    停止工作
 */
- (void)stopWorking;

@end
