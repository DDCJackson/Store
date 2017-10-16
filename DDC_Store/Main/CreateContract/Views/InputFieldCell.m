//
//  InputFieldCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "InputFieldCell.h"
#import "CircularTextFieldView.h"
#import "CircularButton.h"

@interface InputFieldCell()

@property (nonatomic,strong)CircularTextFieldView *textFieldView;
@property (nonatomic,strong)CircularButton *btn;

@end

@implementation InputFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.textFieldView];
        [self setupViewConstraites];
    }
    return self;
}

- (void)setupViewConstraites
{
    CGFloat height = 40;
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.height.mas_equalTo(height);
    }];
    self.textFieldView.cornerRadius = height/2.0;
    self.btn.layer.cornerRadius = height/2.0;
}


#pragma mark  - ConfigureCell
- (void)configureWithPlaceholder:(NSString *)placeholder
{
    self.textFieldView.textField.placeholder = placeholder;
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
    }];
}


- (void)configureWithPlaceholder:(NSString *)placeholder btnTitle:(NSString *)btnTitle
{
    if(![self.contentView.subviews containsObject:self.btn])
    {
        [self.contentView addSubview:self.btn];
        CGFloat btnW = 100;
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.width.mas_equalTo(btnW);
            make.top.height.equalTo(self.textFieldView);
        }];
    }
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btn.mas_left).offset(-20);
    }];
    self.textFieldView.textField.placeholder = placeholder;
    [self.btn setTitle:btnTitle forState:UIControlStateNormal];
    
}

- (void)resetHeight:(CGFloat)height
{
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.textFieldView.cornerRadius = height/2.0;
    self.btn.layer.cornerRadius = height/2.0;
}

#pragma mark  - Events
- (void)clickBtnAction
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickFieldBehindBtn)]){
        [self.delegate clickFieldBehindBtn];
    }
}

#pragma mark - Getters

- (CircularTextFieldView *)textFieldView
{
    if(!_textFieldView)
    {
        _textFieldView = [[CircularTextFieldView alloc]initWithType:CircularTextFieldViewTypeNormal];
    }
    return _textFieldView;
}

- (CircularButton *)btn
{
    if(!_btn){
        _btn= [CircularButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = FONT_MEDIUM_14;
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setBackgroundColor:COLOR_MAINORANGE];
        [_btn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn ;
}

@end
