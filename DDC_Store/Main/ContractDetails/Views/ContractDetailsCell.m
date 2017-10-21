//
//  ContractDetailsCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsCell.h"
#import "DDCContractDetailsModel.h"

#define kTitleLeftPadding     134.
#define kDescLeftPadding      164.

@interface ContractDetailsCell()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *descLabel;

@end

@implementation ContractDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self setupViewConstraints];
    }
    return self;
}

- (void)setupViewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_left).offset(kTitleLeftPadding);
        make.top.bottom.left.equalTo(self.contentView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kDescLeftPadding);
        make.top.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - configureCell
- (void)configureContactDetailsCellWithModel:(DDCContractDetailsModel *)model
{
//    self.titleLabel.text = model.title;
//    self.descLabel.text = model.desc;
//    if([model.state isEqualToString:@"未完成"]&&[model.desc isEqualToString:@"未完成"])
//    {
//        self.descLabel.textColor = COLOR_MAINORANGE;
//    }else if([model.state isEqualToString:@"生效中"]&&[model.desc isEqualToString:@"生效中"])
//    {
//        self.descLabel.textColor = [UIColor colorWithHexString:@"#3AC09F" alpha:1.0];
//    }else if([model.state isEqualToString:@"未生效"]&&[model.desc isEqualToString:@"未生效"])
//    {
//        self.descLabel.textColor = [UIColor colorWithHexString:@"#FF9C27" alpha:1.0];
//    }
//    else if([model.state isEqualToString:@"已解除"])
//    {
//        self.descLabel.textColor = COLOR_A5A4A4;
//    }
    //已结束就是正常的颜色
}

+ (CGFloat)height
{
    return 41;
}

#pragma mark - getters -
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = COLOR_A5A4A4;
        _titleLabel.font = FONT_REGULAR_16;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if(!_descLabel){
        _descLabel = [[UILabel alloc]init];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.textColor = COLOR_474747;
        _descLabel.font = FONT_REGULAR_16;
        _descLabel.numberOfLines = 1;
    }
    return _descLabel;
}

@end
