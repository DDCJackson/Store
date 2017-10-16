//
//  CreateContractBottomView.m
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "CreateContractBottomView.h"
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


@interface  CreateContractBottomView()

@property (nonatomic,copy)void(^clickAction)(void);

@property (nonatomic,copy)void(^clickAction1)(void);

@property (nonatomic,copy)void(^clickActionWithIndex)(NSInteger);

@end

static const float kBtnTag = 300;

@implementation CreateContractBottomView

//一个btn
+ (UIView *)showOneBtnWithBtnTitle:(NSString *)btnTitle clickAction:(void(^)(void))clickAction
{
    CreateContractBottomView *selfView = [[CreateContractBottomView alloc]init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
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
+ (void)showTwoBtnWithLeftBtnTitle:(NSString *)leftBtnTitle leftClickAction:(void(^)(void))leftClickAction  rightBtnTitle:(NSString *)rightBtnTitle rightClickAction:(void(^)(void))rightClickAction
{

    CreateContractBottomView *selfView = [[CreateContractBottomView alloc]init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:leftBtnTitle forState:UIControlStateNormal];
    btn.tag = kBtnTag;
    [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    [btn1 addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selfView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfView.mas_centerX).offset(10);
        make.right.equalTo(selfView).offset(-20);
        make.top.equalTo(selfView).offset(10);
        make.bottom.equalTo(selfView).offset(-10);
    }];
    
    selfView.clickAction = leftClickAction;
    selfView.clickAction1 = rightClickAction;
}

//多个btn
+ (void)showMultiBtnWithBtnTitleArr:(NSArray *)btnTitleArr clickAction:(void(^)(NSInteger index))clickAction
{
    CreateContractBottomView *selfView = [[CreateContractBottomView alloc]init];
    
    for (int i=0; i<btnTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        btn.tag = kBtnTag +i;
        [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)clickBtnAction:(UIButton *)btn
{
    if(self.clickActionWithIndex)
    {
        self.clickActionWithIndex(btn.tag);
    }
}

@end
