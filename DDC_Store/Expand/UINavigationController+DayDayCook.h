//
//  UINavigationController+DayDayCook.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/6/15.
//  Copyright © 2016年 DayDayCook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DayDayCook)

- (void)pushViewController:(UIViewController *)viewController hidesBottomBarForSourceController:(UIViewController *)sourceController  animated:(BOOL)animated;

//- (void)pushWithSourceViewController:(UIViewController *)sourceController hidesBottomBarForTargetController:(UIViewController *)targetController  animated:(BOOL)animated;


@end
