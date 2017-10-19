//
//  InputFieldCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "InputFieldCell.h"

@implementation InputFieldCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.textFieldView];
        [self.contentView addSubview:self.btn];
        [self setupViewConstraites];
    }
    return self;
}

- (void)setupViewConstraites
{
    CGFloat height = 45;
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.height.mas_equalTo(height);
    }];
    self.textFieldView.cornerRadius = height/2.0;
    self.btn.layer.cornerRadius = height/2.0;
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.width.mas_equalTo(CGFLOAT_MIN);
        make.top.height.equalTo(self.textFieldView);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textFieldView.type = CircularTextFieldViewTypeNormal;
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
    }];
    [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CGFLOAT_MIN);
    }];
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
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-120);
    }];
    self.textFieldView.textField.placeholder = placeholder;
    [self.btn setTitle:btnTitle forState:UIControlStateNormal];
    [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
    }];
}

- (void)configureWithPlaceholder:(NSString *)placeholder extraTitle:(NSString *)extraTitle
{
    self.textFieldView.type = CircularTextFieldViewTypeLabelButton;
    self.textFieldView.textField.placeholder = placeholder;
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
    }];
    [self.textFieldView setBtnTitle:extraTitle btnFont:FONT_REGULAR_16];
}

- (void)resetHeight:(CGFloat)height
{
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.textFieldView.cornerRadius = height/2.0;
    self.btn.layer.cornerRadius = height/2.0;
}

- (BOOL)isBlankOfTextField
{
    return self.textFieldView.textField.text.length?NO:YES;
}

- (void)setTextFieldTag:(NSInteger)tag text:(NSString *)text
{
    self.textFieldView.textField.tag = tag;
    self.textFieldView.textField.text = text;
}

+ (CGFloat)height
{
    return 45;
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
        [_textFieldView setPlaceholderWithColor:COLOR_A5A4A4 font:FONT_REGULAR_16];
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
