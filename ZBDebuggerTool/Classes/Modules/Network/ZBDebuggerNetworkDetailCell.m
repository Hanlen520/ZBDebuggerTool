//
//  ZBDebuggerNetworkDetailCell.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkDetailCell.h"
#import "ZBDebuggerConfig.h"

@implementation ZBDebuggerNetworkDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.descLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
    self.bottomLine.backgroundColor = [UIColor darkGrayColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.descLabel.adjustsFontSizeToFitWidth = YES;
    self.descLabel.numberOfLines = 0;
}



@end
