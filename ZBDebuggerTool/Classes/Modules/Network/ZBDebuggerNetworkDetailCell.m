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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self addSubview:self.bottomLine];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.descLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
        self.bottomLine.backgroundColor = [UIColor darkGrayColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.descLabel.adjustsFontSizeToFitWidth = YES;
        self.descLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat topBottomMargin = ktopBottomMargin;
    CGFloat leftRightMargin = kleftRightMargin;
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat hegiht = self.contentView.bounds.size.height;
    CGFloat titleHeiht = ceil([self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height);
    
    CGFloat descHeiht = ceil([self.descLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kleftRightMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : ZBDebuggerNetworkDetailCell_descLabel_Font} context:nil].size.height);
    
    self.titleLabel.frame = CGRectMake(leftRightMargin, topBottomMargin, width - 2*leftRightMargin , titleHeiht);
    self.descLabel.frame = CGRectMake(leftRightMargin, hegiht - topBottomMargin - descHeiht , width - 2*leftRightMargin, descHeiht);
    
    
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
}

#pragma mark - lazy
-  (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font =ZBDebuggerNetworkDetailCell_titleLabel_Font;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"主地址API";
    }
    return _titleLabel;
}

-  (UILabel *)descLabel
{
    if(_descLabel == nil)
    {
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = ZBDebuggerNetworkDetailCell_descLabel_Font;
        _descLabel.textColor = [UIColor lightTextColor];
        _descLabel.text = @"描述";
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

-(UIView *)bottomLine
{
    if(_bottomLine == nil)
    {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor darkGrayColor];
    }
    return _bottomLine;
}




@end
