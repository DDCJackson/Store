//
//  TitleCollectionCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/16.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "TitleCollectionCell.h"
#import "DDCContractLabel.h"

@interface TitleCollectionCell()

@property (nonatomic,strong)DDCContractLabel *titleLabel;

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
    [self.titleLabel configureWithTitle:title isRequired:isRequired tips:tips isShowTips:isRequired];
}

+ (CGFloat)height
{
    return 30;
}

#pragma mark - getters -
- (DDCContractLabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[DDCContractLabel alloc]init];
    }
    return _titleLabel;
}

@end
