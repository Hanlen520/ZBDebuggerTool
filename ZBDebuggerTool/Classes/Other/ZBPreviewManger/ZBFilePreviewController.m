//
//  ZBFilePreviewController.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBFilePreviewController.h"

@interface ZBFilePreviewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) NSArray <NSString *> *filePaths;

//动画类型
@property (nonatomic, assign) ZBFilePreviewControllerAnimationType animationType;

//源控制器
@property (nonatomic, strong) UIViewController *sourceVC;
@end

@implementation ZBFilePreviewController
- (instancetype)init
{
    if(self = [super init])
    {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}
/**
 预览单个文件
 
 @param filePath 文件路径
 @param sourceVC 源控制器
 */
- (void)previewFileWithPath:(NSString *)filePath soureViewController:(UIViewController *)sourceVC
{
    [self previewMoreFileWithPaths:@[filePath] currentIndex:0 jumpAnimationType:ZBFilePreviewControllerAnimationType_Present soureViewController:sourceVC];
}

/**
 预览多个文件 - 单个文件
 
 @param filePaths 文件路径数组
 @param currentIndex 当前是第几文件
 @param animationType 动画类型
 @param sourceVC 源控制器
 */
- (void)previewMoreFileWithPaths:(NSArray <NSString *> *)filePaths currentIndex:(NSInteger)currentIndex jumpAnimationType:(ZBFilePreviewControllerAnimationType)animationType soureViewController:(UIViewController *)sourceVC
{
    if(filePaths.count == 0) return;
    if(sourceVC == nil) return;
    if(currentIndex >= filePaths.count){
        currentIndex = 0;
    }
    
    self.filePaths = filePaths;
    self.animationType = animationType;
    self.sourceVC = sourceVC;
    
    
    self.currentPreviewItemIndex = currentIndex;
}


- (void)jumpPreviewViewController
{
    switch (self.animationType) {
        case ZBFilePreviewControllerAnimationType_Present:
            [self.sourceVC presentViewController:self animated:YES completion:nil];
            break;
        case ZBFilePreviewControllerAnimationType_Push:
            [self.sourceVC.navigationController pushViewController:self animated:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    NSInteger count = self.filePaths.count;
    return count;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if(index < self.filePaths.count){
        NSURL *url = [NSURL fileURLWithPath:self.filePaths[index]];
        return  url;
    }else{
        return nil;
    }
    
}

#pragma mark - QLPreviewControllerDelegate
- (void)previewControllerWillDismiss:(QLPreviewController *)controller
{
     if(self.willDismissBlock)
         self.willDismissBlock(self);
}
- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    if(self.didDismissBlock)
        self.didDismissBlock(self);
}

@end
