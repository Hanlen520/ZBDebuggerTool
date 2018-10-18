//
//  ZBFilePreviewController.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//  文件预览

#import <QuickLook/QuickLook.h>


typedef NS_ENUM(NSInteger, ZBFilePreviewControllerAnimationType)
{
    ZBFilePreviewControllerAnimationType_Present = 0, //present动画
    ZBFilePreviewControllerAnimationType_Push = 1, //push动画
};

@interface ZBFilePreviewController : QLPreviewController

/**
 预览单个文件
 
 @param filePath 文件路径
 @param sourceVC 源控制器
 */
- (void)previewFileWithPath:(NSString *)filePath soureViewController:(UIViewController *)sourceVC;

/**
 预览多个文件 - 单个文件

 @param filePaths 文件路径数组
 @param currentIndex 当前是第几文件
 @param animationType 动画类型
 @param sourceVC 源控制器
 */
- (void)previewMoreFileWithPaths:(NSArray <NSString *> *)filePaths currentIndex:(NSInteger)currentIndex jumpAnimationType:(ZBFilePreviewControllerAnimationType)animationType soureViewController:(UIViewController *)sourceVC;




/**
  将要消失回调
 */
@property (nonatomic, copy)  void(^willDismissBlock)(ZBFilePreviewController *vc);
- (void)setWillDismissBlock:(void (^)(ZBFilePreviewController *vc))willDismissBlock;



/**
 已经退出回调
 */
@property (nonatomic, copy)  void(^didDismissBlock)(ZBFilePreviewController *vc);
- (void)setDidDismissBlock:(void (^)(ZBFilePreviewController *))didDismissBlock;

@end
