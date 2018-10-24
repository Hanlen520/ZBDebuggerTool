//
//  ZBDebuggerNetworkDetailCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ktopBottomMargin 10
#define kleftRightMargin 15

#define ZBDebuggerNetworkDetailCell_titleLabel_Font  [UIFont systemFontOfSize:18.0]
#define ZBDebuggerNetworkDetailCell_descLabel_Font  [UIFont systemFontOfSize:14.0]



static NSString *ZBDebuggerNetworkDetailCellID = @"ZBDebuggerNetworkDetailCellID";

@interface ZBDebuggerNetworkDetailCell : UITableViewCell

@property (strong, nonatomic)  UILabel *titleLabel;

@property (strong, nonatomic)  UILabel *descLabel;

@property (strong, nonatomic)  UIView *bottomLine;


@end
