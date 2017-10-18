//
//  CreateContractBottomView.h
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCButton.h"

typedef NS_ENUM(NSInteger, DDCBottomButtonStyle) {
    DDCBottomButtonStylePrimary = 0,
    DDCBottomButtonStyleSecondary
};

typedef NS_ENUM(NSInteger, DDCBottomBarStyle) {
    DDCBottomBarStyleDefault = 0,
    DDCBottomBarStyleWithLine
};


@interface DDCBottomButton:DDCButton

/*
 *  DDCBottomButton的初始化   -----默认的
 *  @param title 按钮上的标题
 *  @param style 风格
 *  @param handler  点击btn的响应事件
 */
- (instancetype)initWithTitle:(NSString *)title style:(DDCBottomButtonStyle)style handler:(void (^)(void))handler;

/*
 *  设置圆角半径
 *  @param cornerRadius 圆角半径
 */
- (void)setCornerRadius:(CGFloat)cornerRadius;

/*是否可点击，默认不可点击色为灰色*/
@property (nonatomic,assign)BOOL  clickable;

@end

@interface DDCBottomBar : UIView

@property (nonatomic,readonly)NSArray<DDCBottomButton *> *btnArr;

+ (DDCBottomBar *)showDDCBottomBarWithPreferredStyle:(DDCBottomBarStyle)preferredStyle;

- (void)addBtn:(DDCBottomButton *)btn;

+ (CGFloat)height;

@end
