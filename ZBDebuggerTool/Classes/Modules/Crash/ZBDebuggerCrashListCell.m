//
//  ZBDebuggerCrashListCell.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerCrashListCell.h"
#import "ZBDebuggerConfig.h"

@interface ZBDebuggerCrashListCell()

@property (nonatomic, strong)  UIView *line;

@end

@implementation ZBDebuggerCrashListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.resonLabel.adjustsFontSizeToFitWidth = YES;
    self.resonLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
}

-(UIView *)line
{
    if(_line == nil)
    {
        _line = [UIView new];
        _line.backgroundColor = [UIColor darkGrayColor];
    }
    return _line;
}


@end
