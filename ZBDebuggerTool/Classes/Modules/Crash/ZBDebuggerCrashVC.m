//
//  ZBDebuggerCrashVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerCrashVC.h"
#import "ZBDebuggerSQLManger.h"
#import "ZBDebuggerCrashModel.h"
#import "ZBDebuggerCrashListCell.h"
#import "ZBDebuggerCrashDetailVC.h"

@interface ZBDebuggerCrashVC ()
@property (nonatomic , strong) NSMutableArray <ZBDebuggerCrashModel *>*dataList;
@end

@implementation ZBDebuggerCrashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"App崩溃收集";
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBDebuggerCrashListCell" bundle:currentBundle] forCellReuseIdentifier:ZBDebuggerCrashListCellID];
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
    [[ZBDebuggerSQLManger sharedSQLManger] removeAllCrashModels];
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
}



#pragma mark - 加载数据
- (void)loadHoldupAPIData
{
    [self.dataList removeAllObjects];
    NSArray *crashModels = [[ZBDebuggerSQLManger sharedSQLManger] getAllCrashModels];
    [self.dataList addObjectsFromArray:crashModels];
    [self.tableView reloadData];
}

#pragma mark - UI

#pragma mark - UI

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =self.dataList.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBDebuggerCrashListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBDebuggerCrashListCellID];
    if(indexPath.row < self.dataList.count){
        ZBDebuggerCrashModel *model = self.dataList[indexPath.row];
        cell.resonLabel.text = model.reason;
        cell.crashNameLabel.text = model.name;
        cell.crashTimeLabel.text = model.crashDate;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataList.count){
        ZBDebuggerCrashModel *model = self.dataList[indexPath.row];
        ZBDebuggerCrashDetailVC *vc = [[ZBDebuggerCrashDetailVC alloc]init];
        vc.crashModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)setupInitNavigationBar
{
    self.isHiddrenRightButton = NO;
    [self addRightButtonSEL:@selector(rightItemTargetEvent)];
}


#pragma mark - lazy
- (NSMutableArray<ZBDebuggerCrashModel *> *)dataList
{
    if(_dataList == nil)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
