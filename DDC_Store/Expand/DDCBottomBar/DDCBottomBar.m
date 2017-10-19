//
//  CreateContractBottomView.m
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCBottomBar.h"


static const CGFloat kBottomBarHeight = 60;

static const CGFloat kLineSpace = 10;
static const CGFloat kLeftPadding = 20;
static const CGFloat kRightPadding = 20;
static const CGFloat kTopPadding = 10;
static const CGFloat kBottomPadding = 10;

static const CGFloat kDefaultBtnWidth = 400;
static const CGFloat kDefaultBtnHeight = kBottomBarHeight - kTopPadding - kBottomPadding;

@interface DDCBottomButton()

@property (nonatomic,assign)DDCBottomButtonStyle style;
@property (nonatomic,copy)void(^handler)(void);

@end

@implementation DDCBottomButton

- (instancetype)initWithTitle:(NSString *)title style:(DDCBottomButtonStyle)style handler:(void (^)(void))handler
{
    if(self = [super init])
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.style = style;
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        self.handler = handler;
    }
     return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}


- (void)setClickable:(BOOL)clickable
{
    _clickable = clickable;
    if(clickable)
    {
        if(self.style==DDCBottomButtonStylePrimary)
        {
            [self setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        }
        else
        {
            [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self setBackgroundColor:COLOR_A5A4A4 forState:UIControlStateNormal];
    }
}

#pragma mark - events-
- (void)clickAction
{
   if(self.handler)
   {
       self.handler();
   }
}

#pragma mark - setters -
- (void)setStyle:(DDCBottomButtonStyle)style
{
    switch (style) {
        case DDCBottomButtonStylePrimary:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateNormal];
            self.layer.masksToBounds = YES;
            self.layer.shadowRadius = 5.0f;
            self.layer.shadowOffset = CGSizeMake(10, 10);
            self.layer.shadowColor = COLOR_MAINORANGE.CGColor;
        }
            break;
        case DDCBottomButtonStyleSecondary:
        {
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = COLOR_C4C4C4.CGColor;
        }
            break;
        default:
            break;
    }
}


@end

@interface  DDCBottomBar()

@property (nonatomic,strong)UIView *line;
@property (nonatomic,assign)DDCBottomBarStyle preferredStyle;
@property (nonatomic,strong)DDCBottomButton *lastBtn;
@property (nonatomic,strong)NSMutableArray *mutableArr;
@end

@implementation DDCBottomBar

+ (DDCBottomBar *)showDDCBottomBarWithPreferredStyle:(DDCBottomBarStyle)preferredStyle
{
    DDCBottomBar *selfView = [[DDCBottomBar alloc]init];
    selfView.backgroundColor = [UIColor whiteColor];
    selfView.preferredStyle = preferredStyle;
    selfView.mutableArr = [NSMutableArray array];
    return selfView;
}

- (void)addBtn:(DDCBottomButton *)btn
{
    [self addSubview:btn];
    [self.mutableArr addObject:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self edgeSpace].top);
        make.height.mas_equalTo(kDefaultBtnHeight);
    }];
    [btn setCornerRadius:kDefaultBtnHeight/2.0];
    [self updateViewConstraints];
}

+ (CGFloat)height
{
    return kBottomBarHeight;
}

#pragma mark - private
- (void)updateViewConstraints
{
    //只有一个的时候居中
    if(self.btnArr.count==1)
    {
        DDCBottomButton *btn = (DDCBottomButton *)self.btnArr[0];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kDefaultBtnWidth);
            make.centerX.equalTo(self);
        }];
    }
    else
    {
        CGFloat btnW =(DEVICE_WIDTH-[self edgeSpace].left-[self edgeSpace].right- self.btnArr.count*[self lineSpace])/self.btnArr.count;
        for (int i =0; i<self.btnArr.count; i++) {
            DDCBottomButton *btn = (DDCBottomButton *)self.btnArr[i];
            if(i==0)
            {
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset([self edgeSpace].top);
                    make.height.mas_equalTo(kDefaultBtnHeight);
                    make.left.equalTo(self).offset([self edgeSpace].left);
                    make.width.mas_equalTo(btnW);
                }];
            }
            else
            {
                [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.lastBtn.mas_right).offset([self lineSpace]);
                    make.width.mas_equalTo(btnW);
                }];
            }
            self.lastBtn = btn;
        }
    }
}

- (CGFloat)lineSpace
{
    return kLineSpace;
}

- (UIEdgeInsets)edgeSpace
{
    return UIEdgeInsetsMake(kTopPadding, kLeftPadding, kBottomPadding, kRightPadding);
}


#pragma mark - setters & getters -
- (void)setPreferredStyle:(DDCBottomBarStyle)preferredStyle
{
    switch (preferredStyle) {
        case DDCBottomBarStyleDefault:
            break;
        case DDCBottomBarStyleWithLine:
        {
            [self addSubview:self.line];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(1.0);
            }];
        }
            break;
        default:
            break;
    }
}

- (UIView *)line
{
    if(!_line){
        _line = [[UIView alloc]init];
        _line.backgroundColor = COLOR_E1E1E1;
    }
    return _line;
}

- (NSArray *)btnArr
{
    return [self.mutableArr copy];
}
@end
