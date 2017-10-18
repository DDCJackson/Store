//
//  PayWaysHeaderView.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "PayWaysHeaderView.h"

@implementation PayWaysHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.text = @"请选择支付方式";
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:20.0f weight:UIFontWeightMedium];
        [self.contentView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(5);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

+ (CGFloat)height
{
    return 90;
}

@end
