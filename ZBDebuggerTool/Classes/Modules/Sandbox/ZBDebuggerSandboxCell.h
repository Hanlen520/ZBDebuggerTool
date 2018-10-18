//
//  ZBDebuggerSandboxCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerSandboxModel.h"

static NSString *ZBDebuggerSandboxCellID = @"ZBDebuggerSandboxCellID";

@interface ZBDebuggerSandboxCell : UITableViewCell

@property (nonatomic, strong) ZBDebuggerSandboxModel *sandoxModel;


@end
