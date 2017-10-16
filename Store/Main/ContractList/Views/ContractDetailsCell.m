//
//  ContractDetailsCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsCell.h"
#import "ContractDetailsModel.h"

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
        make.right.equalTo(self.contentView.mas_left).offset(100);
        make.top.bottom.left.equalTo(self.contentView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(150);
        make.top.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - configureCell
- (void)configureContactDetailsCellWithModel:(ContractDetailsModel *)model
{
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    if([model.state isEqualToString:@"待支付"]&&[model.desc isEqualToString:@"待支付"])
    {
        self.descLabel.textColor = [UIColor redColor];
    }else if([model.state isEqualToString:@"已支付"]&&[model.desc isEqualToString:@"已支付"])
    {
        self.descLabel.textColor = [UIColor greenColor];
    }else if([model.state isEqualToString:@"已过期"])
    {
        self.descLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - getters -
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if(!_descLabel){
        _descLabel = [[UILabel alloc]init];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.numberOfLines = 1;
    }
    return _descLabel;
}

@end
