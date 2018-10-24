//
//  ZBDebuggerSandboxCell.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerSandboxCell.h"
#import "ZBDebuggerConfig.h"
#import "ZBDebuggerUntil.h"

@interface ZBDebuggerSandboxCell()
@property (strong, nonatomic)  UIImageView *iconImageV;
@property (strong, nonatomic)  UILabel *fileNameLabel;
@property (strong, nonatomic)  UILabel *fileSizeLabel;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (nonatomic, strong)  UIView *line;

@end

@implementation ZBDebuggerSandboxCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.fileNameLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
        
        [self.contentView addSubview:self.iconImageV];
        [self.contentView addSubview:self.fileNameLabel];
        [self.contentView addSubview:self.fileSizeLabel];
        [self.contentView addSubview:self.dateLabel];
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

    self.iconImageV.frame = CGRectMake(leftRightMargin, topBottomMargin, 30, 30);
    
    CGSize fileNameSize = [self.fileNameLabel.text sizeWithAttributes:@{NSFontAttributeName : self.fileNameLabel.font}];
    self.fileNameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageV.frame) +topBottomMargin , topBottomMargin, ceil(fileNameSize.width), ceil(fileNameSize.height));
    
    CGSize fileSizeSize = [self.fileSizeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.fileSizeLabel.font}];
    self.fileSizeLabel.frame = CGRectMake(self.fileNameLabel.frame.origin.x, CGRectGetMaxY( self.fileNameLabel.frame) + 5, ceil(fileSizeSize.width), ceil(fileSizeSize.height));
    
    CGSize dateTimeSize = [self.dateLabel.text sizeWithAttributes:@{NSFontAttributeName : self.dateLabel.font}];
    
     self.dateLabel.frame = CGRectMake(width - ceil(dateTimeSize.width) - leftRightMargin, CGRectGetMaxY( self.fileNameLabel.frame) + 5, ceil(dateTimeSize.width), ceil(dateTimeSize.height));
    
    
    self.line.frame = CGRectMake(leftRightMargin, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
}

- (void)setSandoxModel:(ZBDebuggerSandboxModel *)sandoxModel
{
    
    _sandoxModel = sandoxModel;
    self.fileNameLabel.text = sandoxModel.fileName;
    if(sandoxModel.isDirectory){
         self.fileSizeLabel.text = [NSString stringWithFormat:@"文件大小:%@",[sandoxModel fileSizeString]];
    }else
    {
         self.fileSizeLabel.text = [NSString stringWithFormat:@"文件类型:%@",sandoxModel.fileTypeDesc];
    }
   
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[[ZBDebuggerUntil sharedDebuggerUntil] stringFromDate:sandoxModel.fileModificationDate]];
    if (sandoxModel.isDirectory && sandoxModel.subModels.count > 0) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    if(sandoxModel.isDirectory){
        
        self.iconImageV.image = [[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppSandoxImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
      self.iconImageV.image = [[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppSandboxFileImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}


#pragma mark - lazy

-  (UILabel *)fileNameLabel
{
    if(_fileNameLabel == nil)
    {
        _fileNameLabel = [[UILabel alloc]init];
        _fileNameLabel.font = titleLabel_Font;
        _fileNameLabel.textColor = [UIColor blackColor];
        _fileNameLabel.text = @"主地址API";
    }
    return _fileNameLabel;
}

-  (UILabel *)fileSizeLabel
{
    if(_fileSizeLabel == nil)
    {
        _fileSizeLabel = [[UILabel alloc]init];
        _fileSizeLabel.font = descLabel_Font;
        _fileSizeLabel.textColor = [UIColor lightGrayColor];
        _fileSizeLabel.text = @"描述";
    }
    return _fileSizeLabel;
}
-  (UILabel *)dateLabel
{
    if(_dateLabel == nil)
    {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = dateLabel_Font;
        _dateLabel.textColor = [UIColor redColor];
        _dateLabel.text = @"时间";
    }
    return _dateLabel;
}

- (UIImageView *)iconImageV
{
    if(_iconImageV == nil)
    {
        _iconImageV = [[UIImageView alloc]init];
        _iconImageV.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageV.clipsToBounds = YES;
        _iconImageV.image = [[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppSandoxImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _iconImageV;
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
