//
//  ContractDetailsHeaderView.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsHeaderView.h"

@interface ContractDetailsHeaderView ()

@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation ContractDetailsHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.titleLabel];
        [self setupViewConstraints];
    }
    return self;
}

- (void)setupViewConstraints
{
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(35);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgView.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView);
    }];
}

#pragma mark - ConfigureHeaderView
- (void)configureHeaderViewWithState:(NSString *)state
{
    if([state isEqualToString:@"未完成"])
    {
        [self.headImgView setImage:[UIImage imageNamed:@""]];
    }
    else if([state isEqualToString:@"生效中"])
    {
        [self.headImgView setImage:[UIImage imageNamed:@""]];
    }
    else if([state isEqualToString:@"未生效"])
    {
        [self.headImgView setImage:[UIImage imageNamed:@""]];
    }
    else if([state isEqualToString:@"已结束"])
    {
        [self.headImgView setImage:[UIImage imageNamed:@""]];
    }
    else if([state isEqualToString:@"已解除"])
    {
        [self.headImgView setImage:[UIImage imageNamed:@""]];
        self.titleLabel.textColor = COLOR_A5A4A4;
    }
}

+ (CGFloat)height
{
    return 156;
}

#pragma mark - Getters-

- (UIImageView *)headImgView
{
    if(!_headImgView){
        _headImgView = [[UIImageView alloc]init];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 2.0;
        _headImgView.backgroundColor = [UIColor redColor];
        _headImgView.contentMode =UIViewContentModeScaleAspectFill;
    }
    return _headImgView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_474747;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = FONT_REGULAR_18;
        _titleLabel.text = @"课程合同书";
    }
    return _titleLabel;
}


@end
