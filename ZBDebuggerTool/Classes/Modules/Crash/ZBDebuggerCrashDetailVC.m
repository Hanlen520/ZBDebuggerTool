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




#pragma mark - 初始化数据
- (void)setupInitinal
{
    self.navigationItem.title = @"API详情";
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBDebuggerNetworkDetailCell" bundle:currentBundle] forCellReuseIdentifier:ZBDebuggerNetworkDetailCellID];
    
    
    //把模型转化为数组
    NSDictionary *crashName_dict = @{
                                     @"key":@"崩溃名称:crash Name",
                               @"value":self.crashModel.name?:@"Unknow",
                               };
    [self.dataList addObject:crashName_dict];
    
    if(self.crashModel.reason.length > 0){
        NSDictionary *reason_dict = @{
                                      @"key":@"崩溃原因：Crash Reason",
                                      @"value":self.crashModel.reason,
                                      };
        [self.dataList addObject:reason_dict];
    }
    
    NSDictionary *crashDate_dict = @{
                                      @"key":@"崩溃时间: Crash Time",
                                      @"value":self.crashModel.crashDate,
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
                                       };
        [self.dataList addObject:stact_dict];
    }
   
   
    [self.tableView reloadData];
    
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

