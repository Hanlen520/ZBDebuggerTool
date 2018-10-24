//
//  ZBDebuggerSandboxCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerSandboxModel.h"

#define ktopBottomMargin 10
#define kleftRightMargin 15

#define titleLabel_Font  [UIFont systemFontOfSize:14.0]
#define descLabel_Font  [UIFont systemFontOfSize:13.0]
#define dateLabel_Font  [UIFont systemFontOfSize:12.0]

static NSString *ZBDebuggerSandboxCellID = @"ZBDebuggerSandboxCellID";

@interface ZBDebuggerSandboxCell : UITableViewCell

@property (nonatomic, strong) ZBDebuggerSandboxModel *sandoxModel;


@end
