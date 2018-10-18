//
//  ZBDebuggerWindowController.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerWindowController.h"
#import "ZBDebuggerNavigationController.h"
#import "ZBDebuggerAppInfoVC.h"
#import "ZBDebuggerCrashVC.h"
#import "ZBDebuggerNetworkVC.h"
#import "ZBDebuggerSandboxVC.h"
#import "ZBDebuggerUntil.h"


@interface ZBDebuggerWindowController ()

@property (nonatomic, strong)  ZBDebuggerConfig *config;

//UI
@property (nonatomic, strong) UIView *ballContainerView;
//fps
@property (nonatomic, strong) UILabel *fpsLabel;
//fpsLine
@property (nonatomic, strong) UIView *fpsLine;
//memoryLabel
@property (nonatomic, strong) UILabel *memoryLabel;
//memoryLine
@property (nonatomic, strong) UIView *memoryLine;
//cpuLabel
@property (nonatomic, strong) UILabel *cpuLabel;

@property (nonatomic , strong) UITabBarController *tabBarVC;
@end

@implementation ZBDebuggerWindowController
- (instancetype)initWithConfig:(ZBDebuggerConfig *)config
{
    if(self = [super init]){
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.config.ballDiameter, self.config.ballDiameter);
    [self setupInitialUI];
    
}


#pragma mark - 事件
//滑动事件
- (void)panBallContainerViewGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    if(!self.config.isSuportMoveEnabled) return;
    
    CGPoint panPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            {
                [self startActive];
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                [self changeActiveWithPoint:panPoint];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            {
               [self stopActive];
            }
            
            break;
        default:
            break;
    }
}

//tap事件
- (void)tapBallContainerViewGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if([NSThread isMainThread]){
        [self gotoMainTabbarViewController];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self gotoMainTabbarViewController];
        });
    }
}

- (void)gotoMainTabbarViewController
{
    [self.debuggerWindow hiddenDebuggerWindow];
    
    UIViewController *currentRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = currentRootVC.presentedViewController;
    UIViewController *soureVC = currentVC ? currentVC : currentRootVC;
    [soureVC  presentViewController:self.tabBarVC animated:YES completion:nil];
}

- (void)resetTabBarViewController
{
    self.tabBarVC = nil;
}


#pragma mark - 移动事件
- (void)startActive
{
    self.debuggerWindow.alpha = self.config.ballActiveAlpha;
}

- (void)stopActive
{
    __weak typeof(self)  weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf ballStopAnination];
    } completion:^(BOOL finished) {
        weakSelf.debuggerWindow.alpha = weakSelf.config.ballNormalAlpha;
    }];
}

- (void)changeActiveWithPoint:(CGPoint)point
{
    //宽度
    if(point.x < 0){
        point.x = 0;
    }else if(point.x > ZBDEBUGGER_SCREEN_WIDTH){
        point.x = ZBDEBUGGER_SCREEN_WIDTH;
    }
    
    //高度
    if(point.y < 0){
        point.y = 0;
    }else if(point.y > ZBDEBUGGER_SCREEN_HEIGHT){
        point.y = ZBDEBUGGER_SCREEN_HEIGHT;
    }
    
    self.debuggerWindow.center = point;
}

//停止动画
- (void)ballStopAnination
{
    CGFloat centerX = self.debuggerWindow.center.x;
    CGFloat centerY = self.debuggerWindow.center.y;
    CGFloat defaultCenterX = ZBDEBUGGER_SCREEN_WIDTH * 0.5;
    CGFloat defaultCenterY = ZBDEBUGGER_SCREEN_HEIGHT * 0.5;
    
    CGFloat distanceX = defaultCenterX > centerX ? centerX : ZBDEBUGGER_SCREEN_WIDTH - centerX;
    CGFloat distanceY = defaultCenterY > centerY ? centerY : ZBDEBUGGER_SCREEN_HEIGHT - centerY;
    
    CGPoint resultPoint = CGPointZero;
    
    if(distanceX >= distanceY){
        //顶部和底部
        resultPoint.x = centerX;
        if(defaultCenterY > centerY){
            //top
            resultPoint.y = self.debuggerWindow.bounds.size.height *0.5;
        }else{
            //bottom
            resultPoint.y = ZBDEBUGGER_SCREEN_HEIGHT - self.debuggerWindow.bounds.size.height *0.5;
        }
    }else{
        //left right
        resultPoint.y = centerY;
        if (defaultCenterX < centerX) {
            resultPoint.x = ZBDEBUGGER_SCREEN_WIDTH - self.debuggerWindow.bounds.size.width*0.5;
        } else {
            resultPoint.x = self.debuggerWindow.bounds.size.width*0.5;
        }
    }
    self.debuggerWindow.center = resultPoint;
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
    //更新UI
    NSDictionary *appInfo = note.userInfo;
    CGFloat cpu = [[appInfo valueForKey:ZBAppInfoHelperCPUKey] floatValue];
    CGFloat fps = [[appInfo valueForKey:ZBAppInfoHelperFPSKey] floatValue];
    long long useMemory = [[appInfo valueForKey:ZBAppInfoHelperUsedMemoryKey] longLongValue];
    
    self.fpsLabel.text = [NSString stringWithFormat:@"%ld FPS",(long)fps];
    self.cpuLabel.text = [NSString stringWithFormat:@"CPU:%0.2f%%",cpu];
    self.memoryLabel.text = [NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:useMemory countStyle:NSByteCountFormatterCountStyleMemory]];

}




#pragma mark - UI
- (void)setupInitialUI
{
    [self.view addSubview:self.ballContainerView];
    
    CGFloat lineheight = 0.5;
    CGFloat labelHeight = self.config.ballDiameter/3;
    CGFloat ballWidth = self.config.ballDiameter;
    
    //FPS
    self.fpsLabel.frame = CGRectMake(0, 0, ballWidth, labelHeight-lineheight);
    [self.ballContainerView addSubview:self.fpsLabel];
    
    self.fpsLine.frame = CGRectMake(0, CGRectGetMaxY(self.fpsLabel.frame), ballWidth, lineheight);
    [self.ballContainerView addSubview:self.fpsLine];
   
    //CPU
    self.cpuLabel.frame = CGRectMake(0, CGRectGetMaxY(self.fpsLabel.frame), ballWidth, labelHeight-0.5);
    [self.ballContainerView addSubview:self.cpuLabel];
    self.memoryLine.frame = CGRectMake(0, CGRectGetMaxY(self.cpuLabel.frame), ballWidth, lineheight);
    [self.ballContainerView addSubview:self.memoryLine];
    
    
    //内存
    self.memoryLabel.frame = CGRectMake(0, CGRectGetMaxY(self.cpuLabel.frame), ballWidth, labelHeight);
    [self.ballContainerView addSubview:self.memoryLabel];
}



#pragma mark - lazy
- (UIView *)ballContainerView
{
    if(_ballContainerView == nil)
    {
        _ballContainerView = [[UIView alloc]initWithFrame:self.view.bounds];
        _ballContainerView.backgroundColor = self.config.ballBackgroundColor;
        _ballContainerView.layer.cornerRadius = self.config.ballDiameter *0.5;
        _ballContainerView.layer.borderWidth = 2;
        _ballContainerView.layer.borderColor = self.config.ballThemeColor.CGColor;
        _ballContainerView.layer.masksToBounds = YES;
        [_ballContainerView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBallContainerViewGestureRecognizer:)]];
        
        [_ballContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBallContainerViewGestureRecognizer:)]];
    }
    return _ballContainerView;
}
- (UILabel *)fpsLabel
{
    if(_fpsLabel == nil)
    {
        _fpsLabel = [[UILabel alloc]init];
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.font = [UIFont systemFontOfSize:11.0];
        _fpsLabel.textColor = self.config.ballThemeColor;
        _fpsLabel.text = @"Loading";
    }
    return _fpsLabel;
}
- (UILabel *)memoryLabel
{
    if(_memoryLabel == nil)
    {
        _memoryLabel = [[UILabel alloc]init];
        _memoryLabel.textAlignment = NSTextAlignmentCenter;
        _memoryLabel.font = self.fpsLabel.font;
        _memoryLabel.textColor = self.fpsLabel.textColor;
        _memoryLabel.text = @"Loading";
    }
    return _memoryLabel;
}
- (UILabel *)cpuLabel
{
    if(_cpuLabel == nil)
    {
        _cpuLabel = [[UILabel alloc]init];
        _cpuLabel.textAlignment = NSTextAlignmentCenter;
        _cpuLabel.font = self.fpsLabel.font;
        _cpuLabel.textColor = self.fpsLabel.textColor;
        _cpuLabel.text = @"Loading";
    }
    return _cpuLabel;
}

- (UIView *)fpsLine
{
    if(_fpsLine == nil){
        _fpsLine = [[UIView alloc]init];
        _fpsLine.backgroundColor = self.fpsLabel.textColor;
    }
    return _fpsLine;
}
- (UIView *)memoryLine
{
    if(_memoryLine == nil){
        _memoryLine = [[UIView alloc]init];
        _memoryLine.backgroundColor = self.fpsLabel.textColor;
    }
    return _memoryLine;
}

- (UITabBarController *)tabBarVC
{
    if(_tabBarVC == nil)
    {
        _tabBarVC = [[UITabBarController alloc]init];
        
        //network
        ZBDebuggerNetworkVC *networkVC = [[ZBDebuggerNetworkVC alloc]init];
        ZBDebuggerNavigationController *networkNaviVC= [self addChildVC:networkVC Title:@"API" normalImageName:kAppNetworkImageName selectedImageName:kAppNetworkImageName];
        [_tabBarVC addChildViewController:networkNaviVC];
        
         //appinfo
        ZBDebuggerAppInfoVC *appinfo = [[ZBDebuggerAppInfoVC alloc]init];
        ZBDebuggerNavigationController *appinfoNaviVC= [self addChildVC:appinfo Title:@"App" normalImageName:kAppInfoImageName selectedImageName:kAppInfoImageName];
        [_tabBarVC addChildViewController:appinfoNaviVC];
        
        
        //crash
        ZBDebuggerCrashVC *crashVC = [[ZBDebuggerCrashVC alloc]init];
        ZBDebuggerNavigationController *crashNaviVC= [self addChildVC:crashVC Title:@"Crash" normalImageName:kAppCrashImageName selectedImageName:kAppCrashImageName];
        [_tabBarVC addChildViewController:crashNaviVC];
        
        //沙盒
        ZBDebuggerSandboxVC *sandboxVC = [[ZBDebuggerSandboxVC alloc]init];
        ZBDebuggerNavigationController *sandboxNaviVC= [self addChildVC:sandboxVC Title:@"沙盒" normalImageName:kAppSandoxImageName selectedImageName:kAppSandoxImageName];
        [_tabBarVC addChildViewController:sandboxNaviVC];
        
        //tabbarUI
        _tabBarVC.tabBar.tintColor = self.config.ballThemeColor;
      
        
    }
    return _tabBarVC;
}

- (ZBDebuggerNavigationController *)addChildVC:(UIViewController *)vc Title:(NSString *)title normalImageName:(NSString* )normalImageName selectedImageName:(NSString *)selectedImageName{
    ZBDebuggerNavigationController *navigationVC = [[ZBDebuggerNavigationController alloc] initWithRootViewController:vc];
    
    
    navigationVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:title
                                                 image:[[ZBDebuggerUntil imageAutoSizeBundlePathWithName:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                         selectedImage:[[ZBDebuggerUntil imageAutoSizeBundlePathWithName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    navigationVC.navigationBar.tintColor = self.config.ballThemeColor;
    
    [navigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.config.ballThemeColor}];

    
    return navigationVC;
}


@end
