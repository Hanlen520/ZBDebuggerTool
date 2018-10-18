//
//  ZBDebuggerBaseVC.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerConfig.h"
#import "ZBDebuggerTool.h"
#import "ZBDebuggerUntil.h"

@interface ZBDebuggerBaseVC : UIViewController<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

// 是否隐藏右边按钮，默认显示
@property (nonatomic, assign) BOOL isHiddrenRightButton;


/**
   增加右侧按钮事件
 */
- (void)addRightButtonSEL:(SEL)asel;
@end


@interface ZBDebuggerBaseVC (alert)

//显示中心弹框
- (void)showCenterAlertWithMessage:(NSString *)message hanlder:(void(^)(NSInteger actionIndex))handler;

//显示toast
- (void)showToastMessage:(NSString *)message;
@end
