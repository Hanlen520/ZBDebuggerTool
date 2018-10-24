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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.resonLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
     
        [self.contentView addSubview:self.crashTimeLabel];
        [self.contentView addSubview:self.resonLabel];
        [self.contentView addSubview:self.crashNameLabel];
        [self addSubview:self.line];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat topBottomMargin = ktopBottomMargin;
    CGFloat leftRightMargin = kleftRightMargin;
    CGFloat width = self.contentView.bounds.size.width;
   
    
    CGFloat descHeiht = ceil([self.resonLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kleftRightMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.resonLabel.font} context:nil].size.height);
    self.resonLabel.frame = CGRectMake(leftRightMargin, topBottomMargin, width - 2*leftRightMargin , descHeiht);
    
    CGFloat nameHeight = ceil([self.crashNameLabel.text sizeWithAttributes:@{NSFontAttributeName : self.crashNameLabel.font}].height);
    self.crashNameLabel.frame = CGRectMake(leftRightMargin, CGRectGetMaxY(self.resonLabel.frame) + topBottomMargin, width - 2*leftRightMargin, nameHeight);
    
    
    CGFloat timeHeight = ceil([self.crashTimeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.crashTimeLabel.font}].height);
    self.crashTimeLabel.frame = CGRectMake(leftRightMargin, CGRectGetMaxY(self.crashNameLabel.frame) + topBottomMargin, width - 2*leftRightMargin, timeHeight);
    
    
    
    self.line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
}


#pragma mark - lazy
-  (UILabel *)resonLabel
{
    if(_resonLabel == nil)
    {
        _resonLabel = [[UILabel alloc]init];
        _resonLabel.font = titleLabel_Font;
        _resonLabel.textColor = [UIColor blackColor];
        _resonLabel.text =@"crash原因";
        _resonLabel.numberOfLines = 0;
    }
    return _resonLabel;
}

-  (UILabel *)crashNameLabel
{
    if(_crashNameLabel == nil)
    {
        _crashNameLabel = [[UILabel alloc]init];
        _crashNameLabel.font = descLabel_Font;
        _crashNameLabel.textColor = [UIColor lightGrayColor];
        _crashNameLabel.text = @"crash 标题";
    }
    return _crashNameLabel;
}
-  (UILabel *)crashTimeLabel
{
    if(_crashTimeLabel == nil)
    {
        _crashTimeLabel = [[UILabel alloc]init];
        _crashTimeLabel.font = dateLabel_Font;
        _crashTimeLabel.textColor = [UIColor redColor];
        _crashTimeLabel.text = @"crash 时间";
    }
    return _crashTimeLabel;
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
