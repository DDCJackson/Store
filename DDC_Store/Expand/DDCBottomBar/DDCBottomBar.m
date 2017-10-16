//
//  CreateContractBottomView.m
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCBottomBar.h"
#import "DDCButton.h"

@interface RoundBtn:DDCButton

@end

@implementation RoundBtn

- (instancetype)init
{
    if(self = [super init])
    {
        self.layer.masksToBounds = YES;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    return self;
}

@end


@interface  DDCBottomBar()

@property (nonatomic,copy)void(^clickAction)(void);

@property (nonatomic,copy)void(^clickAction1)(void);

@property (nonatomic,copy)void(^clickActionWithIndex)(NSInteger);

@end

static const float kBtnTag = 300;

@implementation DDCBottomBar

//一个btn
+ (DDCBottomBar *)showOneBtnWithBtnTitle:(NSString *)btnTitle clickAction:(void(^)(void))clickAction
{
    DDCBottomBar *selfView = [[DDCBottomBar alloc]init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.tag = kBtnTag;
    [btn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfView).offset(30);
        make.right.equalTo(selfView).offset(-30);
        make.top.equalTo(selfView).offset(10);
        make.bottom.equalTo(selfView).offset(-10);
    }];
    selfView.clickAction = clickAction;
    return selfView;
}

//两个btn
+ (DDCBottomBar *)showTwoBtnWithLeftBtnTitle:(NSString *)leftBtnTitle leftClickAction:(void(^)(void))leftClickAction  rightBtnTitle:(NSString *)rightBtnTitle rightClickAction:(void(^)(void))rightClickAction
{

    DDCBottomBar *selfView = [[DDCBottomBar alloc]init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:leftBtnTitle forState:UIControlStateNormal];
    btn.tag = kBtnTag;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1.0;
    [btn addTarget:self action:@selector(clickBtnActionWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfView).offset(20);
        make.right.equalTo(selfView.mas_centerX).offset(-10);
        make.top.equalTo(selfView).offset(10);
        make.bottom.equalTo(selfView).offset(-10);
    }];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:rightBtnTitle forState:UIControlStateNormal];
    btn1.tag = kBtnTag+1;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.layer.masksToBounds = YES;
    btn1.layer.borderColor = [UIColor blackColor].CGColor;
    btn1.layer.borderWidth = 1.0;
    [btn1 addTarget:self action:@selector(clickBtnActionWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfView.mas_centerX).offset(10);
        make.right.equalTo(selfView).offset(-20);
        make.top.equalTo(selfView).offset(10);
        make.bottom.equalTo(selfView).offset(-10);
    }];
    
    selfView.clickAction = leftClickAction;
    selfView.clickAction1 = rightClickAction;
    
    return selfView;
}

//多个btn
+ (void)showMultiBtnWithBtnTitleArr:(NSArray *)btnTitleArr clickAction:(void(^)(NSInteger index))clickAction
{
    DDCBottomBar *selfView = [[DDCBottomBar alloc]init];
    
    for (int i=0; i<btnTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        btn.tag = kBtnTag +i;
        [btn addTarget:self action:@selector(clickBtnActionWithTag:) forControlEvents:UIControlEventTouchUpInside];
        [selfView addSubview:btn];
    }
    selfView.clickActionWithIndex = clickAction;
}

- (void)clickBtnAction
{
    if(self.clickAction)
    {
        self.clickAction();
    }
}

- (void)clickBtnActionWithTag:(UIButton *)btn
{
    if(self.clickActionWithIndex)
    {
        self.clickActionWithIndex(btn.tag);
    }
}

@end
