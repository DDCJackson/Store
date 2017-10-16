//
//  MyNavgationController.m
//  DayDayCook
//
//  Created by DAN on 16/6/1.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "MyNavgationController.h"

@interface MyNavgationController ()

@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation MyNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.isPresenting)
    {
        return self.presentedViewController.preferredInterfaceOrientationForPresentation;
    }
    else if (self.topViewController)
    {
        return self.topViewController.preferredInterfaceOrientationForPresentation;
    }
    else if (IS_IPHONE_DEVICE)
    {
        return UIInterfaceOrientationPortrait;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationLandscapeRight;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.isPresenting)
    {
        return self.presentedViewController.supportedInterfaceOrientations;
    }
    else if (self.topViewController)
    {
        return self.topViewController.supportedInterfaceOrientations;
    }
    else if (IS_IPHONE_DEVICE)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
}

-(BOOL)shouldAutorotate
{
    if (self.topViewController)
    {
        return self.topViewController.shouldAutorotate;
    }
    else if (self.isBeingDismissed)
    {
        return NO;
    }
    else 
    {
        return YES;
    }
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return [self.topViewController preferredStatusBarStyle];
//}

-(UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

//-(BOOL)prefersStatusBarHidden
//{
//    return [self.topViewController prefersStatusBarHidden];
//}

#pragma mark - 重写了系统的方法
//如果导航栏的是否隐藏的状态没有变化，就不变；否则，需要用动画效果改变隐藏状态
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    if(self.navigationBarHidden!=navigationBarHidden)
    {
        [super setNavigationBarHidden:navigationBarHidden animated:YES];
    }
}

-(void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if(self.navigationBarHidden!=hidden)
    {
        [super setNavigationBarHidden:hidden animated:YES];
    }
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (!self.isPresenting && self.topViewController)
    {
        [self.topViewController dismissViewControllerAnimated:flag completion:completion];
    }
    else
    {
//        _isPresenting = NO;
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

-(BOOL)isPresenting
{
    return self.presentedViewController && !self.presentedViewController.isBeingDismissed  && ![self.presentedViewController isKindOfClass:[UIAlertController class]];
}


#pragma mark - public

- (void)navBarHidden:(BOOL)hidden {
    if (!hidden)
    {
        CGRect navBarFrame = self.navigationBar.frame;
        navBarFrame.origin.y = - NAVBAR_HI - STATUSBAR_HI;
        self.navigationBar.frame = navBarFrame;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect navBarFrame = self.navigationBar.frame;
                             navBarFrame.origin.y = STATUSBAR_HI;
                             self.navigationBar.frame = navBarFrame;
                         } completion:^(BOOL finished) {
                             self.navigationBar.hidden = NO;
                         }];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect navBarFrame = self.navigationBar.frame;
                             navBarFrame.origin.y = - (NAVBAR_HI + STATUSBAR_HI) * 3;
                             self.navigationBar.frame = navBarFrame;
                         } completion:^(BOOL finished) {
                             self.navigationBar.hidden = YES;
                         }];
    }
}

@end
