//
//  UMAnalysisController.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/6/15.
//  Copyright © 2016年 DayDayCook. All rights reserved.
//

#import "UMAnalysisController.h"
#import "NetworkLoadView.h"

@interface UMAnalysisController() <ReloadRequestDelegate>
{
    NetworkLoadView   *_networkView;
    CGRect             _networkViewRect;
}

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, copy) NSString *lastNetworkState;
@property (nonatomic, copy) NSSet    *vcSet;

@end

@implementation UMAnalysisController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:[self needHiddenBarInViewControllerName:NSStringFromClass([self class])] animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _networkViewRect = CGRectNull;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    self.lastNetworkState = [Tools getNetWorkState];
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (r.currentReachabilityStatus == ReachableViaWiFi) {
        self.lastNetworkState = @"WIFI";
    }else if(r.currentReachabilityStatus == NotReachable){
        self.lastNetworkState = @"无网络";
    }
    _statusBarStyle = UIStatusBarStyleDefault;
    _statusBarHidden = NO;
}

- (void)networkStatusChanged:(NSNotification *)noti
{
    Reachability *r = (Reachability *)noti.object;
//    if (r.isReachable) {
    
            if ([self networkChangedTrendWithCurData:r]) {
                 [self reloadPage];
            }
        
//    }
}

- (BOOL)networkChangedTrendWithCurData:(Reachability *)data
{
    NSInteger last = 0;
    if ([self.lastNetworkState containsString:@"G"]) {
        last = [self.lastNetworkState integerValue];
    }else if([self.lastNetworkState containsString:@"WIFI"]){
        last = 4;
    }
    
    NSInteger cur = 0;
    NSString *curState = [Tools getNetWorkState];
    if ([curState containsString:@"G"]) {
        cur = [curState integerValue];
    }else if([curState containsString:@"WIFI"]){
        cur = 4;
    }
    
    switch(data.currentReachabilityStatus)
    {
            case NotReachable:
                cur = 0;
            break;
            
            case ReachableViaWiFi:
                cur = 4;
            break;
        
            default:
            break;
    }
    
    if (last < cur || last > cur) {
        self.lastNetworkState = curState;
    }
    
    if (self.isNeedReloadData) {
        return last<cur;
    }else{
        return last < 4 && cur >= 4;
    }
}

#pragma mark 没有网络时加载view

-(CGRect)networkViewRect
{
    if (CGRectIsNull(_networkViewRect))
    {
        return self.view.bounds;
    }
    else
    {
        return _networkViewRect;
    }
}

-(void)setNetworkViewRect:(CGRect)networkViewRect
{
    _networkViewRect = networkViewRect;
}


-(NetworkLoadView *)networkReloadView
{
    if (![self isNeedReloadData]) {
        return nil;
    }
    if (!_networkView) {
        _networkView = [[NetworkLoadView alloc] initWithFrame:self.networkViewRect];
        _networkView.delegate = self;
        [self.view addSubview:_networkView];
    }
    [self.view bringSubviewToFront:_networkView];
    return _networkView;
}

-(void)removeNetworkView
{
    if (_networkView)
    {
        [_networkView removeFromSuperview];
        _networkView = nil;
    }
}

#pragma mark 点击重新加载
-(void)reloadRequestClick
{
    [self reloadPage];
}

- (void)reloadPage
{
     [self removeNetworkView];
}

- (BOOL)isNeedReloadData
{
    return YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


#pragma mark - Private Methods
#pragma mark -
#pragma mark Whether need Navigation Bar Hidden
- (BOOL)needHiddenBarInViewControllerName:(NSString *)vcName {
    
    BOOL needHideNaivgaionBar = NO;
    
    //在这里判断, 哪个ViewController 需要隐藏导航栏, 如果有第三方的 ViewController 也需要隐藏 NavigationBar, 我们也需要在这里设置.
    
    if ([self.vcSet containsObject:vcName])
    {
        needHideNaivgaionBar = YES;
    }
    return needHideNaivgaionBar;
}


#pragma mark - orientation
-(UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    if (self.isPresenting)
    {
        return self.presentedViewController.supportedInterfaceOrientations;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.isPresenting)
    {
        return self.presentedViewController.preferredInterfaceOrientationForPresentation;
    }
    
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    if (self.isBeingDismissed)
    {
        return NO;
    }
    return YES;
}



- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if(!self.parentViewController || [self.parentViewController isKindOfClass:[UINavigationController class]]||[self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        
    }else
    {
        [self.parentViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
}

-(BOOL)isPresenting
{
     return self.presentedViewController && !self.presentedViewController.isBeingDismissed  && ![self.presentedViewController isKindOfClass:[UIAlertController class]];
}

-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    if (_statusBarStyle != statusBarStyle)
    {
        _statusBarStyle = statusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

-(void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setNeedsStatusBarAppearanceUpdate
{
    if ([self.parentViewController isKindOfClass:[UITabBarController class]] || [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        [self.parentViewController setNeedsStatusBarAppearanceUpdate];
        
    }else
    {
        [super setNeedsStatusBarAppearanceUpdate];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return _statusBarHidden;
}

-(NSSet *)vcSet
{
    if (!_vcSet)
    {
        _vcSet = [NSSet setWithObjects:@"DDCLoginRegisterViewController", nil];
    }
    return _vcSet;
}

@end
