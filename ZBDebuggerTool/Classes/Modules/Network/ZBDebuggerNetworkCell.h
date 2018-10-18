//
//  ZBDebuggerNetworkCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBDebuggerNetworkModel.h"

static  NSString *ZBDebuggerNetworkCellID = @"ZBDebuggerNetworkCellID";

@interface ZBDebuggerNetworkCell : UITableViewCell

@property (nonatomic, strong) ZBDebuggerNetworkModel *networkModel;

+ (CGFloat)getDebuggerNetworkCellHeight;
@end
