//
//  UINavigationController+DayDayCook.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/6/15.
//  Copyright © 2016年 DayDayCook. All rights reserved.
//

#import "UINavigationController+DayDayCook.h"

@implementation UINavigationController (DayDayCook)

- (void)pushViewController:(UIViewController *)viewController hidesBottomBarForSourceController:(UIViewController *)sourceController  animated:(BOOL)animated
{
    if (!viewController || !sourceController) {
        return;
    }
    
    viewController.hidesBottomBarWhenPushed = YES;
    sourceController.hidesBottomBarWhenPushed = YES;
    
    [self pushViewController:viewController animated:animated];
    
    if (sourceController.navigationController.childViewControllers.count <= 2) {
        sourceController.hidesBottomBarWhenPushed = NO;
//        if(IS_IPAD_DEVICE)
//        {
//            AppDelegate *appDele=(AppDelegate *)[UIApplication sharedApplication].delegate;
//            MenuViewController *menuVC=(MenuViewController *)appDele.window.rootViewController;
//            [menuVC hideMenuView];
//        }
    }
}

//- (void)pushWithSourceViewController:(UIViewController *)sourceController hidesBottomBarForTargetController:(UIViewController *)targetController  animated:(BOOL)animated
//{
//    if (!sourceController || !targetController) {
//        return;
//    }
//    targetController.hidesBottomBarWhenPushed = YES;
//    [self pushViewController:targetController animated:animated];
//}




@end
