//
//  TitleCollectionCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "TitleCollectionCell.h"

@interface TitleCollectionCell()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation TitleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
        }];
    }
    return self;
}

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
            self.titleLabel.attributedText = totalAttriStr;
        }
        else
        {
            NSString *totalStr = [NSString stringWithFormat:@"%@%@",title,dotStr];
            NSMutableAttributedString *totalAttriStr = [[NSMutableAttributedString alloc]initWithString:totalStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_REGULAR_16}];
            NSRange dotRange = [totalStr rangeOfString:dotStr];
            [totalAttriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:FONT_REGULAR_14} range:dotRange];
            self.titleLabel.attributedText = totalAttriStr;
        }
    }
    else
    {
        self.titleLabel.text = title;
    }
}

+ (CGFloat)height
{
    return 30;
}

#pragma mark - getters -
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT_REGULAR_16;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_474747;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
