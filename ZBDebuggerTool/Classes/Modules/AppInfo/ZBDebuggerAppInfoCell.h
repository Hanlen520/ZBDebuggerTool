//
//  ZBDebuggerAppInfoCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBDebuggerAppInfoCell : UITableViewCell

+ (ZBDebuggerAppInfoCell *)cellFortableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;


+ (CGFloat)getDebuggerAppInfoCelHeight;

@end
