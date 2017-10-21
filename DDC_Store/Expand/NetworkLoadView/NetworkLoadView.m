//
//  NetworkLoadView.m
//  DayDayCook
//
//  Created by GFeng on 16/3/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "NetworkLoadView.h"
#import "DDCButtonView.h"
#import "MyNavgationController.h"

@interface NetworkLoadView()

//@property (strong, nonatomic) UIImageView *bgImg;
//@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *reloadBtn;
@property (nonatomic, retain) UIButton *suggestBtn;
@property (strong, nonatomic) UIButton *solutionBtn;
@property (nonatomic, retain) DDCButtonView *topView;
@property (nonatomic, assign) BOOL isNetworking;

@end

@implementation NetworkLoadView
@synthesize reloadBtn,suggestBtn,solutionBtn;


- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];//COLOR(253, 250, 249, 1);
        
//        [self bgImg];
//        [self contentLabel];
//        [self reloadBtn];
        [self makeViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];//COLOR(253, 250, 249, 1);
        
//        [self bgImg];
//        [self contentLabel];
//        [self reloadBtn];
        [self makeViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
//    _contentLabel.text = title;
    self.topView.title = title;
    _title = title;
}

- (void)makeViews
{
    UIFont *font = [UIFont systemFontOfSize:15];
    NSString *title = self.isNetworking? NSLocalizedString(@"哎呀，小煮君迷路了，请稍后再试~", @"NetworkLoadView"):NSLocalizedString(@"没网络了，叔睡一会儿!", @"NetworkLoadView");//NSLocalizedString(@"数据无法正常加载……", @"NetworkLoadView");
    CGFloat w = 300;
    CGFloat h = [Tools sizeOfText:title andMaxLabelSize:CGSizeMake(w, CGFLOAT_MAX) andFont:font].height+20;
    self.topView = [DDCButtonView initWithType:DDCContentModelTypeImageTop titleBlock:^(UILabel *titleLabel) {
        titleLabel.textColor = UIColor.lightGrayColor;//[UIColor colorWithRed:146 green:146 blue:146 alpha:1];
        titleLabel.font = font;
        titleLabel.text = title;
    } image:[UIImage imageNamed:@"3无wifi"] interval:20 clickAction:nil];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
//        make.bottom.equalTo(self.mas_centerY).with.offset(-15-h);
        make.bottom.equalTo(self.mas_centerY).with.offset(-h+35);
        make.centerX.equalTo(self);
    }];
    

    if (!self.isNetworking)
    {
        [self addSubview:self.solutionBtn];
        [self.solutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_topView).with.offset(30+h);
            make.height.mas_equalTo(30.0f);
            make.width.mas_equalTo(110);
        }];
        return;
    }
    
    CGFloat h_btn = 30.0f;
    NSArray *titles = @[NSLocalizedString(@"重新加载", @"错误提示"), NSLocalizedString(@"我要吐槽", @"错误提示")];
//    NSArray *colors = @[@"#FACE04",@"#616161"];
    NSArray *colors =@[@"FF5D31",@"#616161"];
    NSArray *btns = @[reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom], suggestBtn = [UIButton buttonWithType:UIButtonTypeCustom]];
    for (int i=0; i<titles.count; i++) {
        NSString *title = [NSString stringWithFormat:@"      %@     ",titles[i]];
        UIColor *color = [UIColor colorWithHexString:colors[i]];
        UIButton *btn = btns[i];//[UIButton buttonWithType:UIButtonTypeCustom];//
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
//        btn.tag = 555+i;
        [btn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
      
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = color.CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = h_btn/2.0f;
    }
    
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(h_btn);
        make.width.mas_equalTo(110);
        make.top.equalTo(_topView).with.offset(30+h);
    }];

    self.isNeedSendSuggestion = NO;
}


- (void)setIsNeedSendSuggestion:(BOOL)isNeedSendSuggestion
{
    suggestBtn.hidden = !(_isNeedSendSuggestion = isNeedSendSuggestion);
    
    if (isNeedSendSuggestion) {
        CGFloat margin = 7;
        if (!suggestBtn.constraints.count) {
            [suggestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(reloadBtn);
                make.left.equalTo(self.mas_centerX).with.offset(margin);
            }];
        }
        [reloadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(30);
            make.width.mas_equalTo(110);
            make.right.equalTo(self.mas_centerX).with.offset(-margin);
        }];
      
    }else{
//        [reloadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//        }];
    }
}

-(void)buttonClickAction:(UIButton *)btn
{
    if (!self.delegate) return;
    
    if (btn == reloadBtn) {
        if ([self.delegate respondsToSelector:@selector(reloadRequestClick)]) {
            [self.delegate reloadRequestClick];
        }
    }
}

#pragma mark - getters-  

- (UIButton *)solutionBtn
{
    if(!solutionBtn)
    {
        solutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [solutionBtn setTitle:NSLocalizedString(@"查看解决方案", @"NetWorkLoadView") forState:UIControlStateNormal];
        [solutionBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        solutionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        solutionBtn.layer.masksToBounds = YES;
        solutionBtn.layer.cornerRadius = 2.0;
        solutionBtn.layer.borderWidth = 1.0;
        solutionBtn.layer.borderColor = COLOR_MAINORANGE.CGColor;
        [solutionBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return solutionBtn;
}

- (BOOL)isNetworking
{
    return [Reachability reachabilityForInternetConnection].isReachable;
}


@end
