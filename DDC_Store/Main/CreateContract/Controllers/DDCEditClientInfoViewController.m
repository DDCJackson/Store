//
//  DDCEditClientInfoViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCEditClientInfoViewController.h"
#import "DDCBarBackgroundView.h"
#import "DDCCustomerModel.h"
#import "DDCTitleTextFieldCell.h"
#import "ContractInfoViewModel.h"
#import "TextfieldView.h"

#import "DDCEditClientInfoAPIManager.h"

typedef NS_ENUM(NSUInteger, DDCClientTextField)
{
    DDCClientTextFieldName,
    DDCClientTextFieldSex,
    DDCClientTextFieldBirthday,
    DDCClientTextFieldAge,
    DDCClientTextFieldEmail,
    DDCClientTextFieldCareer,
    DDCClientTextFieldChannel
};

@interface DDCEditClientInfoViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, ToolBarSearchViewTextFieldDelegate>
{
    BOOL      _showHints;
    UITextField * _currentTextField;
}

@property (nonatomic, strong) DDCBarBackgroundView * view;
@property (nonatomic, strong) DDCCustomerModel * model;
@property (nonatomic, copy) NSArray<ContractInfoViewModel *> * viewModelArray;

@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIDatePicker * datePickerView;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) TextfieldView * toolbar;

@end

@implementation DDCEditClientInfoViewController

@dynamic view;
@dynamic model;

- (instancetype)initWithModel:(GJObject *)model delegate:(id<ChildContractViewControllerDelegate>)delegate
{
    if (!(self = [super init])) return nil;
    
    if ([model isKindOfClass:[DDCCustomerModel class]])
    {
        self.model = (DDCCustomerModel*)model;
    }
    return self;
}

- (void)loadView
{
    self.view = [[DDCBarBackgroundView alloc] initWithRectCornerTopCollectionViewFrame:CGRectZero hasShadow:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.view.collectionView.backgroundColor = UIColor.whiteColor;
    
    self.view.collectionView.delegate = self;
    self.view.collectionView.dataSource = self;
    [self.view.collectionView registerClass:[DDCTitleTextFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([DDCTitleTextFieldCell class])];
    [self.view.collectionView reloadData];
    [self updateClickableState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Bar Buttons
- (void)forwardNextPage
{
    for (ContractInfoViewModel * viewModel in self.viewModelArray)
    {
        if (viewModel.isRequired && !viewModel.isFill)
        {
            _showHints = YES;
            [self.view makeDDCToast:NSLocalizedString(@"信息填写不完整，请填写完整", @"") image:[UIImage imageNamed:@"addCar_icon_fail"]];
            [self.view.collectionView reloadData];
            
            return;
        }
    }
    
    [self updateModel];
    [DDCEditClientInfoAPIManager uploadClientInfo:self.model successHandler:^{
        [self.delegate nextPageWithModel:self.model];
    } failHandler:^(NSError *err) {
        NSString * errStr = err.userInfo[NSLocalizedDescriptionKey];
        [self.view makeDDCToast:errStr image:[UIImage imageNamed:@"addCar_icon_fail"]];
    }];
}

- (void)updateClickableState
{
    BOOL canClick = YES;
    for (ContractInfoViewModel * viewModel in self.viewModelArray)
    {
        if (viewModel.isRequired && !viewModel.isFill)
        {
            canClick = NO;
        }
    }
    self.nextPageBtn.clickable = canClick;
}

#pragma mark - Model
- (void)updateModel
{
    self.model.nickName = self.viewModelArray[DDCClientTextFieldName].text;
    self.model.sex = [DDCCustomerModel.genderArray indexOfObject:self.viewModelArray[DDCClientTextFieldSex].text];
    NSDate * birthday = [self.dateFormatter dateFromString:self.viewModelArray[DDCClientTextFieldBirthday].text];
    self.model.birthday = birthday;
    self.model.age = self.viewModelArray[DDCClientTextFieldAge].text;
    self.model.email = self.viewModelArray[DDCClientTextFieldEmail].text;
    self.model.career = [DDCCustomerModel.occupationArray indexOfObject:self.viewModelArray[DDCClientTextFieldCareer].text];
    self.model.channel = [DDCCustomerModel.channelArray indexOfObject:self.viewModelArray[DDCClientTextFieldChannel].text];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCTitleTextFieldCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDCTitleTextFieldCell class]) forIndexPath:indexPath];
    
    ContractInfoViewModel * model = self.viewModelArray[indexPath.item];
    
    [cell.titleLabel configureWithTitle:model.title isRequired:model.isRequired tips:model.placeholder isShowTips:(model.isRequired && !model.isFill && _showHints)];
    
    cell.textFieldView.textField.placeholder = model.placeholder;
    cell.textFieldView.textField.text = model.text;
    
    cell.textFieldView.textField.delegate = self;
    [cell.textFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.textFieldView.textField.tag = model.tag;
    
    // 不让用户手动改年龄
    cell.textFieldView.textField.userInteractionEnabled = indexPath.item != DDCClientTextFieldAge;
    cell.textFieldView.textField.clearButtonMode = indexPath.item == DDCClientTextFieldAge ? UITextFieldViewModeNever : UITextFieldViewModeAlways;
    
    [self configureInputViewForTextField:cell.textFieldView.textField indexPath:indexPath];
    
    return cell;
}

- (void)configureInputViewForTextField:(UITextField*)textField indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == DDCClientTextFieldChannel || indexPath.item == DDCClientTextFieldCareer || indexPath.item == DDCClientTextFieldSex)
    {
        textField.inputAssistantItem.leadingBarButtonGroups = @[];
        textField.inputAssistantItem.trailingBarButtonGroups =@[];
        textField.inputView = self.pickerView;
        textField.inputAccessoryView = self.toolbar;
    }
    else if (indexPath.item == DDCClientTextFieldBirthday)
    {
        textField.inputAssistantItem.leadingBarButtonGroups = @[];
        textField.inputAssistantItem.trailingBarButtonGroups =@[];
        textField.inputView = self.datePickerView;
        textField.inputAccessoryView = self.toolbar;
    }
    else if (indexPath.item == DDCClientTextFieldName)
    {
        textField.inputView = nil;
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }
    else
    {
        textField.inputView = nil;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item != DDCClientTextFieldBirthday && indexPath.item != DDCClientTextFieldAge)
    {
        return CGSizeMake(DEVICE_WIDTH-(134*2), 75);
    }
    else if (indexPath.item == DDCClientTextFieldBirthday)
    {
        return CGSizeMake(340, 75);
    }
    else
    {
        return CGSizeMake(100, 75);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 134, 0, 134);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 60;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 35;
}

#pragma mark - Textfield

- (void)textFieldDidChange:(UITextField *)textField
{
    self.viewModelArray[textField.tag].text = textField.text.length ? textField.text : nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    [self.view addGestureRecognizer:self.tapGesture];
    return YES;
}

#pragma mark - Gesture

- (BOOL)resignFirstResponder
{
    _currentTextField = nil;
    [self.view removeGestureRecognizer:self.tapGesture];
    [self updateClickableState];
    [self.view endEditing:YES];
    return [super resignFirstResponder];
}

#pragma mark - PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 每个数组里，第一个默认是个空字符串
    switch (_currentTextField.tag)
    {
    case DDCClientTextFieldSex:
        return DDCCustomerModel.genderArray.count-1;
    case DDCClientTextFieldCareer:
        return DDCCustomerModel.occupationArray.count-1;
    case DDCClientTextFieldChannel:
        return DDCCustomerModel.channelArray.count-1;
    default:
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 下面加1可以避免有空字符串出现
    switch (_currentTextField.tag)
    {
        case DDCClientTextFieldSex:
            return DDCCustomerModel.genderArray[row+1];
        case DDCClientTextFieldCareer:
            return DDCCustomerModel.occupationArray[row+1];
        case DDCClientTextFieldChannel:
            return DDCCustomerModel.channelArray[row+1];
        default:
            return @"";
    }
}

#pragma mark - Toolbar
- (void)doneButtonClicked
{
    switch (_currentTextField.tag)
    {
        case DDCClientTextFieldBirthday:
        {
            NSDate * birthday = self.datePickerView.date;
            self.viewModelArray[DDCClientTextFieldBirthday].text = [self.dateFormatter stringFromDate:birthday];
            NSCalendarUnit unitFlags = NSCalendarUnitYear;
            NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:birthday  toDate:[NSDate date]  options:0];
            
            self.viewModelArray[DDCClientTextFieldAge].text = @(breakdownInfo.year).stringValue;
        }
            break;
            
    // 因为数组里第一个object是一个空字符串，所以下面的row都需要加1
        case DDCClientTextFieldSex:
            self.viewModelArray[DDCClientTextFieldSex].text = DDCCustomerModel.genderArray[[self.pickerView selectedRowInComponent:0]+1];
            break;
        case DDCClientTextFieldCareer:
            self.viewModelArray[DDCClientTextFieldCareer].text = DDCCustomerModel.occupationArray[[self.pickerView selectedRowInComponent:0]+1];
            break;
        case DDCClientTextFieldChannel:
            self.viewModelArray[DDCClientTextFieldChannel].text = DDCCustomerModel.channelArray[[self.pickerView selectedRowInComponent:0]+1];
            break;
        default:
            break;
    }
    
    NSArray * refreshIndexes = @[[NSIndexPath indexPathForItem:_currentTextField.tag inSection:0]];
    if (_currentTextField.tag == DDCClientTextFieldBirthday)
    {
        refreshIndexes = [refreshIndexes arrayByAddingObjectsFromArray:@[[NSIndexPath indexPathForItem:DDCClientTextFieldAge inSection:0]]];
    }
    [self.view.collectionView reloadItemsAtIndexPaths: refreshIndexes];
    [self resignFirstResponder];
}

- (void)cancelButtonClicked
{
    [self resignFirstResponder];
}

#pragma mark - Keyboard Frame
- (void)keyboardWillChangeFrame:(NSNotification *)keyboardNotification
{
    NSValue *rectValue = keyboardNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [rectValue CGRectValue];
    
    CGRect textFieldFrame = [self.view.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentTextField.tag inSection:0]].frame;
    CGRect textFieldLocation = [self.view.collectionView convertRect:textFieldFrame toView:self.navigationController.view];
    
    CGFloat locationDifference = (textFieldLocation.origin.y+textFieldLocation.size.height) - keyboardFrame.origin.y;
    if (locationDifference > 0)
    {
        locationDifference += 20;
        [self.view.collectionView setContentOffset:CGPointMake(0,locationDifference)];
    }
    
//    self.view.collectionView.scrollEnabled = YES;
//    self.view.collectionView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + keyboardFrame.size.height);
}

- (void)keyboardWillHide:(NSNotification *)keyboardNotification
{
    [self.view.collectionView setContentOffset:CGPointMake(0.,0.)];
//    self.view.collectionView.contentSize = self.view.bounds.size;
//    self.view.collectionView.scrollEnabled = NO;
}

#pragma mark - Getters
- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePickerView
{
    if (!_datePickerView)
    {
        _datePickerView = [[UIDatePicker alloc] init];
        _datePickerView.datePickerMode = UIDatePickerModeDate;
    }
    return _datePickerView;
}

- (TextfieldView *)toolbar
{
    if(!_toolbar)
    {
        _toolbar = [[TextfieldView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
        _toolbar.backgroundColor = [UIColor whiteColor];
        _toolbar.toolBarDelegate = self;
    }
    return _toolbar;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
        [_tapGesture requireGestureRecognizerToFail:self.view.collectionView.panGestureRecognizer];
    }
    return _tapGesture;
}

- (NSArray<ContractInfoViewModel *> *)viewModelArray
{
    if (!_viewModelArray)
    {
        _viewModelArray = @[[ContractInfoViewModel modelWithTitle:NSLocalizedString(@"姓名", @"") placeholder:NSLocalizedString(@"请输入姓名", @"") text:self.model.nickName isRequired:YES tag:DDCClientTextFieldName],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"性别", @"") placeholder:NSLocalizedString(@"请选择性别", @"") text:DDCCustomerModel.genderArray[self.model.sex] isRequired:YES tag:DDCClientTextFieldSex],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"生日", @"") placeholder:NSLocalizedString(@"请输入生日", @"") text:self.model.formattedBirthday isRequired:YES tag:DDCClientTextFieldBirthday],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"年龄", @"") placeholder:NSLocalizedString(@"年龄", @"") text:self.model.age isRequired:NO tag:DDCClientTextFieldAge],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"邮箱", @"") placeholder:NSLocalizedString(@"请输入邮箱", @"") text:self.model.email isRequired:NO tag:DDCClientTextFieldEmail],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"职业", @"") placeholder:NSLocalizedString(@"请选择职业",@"") text:DDCCustomerModel.occupationArray[self.model.career] isRequired:NO tag:DDCClientTextFieldCareer],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"渠道", @"") placeholder:NSLocalizedString(@"请选择渠道", @"") text:DDCCustomerModel.channelArray[self.model.channel] isRequired:NO tag:DDCClientTextFieldChannel]
                           ];
    }
    return _viewModelArray;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"YYYY/MM/dd";
    }
    return _dateFormatter;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
