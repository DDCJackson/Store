//
//  InputFieldCell.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "InputFieldCell.h"
#import "TextfieldView.h"
#import "ContractInfoViewModel.h"

@interface InputFieldCell()<UITextFieldDelegate,ToolBarSearchViewTextFieldDelegate>
{
    NSString *_dateString;//时间
}

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)TextfieldView *toolBar;

@end


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
    self.style = InputFieldCellStyleNormal;
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


- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel
{
    self.textFieldView.textField.placeholder = viewModel.placeholder;
    self.textFieldView.textField.text = viewModel.text;
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
    }];
}

- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel btnTitle:(NSString *)btnTitle
{
    self.textFieldView.textField.placeholder = viewModel.placeholder;
    self.textFieldView.textField.text = viewModel.text;
    [self.textFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-120);
    }];
    
    [self.btn setTitle:btnTitle forState:UIControlStateNormal];
    [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
    }];
}

- (void)configureCellWithViewModel:(ContractInfoViewModel *)viewModel extraTitle:(NSString *)extraTitle
{
    self.textFieldView.textField.placeholder = viewModel.placeholder;
    self.textFieldView.textField.text = viewModel.text;
    self.textFieldView.type = CircularTextFieldViewTypeLabelButton;
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

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    _dateString = [Tools dateStringWithDate:datePicker.date];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.style == InputFieldCellStyleNumber)
    {
       return [Tools validateNumber:string];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(contentDidChanged:forIndexPath:)])
    {
        [self.delegate contentDidChanged:textField.text forIndexPath:self.indexPath];
    }
}

#pragma mark - ToolBarSearchViewTextFieldDelegate
- (void)doneButtonClicked
{
    [self.textFieldView.textField endEditing:YES];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickeDoneBtn:forIndexPath:)])
    {
        [self.delegate clickeDoneBtn:_dateString forIndexPath:self.indexPath];
    }
}

- (void)cancelButtonClicked
{
    [self.textFieldView.textField endEditing:YES];

}

#pragma mark - Setters
- (void)setDelegate:(id<InputFieldCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>)delegate
{
    _delegate = delegate;
    self.pickerView.delegate =delegate;
    self.pickerView.dataSource = delegate;
}

- (void)setStyle:(InputFieldCellStyle)style
{
    _style = style;
    switch (style) {
        case InputFieldCellStyleNormal:
        {
            self.textFieldView.textField.inputView = [[UIView alloc]init];
            self.textFieldView.textField.inputAccessoryView = nil;
            self.textFieldView.textField.inputAssistantItem.leadingBarButtonGroups = @[];
            self.textFieldView.textField.inputAssistantItem.trailingBarButtonGroups =@[];
            self.textFieldView.textField.clearButtonMode = UITextFieldViewModeNever;
        }
            break;
        case InputFieldCellStyleNumber:
        {
            self.textFieldView.textField.inputView = nil;
            self.textFieldView.textField.inputAccessoryView = nil;
            self.textFieldView.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textFieldView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
            break;
        case InputFieldCellStylePicker:
        {
            self.textFieldView.textField.inputView = self.pickerView;
            self.textFieldView.textField.inputAccessoryView = self.toolBar;
            self.textFieldView.textField.inputAssistantItem.leadingBarButtonGroups = @[];
            self.textFieldView.textField.inputAssistantItem.trailingBarButtonGroups =@[];
            self.textFieldView.textField.clearButtonMode = UITextFieldViewModeNever;
        }
            break;
        case InputFieldCellStyleDatePicker:
        {
            self.textFieldView.textField.inputView = self.datePicker;
            self.textFieldView.textField.inputAccessoryView = self.toolBar;
            self.textFieldView.textField.inputAssistantItem.leadingBarButtonGroups = @[];
            self.textFieldView.textField.inputAssistantItem.trailingBarButtonGroups =@[];
            self.textFieldView.textField.clearButtonMode = UITextFieldViewModeNever;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getters

- (CircularTextFieldView *)textFieldView
{
    if(!_textFieldView)
    {
        _textFieldView = [[CircularTextFieldView alloc]initWithType:CircularTextFieldViewTypeNormal];
        [_textFieldView setPlaceholderWithColor:COLOR_A5A4A4 font:FONT_REGULAR_16];
        [_textFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldView.textField.delegate = self;
        
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

- (TextfieldView *)toolBar
{
    if(!_toolBar)
    {
        _toolBar = [[TextfieldView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        _toolBar.toolBarDelegate = self;
    }
    return _toolBar;
}

- (UIPickerView *)pickerView
{
    if(!_pickerView)
    {
        _pickerView = [[UIPickerView alloc]init];
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker
{
    if(!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //显示方式是只显示年月日
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        _dateString = [Tools dateStringWithDate:_datePicker.date];
    }
    return _datePicker;
}

@end
