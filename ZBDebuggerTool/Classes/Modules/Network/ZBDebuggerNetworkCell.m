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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (nonatomic, strong)  UIView *line;
@end

@implementation ZBDebuggerNetworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.line];
    self.descLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
