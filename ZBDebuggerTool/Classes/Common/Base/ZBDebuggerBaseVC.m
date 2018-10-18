//
//  ZBDebuggerBaseVC.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseVC.h"


@interface ZBDebuggerBaseVC ()

@property (nonatomic, strong) UIButton *naviLeftButton;
@property (nonatomic, strong) UIButton *naviRightButton;

@property (nonatomic , strong) UILabel *toastLabel;
@end

@implementation ZBDebuggerBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupInitNavigation];
    [self setupContentUI];
    self.isHiddrenRightButton = YES;
    
}

- (void)setIsHiddrenRightButton:(BOOL)isHiddrenRightButton
{
    _isHiddrenRightButton = isHiddrenRightButton;
    self.naviRightButton.hidden = isHiddrenRightButton;
}

- (void)addRightButtonSEL:(SEL)asel
{
    [self.naviRightButton addTarget:self action:asel forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 事件
- (void)navigationBarLeftButtonEvent
{
   [[ZBDebuggerTool shareDebuggerTool].debuggerWindow showDebuggerWindow];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationBarBackEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - UI
- (void)setupInitNavigation
{
    if (self.navigationController.viewControllers.count <= 1) {
        
        
        [self.naviLeftButton setImage:[[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppCloseImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.naviLeftButton addTarget:self action:@selector(navigationBarLeftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.naviRightButton setImage:[[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppDeleteImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        
    }else{
        [self.naviLeftButton setImage:[[ZBDebuggerUntil imageAutoSizeBundlePathWithName:kAppBackImageArrowName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.naviLeftButton addTarget:self action:@selector(navigationBarBackEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.naviLeftButton.frame = CGRectMake(0, 0, 30, 30);
    self.naviRightButton.frame = self.naviLeftButton.frame;
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.naviLeftButton];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    
}

- (void)setupContentUI
{
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}






#pragma mark - lazy
- (UIButton *)naviLeftButton
{
    if(_naviLeftButton == nil)
    {
        _naviLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviLeftButton.showsTouchWhenHighlighted = NO;
        _naviLeftButton.adjustsImageWhenHighlighted = NO;
    }
    return _naviLeftButton;
}
- (UIButton *)naviRightButton
{
    if(_naviRightButton == nil)
    {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviRightButton.showsTouchWhenHighlighted = NO;
        _naviRightButton.adjustsImageWhenHighlighted = NO;
    }
    return _naviRightButton;
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ZBDEBUGGER_SCREEN_WIDTH, ZBDEBUGGER_SCREEN_HEIGHT - getRectNavAndStatusHight - 44) style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UILabel *)toastLabel
{
    if(_toastLabel == nil)
    {
        _toastLabel = [UILabel new];
        _toastLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.numberOfLines = 0;
        _toastLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _toastLabel.alpha = 0;
    }
    return _toastLabel;
}


@end


@implementation ZBDebuggerBaseVC (alert)
//显示中心弹框
- (void)showCenterAlertWithMessage:(NSString *)message hanlder:(void(^)(NSInteger actionIndex))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(0);
        }
    }];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(1);
        }
    }];
    [alert addAction:cancel];
    [alert addAction:ensure];
    [self presentViewController:alert animated:YES completion:nil];
}

//显示toast
- (void)showToastMessage:(NSString *)message{
    if(self.toastLabel){
        [self.toastLabel removeFromSuperview];
        self.toastLabel = nil;
    }
    self.toastLabel.text = message;
    CGSize toastLabelSize = [self.toastLabel.text sizeWithAttributes:@{NSFontAttributeName : self.toastLabel.font}];
    if(toastLabelSize.width > ZBDEBUGGER_SCREEN_WIDTH - 20){
        toastLabelSize.width =ZBDEBUGGER_SCREEN_WIDTH - 20;
    }
    self.toastLabel.bounds = CGRectMake(0, 0, toastLabelSize.width + 20, toastLabelSize.height + 20);
    self.toastLabel.center = CGPointMake(ZBDEBUGGER_SCREEN_WIDTH *0.5, ZBDEBUGGER_SCREEN_HEIGHT *0.5);
    self.toastLabel.layer.cornerRadius = 10;
    self.toastLabel.layer.masksToBounds = YES;
    [self.view addSubview:self.toastLabel];
    
    
    [UIView animateWithDuration:0.5 animations:^{
          self.toastLabel.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.toastLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [self.toastLabel removeFromSuperview];
            }];
        });
    }];
}

@end
