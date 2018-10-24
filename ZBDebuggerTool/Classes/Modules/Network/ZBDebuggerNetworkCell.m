//
//  ZBDebuggerNetworkCell.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkCell.h"

#import "ZBDebuggerConfig.h"

@interface ZBDebuggerNetworkCell()
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *descLabel;

@property (strong, nonatomic)  UILabel *dateTimeLabel;

@property (nonatomic, strong)  UIView *line;
@end

@implementation ZBDebuggerNetworkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.line];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dateTimeLabel];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat topBottomMargin = 10;
    CGFloat leftRightMargin = 15;
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat hegiht = self.contentView.bounds.size.height;
    CGFloat titleHeiht = ceil([self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height);
    CGFloat descHeiht = ceil([self.descLabel.text sizeWithAttributes:@{NSFontAttributeName : self.descLabel.font}].height);
    
    self.titleLabel.frame = CGRectMake(leftRightMargin, topBottomMargin, width - 2*leftRightMargin , titleHeiht);
    self.descLabel.frame = CGRectMake(leftRightMargin, hegiht - topBottomMargin - descHeiht , width - 2*leftRightMargin, descHeiht);
    
    CGSize dateTimeSize = [self.dateTimeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.dateTimeLabel.font}];
   
    
    self.dateTimeLabel.frame = CGRectMake(width -ceil(dateTimeSize.width) - leftRightMargin , (hegiht - ceil(dateTimeSize.height))*0.5, ceil(dateTimeSize.width), ceil(dateTimeSize.height));
    
    
    self.line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
}


- (void)setNetworkModel:(ZBDebuggerNetworkModel *)networkModel
{
    _networkModel = networkModel;
    self.titleLabel.text = networkModel.url.host;
    self.descLabel.text = networkModel.url.path;
    self.dateTimeLabel.text = [networkModel.requestStartDate substringFromIndex:11];
}

+ (CGFloat)getDebuggerNetworkCellHeight
{
    return 70;
}


#pragma mark - lazy
-  (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
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
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        _descLabel.textColor = [UIColor lightTextColor];
        _descLabel.text = @"描述";
    }
    return _descLabel;
}
-  (UILabel *)dateTimeLabel
{
    if(_dateTimeLabel == nil)
    {
        _dateTimeLabel = [[UILabel alloc]init];
        _dateTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _dateTimeLabel.textColor = [UIColor lightTextColor];
        _dateTimeLabel.text = @"时间";
    }
    return _dateTimeLabel;
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
