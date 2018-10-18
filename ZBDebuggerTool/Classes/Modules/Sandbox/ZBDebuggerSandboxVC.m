//
//  ZBDebuggerSandboxVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerSandboxVC.h"
#import "ZBDebuggerSandboxHelper.h"
#import "ZBDebuggerSandboxCell.h"
#import "ZBFilePreviewController.h"


@interface ZBDebuggerSandboxVC ()

@end

@implementation ZBDebuggerSandboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInitNavigationBar];

}

#pragma mark - 事件
- (void)rightItemTargetEventWithIndexPaths:(NSArray *)indexPaths
{
    [self showCenterAlertWithMessage:@"您确定要删除所有数据?" hanlder:^(NSInteger actionIndex) {
        if(actionIndex == 1){
            [self deleteAllDataListWithIndexPath:indexPaths];
        }else{
            
        }
    }];
}

//删除列表
- (void)deleteAllDataListWithIndexPath:(NSArray *)indexPaths
{
    if(indexPaths.count == 0) return;
    for (NSIndexPath *indexPath in indexPaths) {
        [self deleteCellWithIndexPath:indexPath];
    }
}


//删除单个cell
- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath
{
      //删除数据
    if(indexPath.row < self.sandboxModel.subModels.count){
         ZBDebuggerSandboxModel *sandBoxModel = self.sandboxModel.subModels[indexPath.row];
        NSError *error;
        BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:sandBoxModel.filePath error:&error];
        if(ret){
             [self.sandboxModel.subModels removeObject:sandBoxModel];
            
            //删除UI
             [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}





#pragma mark - UI

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count =self.sandboxModel.subModels.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBDebuggerSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:ZBDebuggerSandboxCellID];
    if(indexPath.row < self.sandboxModel.subModels.count){
        ZBDebuggerSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
        cell.sandoxModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.sandboxModel.subModels.count) return;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZBDebuggerSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
    //目录文件夹
    if(model.isDirectory){
        if(model.subModels.count > 0){
            ZBDebuggerSandboxVC *vc = [[ZBDebuggerSandboxVC alloc] init];
            vc.sandboxModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showToastMessage:@"此文件夹是空文件"];
        }
        
    }else //不是文件夹
    {
        //可以被浏览
        if(model.isCanBePreview){
            ZBFilePreviewController *vc = [[ZBFilePreviewController alloc]init];
            [vc previewFileWithPath:model.filePath soureViewController:self];
            
        }else{
            
            //其他方式浏览
            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:model.filePath]] applicationActivities:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    
}


// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteAllDataListWithIndexPath:@[indexPath]];
    }
}

- (void)setupInitNavigationBar
{
    if(self.sandboxModel == nil){
        self.sandboxModel = [[ZBDebuggerSandboxHelper shareHelper] getCurrentSandboxHomeDirectory];
    }
    
    if (self.sandboxModel.isHomeDirectory) {
        self.navigationItem.title = @"沙盒文件";
    } else {
        self.navigationItem.title = self.sandboxModel.fileName;
    }
    
     self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBDebuggerSandboxCell" bundle:currentBundle] forCellReuseIdentifier:ZBDebuggerSandboxCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView reloadData];
}




@end
