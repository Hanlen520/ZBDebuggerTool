//
//  ZBDebuggerNetworkDetailCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ZBDebuggerNetworkDetailCellID = @"ZBDebuggerNetworkDetailCellID";

@interface ZBDebuggerNetworkDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


@end
