//
//  ZBDebuggerNetworkDetailVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerCrashDetailVC.h"
#import "ZBDebuggerUntil.h"
#import "ZBDebuggerNetworkDetailCell.h"

@interface ZBDebuggerCrashDetailVC ()

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*dataList;
@end

@implementation ZBDebuggerCrashDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitinal];
    
}


#pragma mark - UI

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =self.dataList.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBDebuggerNetworkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBDebuggerNetworkDetailCellID];
    if(indexPath.row < self.dataList.count){
        NSDictionary *dict = self.dataList[indexPath.row];
        cell.titleLabel.text = dict[@"key"];
        cell.descLabel.text = dict[@"value"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataList.count){
        NSDictionary *dict = self.dataList[indexPath.row];
        NSString *valueString = dict[@"value"];
        [UIPasteboard generalPasteboard].string = valueString;
        [self showToastMessage:[NSString stringWithFormat:@"复制成功:%@",valueString]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataList.count){
        NSDictionary *dict = self.dataList[indexPath.row];
        NSNumber *height= dict[@"height"];
        CGFloat cellHeight = [height floatValue];
        return cellHeight;
        
    }else
        return CGFLOAT_MIN;
}




#pragma mark - 初始化数据
- (void)setupInitinal
{
    self.navigationItem.title = @"crash详情";
    
   [self.tableView registerClass:[ZBDebuggerNetworkDetailCell class] forCellReuseIdentifier:ZBDebuggerNetworkDetailCellID];
    
    
    //把模型转化为数组
    dispatch_queue_t queue = dispatch_queue_create("com.chuanxing2.com", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSDictionary *crashName_dict = @{
                                         @"key":@"崩溃名称:crash Name",
                                         @"value":self.crashModel.name?:@"Unknow",
                                         @"height":[self computeHeightWithString:@"崩溃名称:crash Name" desc:self.crashModel.name?:@"Unknow"],
                                         };
        [self.dataList addObject:crashName_dict];
        
        if(self.crashModel.reason.length > 0){
            NSDictionary *reason_dict = @{
                                          @"key":@"崩溃原因：Crash Reason",
                                          @"value":self.crashModel.reason,
                                          @"height":[self computeHeightWithString:@"崩溃原因：Crash Reason" desc:self.crashModel.reason],
                                          };
            [self.dataList addObject:reason_dict];
        }
        
        NSDictionary *crashDate_dict = @{
                                         @"key":@"崩溃时间: Crash Time",
                                         @"value":self.crashModel.crashDate,
                                         @"height":[self computeHeightWithString:@"崩溃时间: Crash Time" desc:self.crashModel.crashDate],
                                         };
        [self.dataList addObject:crashDate_dict];
        
        if(self.crashModel.userInfo){
            NSMutableString *content = [[NSMutableString alloc] init];
            for (NSString *key in self.crashModel.userInfo.allKeys) {
                [content appendFormat:@"%@ : %@\n",key,self.crashModel.userInfo[key]];
            }
            NSDictionary *userInfo_dict = @{
                                            @"key":@"崩溃userInfo ",
                                            @"value":content,
                                            @"height":[self computeHeightWithString:@"崩溃userInfo " desc:content],
                                            };
            [self.dataList addObject:userInfo_dict];
        }
        
        if (self.crashModel.appInfos.count > 0) {
            NSMutableString *str = [[NSMutableString alloc] init];
            for (NSDictionary *dic in self.crashModel.appInfos) {
                [str appendFormat:@"%@ : %@\n",dic[@"name"],dic[@"value"]];
                [str appendString:@"\n"];
            }
            NSDictionary *appInfo_dict = @{
                                           @"key":@"App信息 ",
                                           @"value":str,
                                           @"height":[self computeHeightWithString:@"App信息 "desc:str],
                                           };
            [self.dataList addObject:appInfo_dict];
        }
        
        
        //堆栈信息
        if (self.crashModel.stackSymbols.count) {
            
            NSMutableString *mutStr = [[NSMutableString alloc] init];
            for (NSString *symbol in self.crashModel.stackSymbols) {
                [mutStr appendFormat:@"%@\n\n",symbol];
            }
            NSDictionary *stact_dict = @{
                                         @"key":@"堆栈信息: Stack Symbols ",
                                         @"value":mutStr,
                                         @"height":[self computeHeightWithString:@"堆栈信息: Stack Symbols " desc:mutStr],
                                         };
            [self.dataList addObject:stact_dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
   
   
   
    
}

- (NSNumber *)computeHeightWithString:(NSString *)title desc:(NSString *)desc
{
    CGFloat cellHeight =  ktopBottomMargin;
    CGFloat titleHeight = ceil([title sizeWithAttributes:@{NSFontAttributeName : ZBDebuggerNetworkDetailCell_titleLabel_Font}].height);
    cellHeight  = cellHeight + titleHeight;
    
    CGFloat descHeiht = ceil([desc boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kleftRightMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : ZBDebuggerNetworkDetailCell_descLabel_Font} context:nil].size.height);
    cellHeight  = cellHeight + descHeiht + ktopBottomMargin;
    cellHeight  = cellHeight+ ktopBottomMargin;
    return @(cellHeight);
}


#pragma mark - lazy
- (NSMutableArray<NSDictionary *> *)dataList
{
    if(_dataList == nil)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end

