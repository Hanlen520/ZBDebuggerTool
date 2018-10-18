//
//  ZBDebuggerWindow.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerWindow.h"
#import "ZBDebuggerWindowController.h"
#import "ZBDebuggerToolMacros.h"

@interface ZBDebuggerWindow()
/**
 根控制器
 */
@property (nonatomic ,strong ) ZBDebuggerWindowController *windowRootVC;
@end



@implementation ZBDebuggerWindow

/**
 初始化悬浮球
 
 @param config 配置信息
 @return 实例对象
 */
- (instancetype)initWithSuspensionBallConfig:(ZBDebuggerConfig *)config;
{
    
    CGRect windowFrame = CGRectMake(config.ballInitFrameX,
                                    config.ballInitFrameY,
                                    config.ballDiameter,
                                    config.ballDiameter);
    if(self = [super initWithFrame:windowFrame]){
       [self setupInitSuspensionBallConfig:config];
    }
    return self;
}


/**
 显示悬浮球窗口
 */
- (void)showDebuggerWindow
{
    if(self.isHidden){
        if ([[NSThread currentThread] isMainThread]) {
            self.hidden = NO;
            [self.windowRootVC resetTabBarViewController];
            [self.windowRootVC addAppHelperObservers];
        } else {
            [self performSelectorOnMainThread:@selector(showDebuggerWindow) withObject:nil waitUntilDone:YES];
        }
    }
}

/**
 隐藏悬浮球窗口
 */
- (void)hiddenDebuggerWindow
{
    if(!self.isHidden){
        if ([[NSThread currentThread] isMainThread]) {
            self.hidden = YES;
           [self.windowRootVC removeAppHelperObservers];
            
        } else {
            [self performSelectorOnMainThread:@selector(showDebuggerWindow) withObject:nil waitUntilDone:YES];
        }
    }
}


#pragma mark - pravate
- (void)setupInitSuspensionBallConfig:(ZBDebuggerConfig *)config
{
    self.backgroundColor = [UIColor clearColor];
    
    // Set level
    self.windowLevel = UIWindowLevelAlert + 2;
    
    self.alpha = config.ballNormalAlpha;
    
    //设置根控制器
    ZBDebuggerWindowController *rootVC = [[ZBDebuggerWindowController  alloc]initWithConfig:config];
    rootVC.debuggerWindow = self;
    self.rootViewController = rootVC;
    self.windowRootVC = rootVC;
    
}

@end
