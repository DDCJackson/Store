//
//  DDCTitleTextFieldCell.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/20/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCTitleTextFieldCell.h"

static CGFloat const kTextFieldViewHeight = 45.f;

@implementation DDCTitleTextFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textFieldView];
    [self setConstraints];
    return self;
}

- (void)setConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
    }];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kTextFieldViewHeight);
    }];
}

#pragma mark - Getters
- (CircularTextFieldView *)textFieldView
{
    if (!_textFieldView)
    {
        _textFieldView = [[CircularTextFieldView alloc] initWithType:CircularTextFieldViewTypeNormal];
        _textFieldView.cornerRadius = kTextFieldViewHeight/2.0;
    }
    return _textFieldView;
}

- (DDCContractLabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[DDCContractLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16. weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#474747"];
    }
    return _titleLabel;
}

@end
