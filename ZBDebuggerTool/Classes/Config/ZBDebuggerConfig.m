//
//  ZBDebuggerConfig.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerConfig.h"

static  ZBDebuggerConfig *_instanceConfig = nil;

@implementation ZBDebuggerConfig
/**
 默认配置
 */
+ (instancetype)defaultDebuggerConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceConfig = [[ZBDebuggerConfig alloc]init];
          [_instanceConfig setupInitial];
    });
    return _instanceConfig;
}


#pragma mark - puplic
- (void)setBallDiameter:(CGFloat)ballDiameter
{
    if(ballDiameter < ZBDEBUGGERWINDOW_MIN_DIAMETER){
        ballDiameter = ZBDEBUGGERWINDOW_MIN_DIAMETER;
    }
    _ballDiameter = ballDiameter;
    

}


#pragma mark - private
- (void)setupInitial
{
    
     //window
    self.isSuportMoveEnabled = YES;
    self.ballDiameter = ZBDEBUGGERWINDOW_MIN_DIAMETER;
    self.ballInitFrameX = ZBDEBUGGERWINDOW_MIN_WINDOWX;
    self.ballInitFrameY = ZBDEBUGGERWINDOW_MIN_WINDOWY;
    self.ballNormalAlpha = 1.0;
    self.ballActiveAlpha = 0.9;

    self.ballThemeColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    self.ballBackgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    
    self.useIdentity = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    //crash
    self.enableCrashSendEmail = NO;
    self.emailAddress = @"1835064412@qq.com";
    
}
@end
