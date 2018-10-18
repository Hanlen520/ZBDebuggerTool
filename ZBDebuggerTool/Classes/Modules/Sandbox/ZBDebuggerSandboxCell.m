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
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong)  UIView *line;

@end

@implementation ZBDebuggerSandboxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.fileNameLabel.textColor = [ZBDebuggerConfig defaultDebuggerConfig].ballThemeColor;
    [self addSubview:self.line];
    self.fileSizeLabel.font = [UIFont systemFontOfSize:13.0];
    self.dateLabel.font = [UIFont systemFontOfSize:12.0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width,  0.5);
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
    
}


#pragma mark - lazy
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
