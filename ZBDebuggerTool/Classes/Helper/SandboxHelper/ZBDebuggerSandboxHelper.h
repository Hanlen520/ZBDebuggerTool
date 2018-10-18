//
//  ZBDebuggerSandboxHelper.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseHelper.h"
#import "ZBDebuggerSandboxModel.h"
@interface ZBDebuggerSandboxHelper : ZBDebuggerBaseHelper

/**
 获取所有沙盒文件数据
 */
- (ZBDebuggerSandboxModel *)getCurrentSandboxHomeDirectory;
@end
