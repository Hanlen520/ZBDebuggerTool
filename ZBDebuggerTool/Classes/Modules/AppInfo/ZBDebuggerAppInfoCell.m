//
//  ZBDebuggerAppInfoCell.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerAppInfoCell.h"
#import "ZBDebuggerConfig.h"

static NSString *ZBDebuggerAppInfoCellID = @"ZBDebuggerAppInfoCellID";
@interface ZBDebuggerAppInfoCell()

@property (nonatomic, strong)  UIView *sepeleterLine;
@end

@implementation ZBDebuggerAppInfoCell

+ (ZBDebuggerAppInfoCell *)cellFortableView:(UITableView *)tableView
{
    ZBDebuggerAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBDebuggerAppInfoCellID];
    if(cell == nil){
        cell = [[ZBDebuggerAppInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZBDebuggerAppInfoCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.sepeleterLine];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat  width = self.contentView.bounds.size.width;
    CGFloat titleLabelHeight = [ZBDebuggerAppInfoCell getDebuggerAppInfoCelHeight] - 0.5;
    self.sepeleterLine.frame = CGRectMake(0,titleLabelHeight , width, 0.5);
    
    CGFloat margin  = 10;
    CGFloat titleLabelWidth = ceil([self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width);
    self.titleLabel.frame = CGRectMake(margin, 0, titleLabelWidth, titleLabelHeight);
    
    self.descLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+ margin, 0, width-titleLabelWidth-3*margin, titleLabelHeight);
}


#pragma mark -  lazy
+ (CGFloat)getDebuggerAppInfoCelHeight
{
    return 50;
}
- (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _titleLabel;
}
- (UILabel *)descLabel
{
    if(_descLabel == nil)
    {
        _descLabel = [UILabel new];
        _descLabel.textColor =[ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
        _descLabel.textAlignment = NSTextAlignmentRight;
        _descLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _descLabel;
}

- (UIView *)sepeleterLine
{
    if(_sepeleterLine == nil)
    {
        _sepeleterLine = [UIView new];
        _sepeleterLine.backgroundColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0];
    }
    return _sepeleterLine;
}
@end
