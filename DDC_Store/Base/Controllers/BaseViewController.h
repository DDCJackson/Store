//
//  BaseViewController.h
//  iCarCenter
//
//  Created by Storm on 14-4-28.
//  Copyright (c) 2014年 Storm. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "UMAnalysisController.h"

@interface BaseViewController : UMAnalysisController

////是否用动画效果隐藏导航栏，这个属性是为了界面的跳转更流畅。
////这是一个隐藏导航栏的控制器！！！
////系统方法无法判断当前的导航栏是否隐藏的状态，所以写了一个属性
//
///*!
// *
// * 从隐藏导航栏的页面跳到这个页面，isAnimatedHideNavBar = NO
// * 从显示导航栏的页面跳到这个页面，isAnimatedHideNavbar = YES
// */
//@property (nonatomic,assign)BOOL isAnimatedHideNavBar;

@property(retain,nonatomic)UIButton *rightNaviBtn;
@property(retain,nonatomic)UIButton *leftNaviBtn;

-(void)showLoadingView; //开始加载  需要手动关闭;
-(void)stopLoadingView; //关闭加载;

-(void)setRightNaviBtnImage:(UIImage*)img withRightSpacing:(CGFloat)rightSpacing;
-(void)setRightNaviBtnTitle:(NSString*)str withRightSpacing:(CGFloat)rightSpacing;
-(void)rightNaviBtnAddRedDot;
-(void)rightNaviBtnRemoveRedDot;
-(void)setLeftNaviBtnImage;
-(void)setLeftNaviBtnImage:(UIImage *)img;
-(void)setLeftNaviBtnTitle:(NSString*)str;
- (void)navBtn:(UIButton *)navBtn addRedDotWithNumber:(NSNumber *)number;

-(void)back;
-(void)rightNaviBtnPressed;

@end
