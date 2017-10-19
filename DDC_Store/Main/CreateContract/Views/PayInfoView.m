//
//  PayInfoView.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "PayInfoView.h"

@interface PayInfoView ()

@property (nonatomic, strong) UIImageView *codeIcon;
@property (nonatomic, strong) UILabel *priceLbl;

@end

@implementation PayInfoView

@synthesize codeIcon, priceLbl;

- (instancetype)init
{
    if (self = [super init]) {
        codeIcon = [[UIImageView alloc] init];
        codeIcon.backgroundColor = [UIColor grayColor];
        codeIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:codeIcon];
        [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(258.0f);
        }];
        
        priceLbl = [[UILabel alloc] init];
        priceLbl.textColor = [UIColor blackColor];
        priceLbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [self addSubview:priceLbl];
        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(codeIcon.mas_bottom).with.offset(30);
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

- (void)configuareWithData:(id)data
{
    
}


+ (CGFloat)height
{
    return 330.0f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
