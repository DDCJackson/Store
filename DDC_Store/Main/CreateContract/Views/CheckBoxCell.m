//
//  CheckBoxCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/17.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "CheckBoxCell.h"
//view
#import "CircularTextFieldView.h"

//model
#import "OffLineCourseModel.h"

static const float kTopAndBottomPadding = 8.0f;
static const float kTickImgWidth = 14.0f;
static const float kTitleLeftPadding = 7.0f;
static const float kSubTitleWidth = 35.0f;
static const float kSubTitleLeftPadding = 50.0f;
static const float kTextFieldLeftPadding =10.0f;
static const float kTextFieldWidth = 90.0f;
static const float kTextFieldHeight = 28.0f;
static const float kTotalHeight =kTopAndBottomPadding+kTextFieldHeight;

@interface CheckBoxCell ()

@property (nonatomic,strong)UIButton *tickImgBtn;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subTitleLabel;
@property (nonatomic,strong)CircularTextFieldView *textFieldView;

@end

@implementation CheckBoxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.tickImgBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.textFieldView];
        [self setupViewConstraits];
    }
    return self;
}

- (void)setupViewConstraits
{
    [self.tickImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.height.mas_equalTo(kTickImgWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tickImgBtn.mas_right).with.offset(kTitleLeftPadding);
        make.centerY.equalTo(self.contentView);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(kSubTitleLeftPadding);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kSubTitleWidth);
    }];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitleLabel.mas_right).offset(kTextFieldLeftPadding);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    [self.textFieldView setCornerRadius:kTextFieldHeight/2.0];
}

- (void)setCourseModel:(OffLineCourseModel *)courseModel delegate:(id<CheckBoxCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath
{
    self.delegate = delegate;
    self.indexPath = indexPath;
    self.titleLabel.text = courseModel.title;
    self.textFieldView.textField.text = courseModel.count;
    self.isChecked = courseModel.isChecked;
    CGSize s = [Tools sizeOfText:courseModel.title andMaxLabelSize:CGSizeMake(CGFLOAT_MAX, 20) andFont:FONT_REGULAR_16];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(s.width);
    }];
}

+ (CGFloat)height
{
    return kTotalHeight;
}

#pragma mark - event -
- (void)clickTickBtnAction:(UIButton *)btn
{
    self.isChecked = !self.isChecked;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickCheckedBtn:indexPath:)])
    {
        [self.delegate clickCheckedBtn:self.isChecked indexPath:self.indexPath];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(checkBoxContentDidChanged:forIndexPath:)])
    {
        [self.delegate checkBoxContentDidChanged:textField.text forIndexPath:self.indexPath];
    }
}

#pragma mark - setter -
- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    self.subTitleLabel.hidden = !isChecked;
    self.textFieldView.hidden = !isChecked;
    self.tickImgBtn.selected =isChecked;
    if(isChecked)
    {
        self.titleLabel.textColor = COLOR_474747;
    }
    else
    {
        self.titleLabel.textColor = COLOR_A5A4A4;
        self.textFieldView.textField.text = @"";
    }
}

#pragma mark - getters-
- (UIButton *)tickImgBtn
{
    if(!_tickImgBtn){
        _tickImgBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_tickImgBtn addTarget:self action:@selector(clickTickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tickImgBtn setBackgroundImage:[UIImage imageNamed:@"icon_newcontract_goumaineirong_unselected"] forState:UIControlStateNormal];
        [_tickImgBtn setBackgroundImage:[UIImage imageNamed:@"icon_newcontract_goumaineirong_selected"] forState:UIControlStateSelected];
        [_tickImgBtn setEnlargeEdgeWithTop:10 right:200 bottom:10 left:50];
    }
    return _tickImgBtn ;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel= [[UILabel alloc]init];
        _titleLabel.font = FONT_REGULAR_16;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_474747;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if(!_subTitleLabel){
        _subTitleLabel= [[UILabel alloc]init];
        _subTitleLabel.font = FONT_REGULAR_16;
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = COLOR_474747;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.text = @"购买";
    }
    return _subTitleLabel;
}

- (CircularTextFieldView *)textFieldView
{
   if(!_textFieldView)
   {
       _textFieldView = [[CircularTextFieldView alloc]initWithType:CircularTextFieldViewTypeLabelButton];
       [_textFieldView setBtnTitle:@"次" btnFont:FONT_REGULAR_16];
       [_textFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
       _textFieldView.textField.keyboardType = UIKeyboardTypeNumberPad;
       _textFieldView.textField.clearButtonMode = UITextFieldViewModeNever;
   }
    return _textFieldView;
}

@end
