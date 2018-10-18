//
//  ZBDebuggerCrashListCell.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ZBDebuggerCrashListCellID = @"ZBDebuggerCrashListCellID";
@interface ZBDebuggerCrashListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
@property (weak, nonatomic) IBOutlet UILabel *crashNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *crashTimeLabel;


@end
