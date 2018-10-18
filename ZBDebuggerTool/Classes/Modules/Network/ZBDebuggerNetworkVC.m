//
//  ZBDebuggerNetworkVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkVC.h"
#import "ZBDebuggerNetworkCell.h"
#import "ZBDebuggerNetworkHelper.h"
#import "ZBDebuggerSQLManger.h"
#import "ZBDebuggerNetworkDetailVC.h"

@interface ZBDebuggerNetworkVC ()

@property (nonatomic , strong) NSMutableArray *httpRequestArray;

@end

@implementation ZBDebuggerNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"调用API数据";
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBDebuggerNetworkCell" bundle:currentBundle] forCellReuseIdentifier:ZBDebuggerNetworkCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupInitNavigationBar];
    [self loadHoldupAPIData];
}


#pragma mark - 事件
- (void)rightItemTargetEvent
{
    [self showCenterAlertWithMessage:@"您确定要删除所有数据?" hanlder:^(NSInteger actionIndex) {
        if(actionIndex == 1){
            [self deleteAllDataList];
        }else{
            
        }
    }];
}

//删除列表
- (void)deleteAllDataList
{
   //移除数据库
    [[ZBDebuggerSQLManger sharedSQLManger] removeAllNetworkModels];
    [self.httpRequestArray removeAllObjects];
    [self.tableView reloadData];
}




#pragma mark - 加载数据
- (void)loadHoldupAPIData
{
    [self.httpRequestArray removeAllObjects];
    NSArray *networkModels = [[ZBDebuggerSQLManger sharedSQLManger] getAllNetworkModels];
    [self.httpRequestArray addObjectsFromArray:networkModels];
    [self.tableView reloadData];
}


#pragma mark - UI

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =self.httpRequestArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBDebuggerNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBDebuggerNetworkCellID];
    if(indexPath.row < self.httpRequestArray.count){
        ZBDebuggerNetworkModel *model = self.httpRequestArray[indexPath.row];
        cell.networkModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZBDebuggerNetworkCell getDebuggerNetworkCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.httpRequestArray.count){
        ZBDebuggerNetworkModel *model = self.httpRequestArray[indexPath.row];
        ZBDebuggerNetworkDetailVC *vc = [[ZBDebuggerNetworkDetailVC alloc]init];
        vc.networkModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)setupInitNavigationBar
{
    self.isHiddrenRightButton = NO;
    [self addRightButtonSEL:@selector(rightItemTargetEvent)];
}


#pragma mark - lazy
- (NSMutableArray *)httpRequestArray
{
    if(_httpRequestArray == nil)
    {
        _httpRequestArray = [NSMutableArray array];
    }
    return _httpRequestArray;
}


@end
