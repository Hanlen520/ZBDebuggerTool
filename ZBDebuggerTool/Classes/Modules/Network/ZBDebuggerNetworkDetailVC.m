//
//  ZBDebuggerNetworkDetailVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkDetailVC.h"
#import "ZBDebuggerUntil.h"
#import "ZBDebuggerNetworkDetailCell.h"

@interface ZBDebuggerNetworkDetailVC ()

@property (nonatomic, strong) NSMutableArray <NSDictionary *>*dataList;
@end

@implementation ZBDebuggerNetworkDetailVC

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
    NSDictionary *url_dict = @{
                               @"key":@"请求 URL",
                               @"value":self.networkModel.url.absoluteString?:@"Unknow",
                               };
    [self.dataList addObject:url_dict];
    
    if(self.networkModel.method.length > 0){
        NSDictionary *method_dict = @{
                                      @"key":@"请求 Method",
                                      @"value":self.networkModel.method,
                                      };
        [self.dataList addObject:method_dict];
    }
    
    NSDictionary *statusCode_dict = @{
                                  @"key":@"请求状态码 Status Code",
                                  @"value":self.networkModel.httpStatusCode?:@"0",
                                  };
    [self.dataList addObject:statusCode_dict];
    
    if(self.networkModel.mineType.length > 0){
        NSDictionary *mineType_dict = @{
                                          @"key":@"请求 Mine Type",
                                          @"value":self.networkModel.mineType,
                                          };
        [self.dataList addObject:mineType_dict];
    }
    
    if (self.networkModel.requestStartDate.length > 0) {
        NSDictionary *requestStartDate_dict = @{
                                        @"key":@"请求开始时间 start time",
                                        @"value":self.networkModel.requestStartDate,
                                        };
        [self.dataList addObject:requestStartDate_dict];
    }
    if (self.networkModel.requestUseTime.length > 0) {
        NSDictionary *requestuseTime_dict = @{
                                                @"key":@"请求使用时间 Use Time",
                                                @"value":self.networkModel.requestUseTime,
                                                };
        [self.dataList addObject:requestuseTime_dict];
    }
    
    //请求头
    if(self.networkModel.headerFields){
        NSMutableString *string = [[NSMutableString alloc] init];
        for (NSString *key in self.networkModel.headerFields) {
            [string appendFormat:@"%@ : %@\n",key,self.networkModel.headerFields[key]];
        }
        NSDictionary *headerFields_dict = @{
                                              @"key":@"请求头 Request Header",
                                              @"value":string,
                                              };
        [self.dataList addObject:headerFields_dict];
    }
    
    //请求体
    NSDictionary *requestBody_dict = @{
                                       @"key":@"请求参数 Request Body",
                                       @"value":self.networkModel.requestBody?:@"无参数",
                                       };
    [self.dataList addObject:requestBody_dict];
    
    //响应体
    if(self.networkModel.responseData){
        if(self.networkModel.isImage){
            NSDictionary *responseData_dict = @{
                                               @"key":@"响应返回数据 Response Data",
                                               @"value":[NSString stringWithFormat:@"图片数据%@",self.networkModel.responseData],
                                               };
            [self.dataList addObject:responseData_dict];
        }else{
            NSDictionary *responseData_dict = @{
                                                @"key":@"响应返回数据 Response Data",
                                                @"value":[[ZBDebuggerUntil sharedDebuggerUntil] jsonStringWithFromData:self.networkModel.responseData],
                                                };
            [self.dataList addObject:responseData_dict];
        }
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
