//
//  DDCNavigationBar.h
//  DayDayCook
//
//  Created by Christopher Wood on 8/22/17.
//  Copyright © 2017 DayDayCook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 * 这个类型可以用来替代系统自带的导航栏
 * 它有alternateViews，很方便切换样式
 * 也可以不用它提供的alternateViews，自己手动把views切换
 *
 */

typedef void(^SwitchBlock)(BOOL showingAlternateViews);

@interface DDCNavigationBar : UIView

// 当前在展示的views
@property (nonatomic, strong) UIView    * titleView;
@property (nonatomic, strong) UIButton  * leftButton;
@property (nonatomic, strong) UIButton  * rightButton;
@property (nonatomic, assign) BOOL        bottomLineHidden; // 默认为YES

// 可选提供的alternate views
@property (nonatomic, strong) UIView    * alternateTitleView;
@property (nonatomic, strong) UIButton  * alternateLeftButton;
@property (nonatomic, strong) UIButton  * alternateRightButton;

// 切换views的时候会运行
@property (nonatomic, copy) SwitchBlock   switchViewsBlock;

+ (instancetype)defaultNavBarWithAlternateTitleView:(UIView *)alternateTitleView
                                       buttonTarget:(id)target
                                 leftButtonSelector:(SEL)leftSelector
                                rightButtonSelector:(SEL)rightSelector;


/**
 init和设置默认的views

 @param frame
 @param titleView 中间的view
 @param leftButton 左边的按钮
 @param rightButton 右边的按钮
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame
                    titleView:(UIView *)titleView
                   leftButton:(UIButton *)leftButton
                  rightButton:(UIButton *)rightButton;


/**
 显示alternateViews和运行switchViewsBlock
 */
- (void)showAlternateViewsWithAnimation:(BOOL)animation callback:(void(^)())callback;

/**
 显示默认的views和运行switchViewsBlock
 */
- (void)showDefaultViewsWithAnimation:(BOOL)animation callback:(void(^)())callback;

@end
