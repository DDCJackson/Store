//
//  InputFieldCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "InputFieldCell.h"
#import "CircularTextFieldView.h"

@interface InputFieldCell()

//@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)CircularTextFieldView *textFieldView;

@end

@implementation InputFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
//        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textFieldView];
        [self setupViewConstraites];
    }
    return self;
}

- (void)setupViewConstraites
{
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.contentView);
//    }];
    
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    self.textFieldView.cornerRadius = 20;
}


- (void)configureWithTitle:(NSString *)title  placeholder:(NSString *)placeholder
{
//    self.titleLabel.text = title;
    self.textFieldView.textField.placeholder = placeholder;
//    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView);
//    }];
}

#pragma mark - getters

//- (UILabel *)titleLabel
//{
//    if(!_titleLabel){
//        _titleLabel = [[UILabel alloc]init];
//        _titleLabel.font = FONT_REGULAR_14;
//        _titleLabel.textAlignment = NSTextAlignmentLeft;
//        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.numberOfLines = 1;
//    }
//    return _titleLabel;
//}

- (CircularTextFieldView *)textFieldView
{
    if(!_textFieldView)
    {
        _textFieldView = [[CircularTextFieldView alloc]initWithType:CircularTextFieldViewTypeNormal];
    }
    return _textFieldView;
}


@end
