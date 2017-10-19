//
//  DDCContractLabel.m
//  DDC_Store
//
//  Created by DAN on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCContractLabel.h"

@implementation DDCContractLabel

- (void)configureWithTitle:(NSString *)title isRequired:(BOOL)isRequired tips:(NSString *)tips isShowTips:(BOOL)isShowTips
{
    if(isRequired)
    {
        NSString *dotStr = @" • ";
        if(isShowTips)
        {
            NSString *tipsStr = tips.length ? [NSString stringWithFormat:@"(%@)",tips] : [NSString stringWithFormat:@"(请填写%@)",title];
            NSString *totalStr = [NSString stringWithFormat:@"%@%@%@",title,dotStr,tipsStr];
            NSMutableAttributedString *totalAttriStr = [[NSMutableAttributedString alloc]initWithString:totalStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_REGULAR_16}];
            NSRange dotRange = [totalStr rangeOfString:dotStr];
            [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_REGULAR_14} range:dotRange];
            NSRange tipsRange =[totalStr rangeOfString:tipsStr];
            [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_LIGHT_14} range:tipsRange];
            self.attributedText = totalAttriStr;
        }
        else
        {
            NSString *totalStr = [NSString stringWithFormat:@"%@%@",title,dotStr];
            NSMutableAttributedString *totalAttriStr = [[NSMutableAttributedString alloc]initWithString:totalStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_REGULAR_16}];
            NSRange dotRange = [totalStr rangeOfString:dotStr];
            [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_REGULAR_14} range:dotRange];
            self.attributedText = totalAttriStr;
        }
    }
    else
    {
        self.text = title;
    }
}


@end
