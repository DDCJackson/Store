//
//  UIViewController+DDCBackstageButton.m
//  DayDayCook
//
//  Created by sunlimin on 2017/5/25.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "UIViewController+DDCBackstageButton.h"
#import "DDCBackstageButton.h"
#import "TestViewController.h"
//#import "AppDelegate.h"

@implementation UIViewController (DDCBackstageButton)

- (void)addBackstageButton
{
#if defined(DEBUG) || defined(TEST)
    DDCBackstageButton *button = [[DDCBackstageButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 70.0, CGRectGetHeight(self.view.bounds) - 150.0, 55.0, 55.0)];
    [button addTarget:self action:@selector(backstageManagement:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:button];

#endif
}

- (void)backstageManagement:(UIButton *)button
{
    TestViewController * tvc = [[TestViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
