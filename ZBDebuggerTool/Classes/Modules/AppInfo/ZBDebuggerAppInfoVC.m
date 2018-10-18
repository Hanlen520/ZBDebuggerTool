//
//  ZBDebuggerAppInfoVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerAppInfoVC.h"
#import "ZBDebuggerAppInfoCell.h"

@interface ZBDebuggerAppInfoVC ()

@end

@implementation ZBDebuggerAppInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [UIDevice currentDevice].name ? : @"App信息";
    
    [self addAppHelperObservers];
    
}

#pragma mark - 观察者
- (void)addAppHelperObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateAppInfoNotificatioEvent:) name:ZBAppDidUpdateAppInfosNotificationName object:nil];
}

- (void)removeAppHelperObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZBAppDidUpdateAppInfosNotificationName object:nil];
}

- (void)didUpdateAppInfoNotificatioEvent:(NSNotification *)note
{
    [self.tableView reloadData];
    
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[ZBDebuggerAppInfoHelper shareHelper] getAppInfos].count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBDebuggerAppInfoCell *cell = [ZBDebuggerAppInfoCell cellFortableView:tableView];
    NSArray *dataList =  [[ZBDebuggerAppInfoHelper shareHelper] getAppInfos];
    if(indexPath.row <dataList.count){
        NSDictionary *dict = dataList[indexPath.row];
        cell.titleLabel.text = dict[@"name"];
        cell.descLabel.text = [NSString stringWithFormat:@"%@",dict[@"value"]];
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZBDebuggerAppInfoCell getDebuggerAppInfoCelHeight];
}



- (void)dealloc
{
    [self removeAppHelperObservers];
}


@end
