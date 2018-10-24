//
//  ZBDebuggerCrashListCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ktopBottomMargin 10
#define kleftRightMargin 15

#define titleLabel_Font  [UIFont systemFontOfSize:17.0]
#define descLabel_Font  [UIFont systemFontOfSize:17.0]
#define dateLabel_Font  [UIFont systemFontOfSize:17.0]

static NSString *ZBDebuggerCrashListCellID = @"ZBDebuggerCrashListCellID";
@interface ZBDebuggerCrashListCell : UITableViewCell

@property (strong, nonatomic)  UILabel *resonLabel;
@property (strong, nonatomic)  UILabel *crashNameLabel;
@property (strong, nonatomic)  UILabel *crashTimeLabel;


@end
