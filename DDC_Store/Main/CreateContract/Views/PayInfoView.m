//
//  PayInfoView.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "PayInfoView.h"
#import "DDCQRCodeGenerateView.h"

static float  const kCodeSideLength = 258.0f;

@interface PayInfoView ()

@property (nonatomic, strong) DDCQRCodeGenerateView *codeIcon;
@property (nonatomic, strong) UILabel *priceLbl;

@end

@implementation PayInfoView

@synthesize codeIcon, priceLbl;

- (instancetype)init
{
    if (self = [super init]) {
        
        codeIcon = [[DDCQRCodeGenerateView alloc] init];
        codeIcon.backgroundColor = [UIColor redColor];
        [self addSubview:codeIcon];
        [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(kCodeSideLength);
        }];
        
        priceLbl = [[UILabel alloc] init];
        priceLbl.textColor = [UIColor blackColor];
        priceLbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [self addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(codeIcon.mas_bottom).with.offset(20);
            make.centerX.equalTo(codeIcon);
        }];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    codeIcon.hidden = hidden;
    priceLbl.hidden = hidden;
}

- (void)configuareWithPayUrl:(NSString *)payUrl money:(NSString *)money;
{
    [codeIcon setupGenerateQRCodeWithContent:payUrl width:kCodeSideLength];
    NSString *markString = @"¥ ";
    NSMutableAttributedString *targetString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",markString ,money]];
    [targetString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40.0f weight:UIFontWeightMedium]} range:NSMakeRange(markString.length, targetString.length-markString.length)];
    priceLbl.attributedText = targetString;
}


+ (CGFloat)height
{
    return kCodeSideLength + 135.0f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
