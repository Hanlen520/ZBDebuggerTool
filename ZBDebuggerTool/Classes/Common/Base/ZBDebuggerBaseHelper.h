//
//  ZBDebuggerBaseHelper.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBDebuggerNotifationDef.h"

@interface ZBDebuggerBaseHelper : NSObject

/**
 单例helper工具

 @return 单例对象
 */
+ (instancetype)shareHelper;
@end
