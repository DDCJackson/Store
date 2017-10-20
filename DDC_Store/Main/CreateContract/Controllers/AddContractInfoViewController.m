//
//  AddContactInfoViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "AddContractInfoViewController.h"

//views
#import "InputFieldCell.h"
#import "TitleCollectionCell.h"
#import "CheckBoxCell.h"
#import "TextfieldView.h"

//model
#import "ContractInfoViewModel.h"
#import "OffLineCourseModel.h"
#import "OffLineStoreModel.h"
#import "DDCContractModel.h"

//controller
#import "DDCQRCodeScanningController.h"

//API
#import "CreateContractInfoAPIManager.h"

typedef NS_ENUM(NSUInteger,DDCContractInfo)
{
    DDCContractInfoNumber = 0,
    DDCContractInfoContent,
    DDCContractInfoStartDate,
    DDCContractInfoEndDate,
    DDCContractInfoValidDate,
    DDCContractInfoValidStore,
    DDCContractInfoMoney
};

static const CGFloat kDefaultWidth = 500;

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CheckBoxCellDelegate,InputFieldCellDelegate,ToolBarSearchViewTextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL            _isClickedRightBtn;
    NSString      * _storeString;
}

/*生效日期*/
@property (nonatomic,strong)NSString *startDate;
/*结束日期*/
@property (nonatomic,strong)NSString *endDate;

@property (nonatomic,strong)NSMutableArray<ContractInfoViewModel *> *viewModelArr;
@property (nonatomic,strong)NSMutableArray<OffLineCourseModel *> *courseArr;
@property (nonatomic,strong)NSMutableArray<OffLineStoreModel *> *storeArr;

@property (nonatomic,strong)DDCContractInfoModel *infoModel;
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITapGestureRecognizer * tapGesture;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self requestCourseList];
//    [self requestStoreList];
    [self createData];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)requestCourseList
{
    [CreateContractInfoAPIManager getCategoryListWithSuccessHandler:^(NSArray<OffLineCourseModel *> *courseArr)
    {
        self.courseArr =[courseArr mutableCopy];
        [self createData];
        [self createUI];
        
    } failHandler:^(NSError *error) {
        
    }];
}

- (void)requestStoreList
{
    [CreateContractInfoAPIManager getOffLineStoreListWithSuccessHandler:^(NSArray<OffLineStoreModel *> *storeArr) {
        self.storeArr = [storeArr mutableCopy];
    } failHandler:^(NSError *error) {
        
    }];
}

- (void)createData
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"合同编号", @"购买内容",@"生效日期",@"结束日期",@"有效时间",@"有效门店",@"合同金额",nil];
    NSArray *placeholderArr = [NSArray arrayWithObjects:@"请扫描合同编号",@"请选择购买内容",@"请选择生效日期",@"请选择有结束日期",@"请选择有效时间",@"请选择有效门店",@"请填写合同金额", nil];
    
    self.viewModelArr = [NSMutableArray array];
    for (int i=0; i<titleArr.count; i++) {
        ContractInfoViewModel *model = [ContractInfoViewModel modelWithTitle:titleArr[i] placeholder: placeholderArr[i] text:@"" isRequired:YES tag:i];
        model.isFill = NO;
        model.type = ContractInfoModelTypeTextField;
        model.isRequired = YES;
        if(i==DDCContractInfoContent)
        {
            model.type = ContractInfoModelTypeChecked;
            model.courseArr = self.courseArr;
            for (OffLineCourseModel *courseM in model.courseArr) {
                courseM.isChecked = NO;
                courseM.count = @"";
            }
        }
        [self.viewModelArr addObject:model];
    }
    _storeString = @"线下门店0";
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DEVICE_WIDTH);
        make.top.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-[DDCBottomBar height]);
    }];
}

#pragma mark - Keyboard Frame
- (void)keyboardWillChangeFrame:(NSNotification *)keyboardNotification
{
    NSValue *rectValue = keyboardNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [rectValue CGRectValue];
    
    CGRect textFieldFrame = [self.collectionView layoutAttributesForItemAtIndexPath:self.curIndexPath].frame;
    CGRect textFieldLocation = [self.collectionView convertRect:textFieldFrame toView:self.navigationController.view];
    
    CGFloat locationDifference = (textFieldLocation.origin.y+textFieldLocation.size.height) - keyboardFrame.origin.y;
    if (locationDifference > 0)
    {
        locationDifference += 20;
        [self.collectionView setContentOffset:CGPointMake(0,locationDifference)];
    }
}

- (void)keyboardWillHide:(NSNotification *)keyboardNotification
{
    [self.collectionView setContentOffset:CGPointMake(0.,0.)];

}

#pragma mark - UIPickerViewDelegate/DataSource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     _storeString = self.storeArr[row].name;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return DEVICE_WIDTH;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.storeArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"线下门店%li",row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark  - InputFieldCellDelegate`
- (void)tapTextFieldForIndexPath:(NSIndexPath *)indexPath
{
    self.curIndexPath = indexPath;
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    self.viewModelArr[indexPath.section].text = text;
    //下一步按钮颜色的处理
    if(self.viewModelArr[indexPath.section].isFill){
        [self refreshNextPageBtnBgColor];
    }else{
        [self.nextPageBtn setClickable:NO];
    }
}

//弹出picker后，点击确定按钮
- (void)clickeDoneBtn:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==DDCContractInfoValidStore)
    {
        /******有效门店*****/
        self.viewModelArr[DDCContractInfoValidStore].text = _storeString;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoValidStore]];
    }
    
    if(indexPath.section==DDCContractInfoStartDate||indexPath.section==DDCContractInfoEndDate)
    {
        self.viewModelArr[indexPath.section].text = text;
        /******自动计算有效时间*****/
        if(self.startDate&&self.startDate.length&&self.endDate&&self.endDate.length)
        {
            NSInteger day = [Tools numberOfDaysWithFromDate:[Tools dateWithDateString:self.startDate] toDate:[Tools dateWithDateString:self.endDate]];
            if(day<=0)
            {
                self.viewModelArr[indexPath.section].text = @"";
                if(indexPath.section==DDCContractInfoStartDate){
                    [self.view makeDDCToast:@"生效日期不得大于结束日期" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
                }
                else{
                    [self.view makeDDCToast:@"结束日期不得小于生效日期" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
                }
                return;
            }
            self.viewModelArr[DDCContractInfoValidDate].text = [NSString stringWithFormat:@"%li天",day];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoValidDate]];
        }
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }
}

/********扫一扫*********/
- (void)clickFieldBehindBtn
{
    DDCQRCodeScanningController *scanVC = [[DDCQRCodeScanningController alloc]init];
    __weak typeof(self) weakSelf = self;
    scanVC.identifyResults = ^(NSString *number) {
        weakSelf.viewModelArr[DDCContractInfoNumber].text = number;
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [weakSelf refreshNextPageBtnBgColor];
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark -  Father Events
- (void)forwardNextPage
{
    _isClickedRightBtn = YES;
    [self.collectionView reloadData];
    //不可点击的时候
    if(self.nextPageBtn.clickable)
    {
        [self.view makeDDCToast:@"信息填写不完整，请填写完整" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
    }
    else
    {
        [self saveContractInfo];
        [self.delegate nextPageWithModel:self.model];
    }
}

- (void)backwardPreviousPage
{
    [self.delegate previousPage];
}


#pragma mark - CheckBoxCellDelegate
-(void)clickCheckedBtn:(BOOL)isChecked indexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.viewModelArr[DDCContractInfoContent];
    OffLineCourseModel *courseM =  viewModel.courseArr[indexPath.item-1];
    courseM.isChecked = isChecked;
    courseM.count = @"";
    viewModel.placeholder =  viewModel.isFill== YES ?@"请选择购买内容": @"请填写购买数量";
    //下一步按钮颜色的处理
    if(isChecked)
    {
        self.nextPageBtn.clickable = NO;
    }
    else
    {
        [self refreshNextPageBtnBgColor];
    }
}

- (void)checkBoxContentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.viewModelArr[DDCContractInfoContent];
    //记录在textfield中填写的内容
    OffLineCourseModel *courseModel = viewModel.courseArr[indexPath.item-1];
    courseModel.count = text;
    //设置是否填写了内容
    viewModel.placeholder =  viewModel.isFill== YES ? @"请选择购买内容": @"请填写购买数量";
    //刷新
    [self refreshNextPageBtnBgColor];
}

#pragma mark -  刷新下一页按钮的背景色
- (void)refreshNextPageBtnBgColor
{
    //遍历,只有满足所有必填项都填写了，颜色为空；否则为灰色
    for (int i =0; i<self.viewModelArr.count; i++) {
        ContractInfoViewModel *viewModel = self.viewModelArr[i];
        if(viewModel.isRequired&&!viewModel.isFill)
        {
            self.nextPageBtn.clickable = NO;
            break;
        }
        if(i==self.viewModelArr.count-1)
        {
            self.nextPageBtn.clickable = YES;
        }
    }
}

#pragma mark - Gesture
- (BOOL)resignFirstResponder
{
    self.curIndexPath = nil;
    [self.view removeGestureRecognizer:self.tapGesture];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark  - UICollectionViewDelegate&UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModelArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==DDCContractInfoContent)
    {
        return 1+self.courseArr.count;
    }
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.viewModelArr[indexPath.section];
    if(indexPath.item == 0)
    {
        TitleCollectionCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
        [titleCell configureWithTitle:viewModel.title isRequired:viewModel.isRequired tips:viewModel.placeholder isShowTips:(!viewModel.isFill&&_isClickedRightBtn)];
        return titleCell;
    }
    else if(indexPath.section==DDCContractInfoContent)
    {
        CheckBoxCell *checkCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CheckBoxCell class]) forIndexPath:indexPath];
        OffLineCourseModel *courseM = viewModel.courseArr[indexPath.item-1];
        [checkCell setCourseModel:courseM delegate:self indexPath:indexPath];
        return checkCell;
    }
    else
    {
        InputFieldCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        switch (indexPath.section) {
            case DDCContractInfoNumber:
            {
                [cell configureCellWithViewModel:viewModel btnTitle:viewModel.text.length?@"扫一扫":@"重新扫描"];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
            case DDCContractInfoStartDate:
            case DDCContractInfoEndDate:
            {
                [cell configureCellWithViewModel:viewModel];
                cell.style = InputFieldCellStyleDatePicker;
            }
                break;
            case DDCContractInfoValidStore:
            {
                [cell configureCellWithViewModel:viewModel];
                cell.style = InputFieldCellStylePicker;
            }
                break;
            case DDCContractInfoMoney:
            {
                [cell configureCellWithViewModel:viewModel extraTitle:@"元"];
                cell.style = InputFieldCellStyleNumber;
            }
                break;
            default:
            {
                [cell configureCellWithViewModel:viewModel];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
        }
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item==0)
    {
        return CGSizeMake(kDefaultWidth, [TitleCollectionCell height]);
    }
    else if(indexPath.section==1)
    {
        return CGSizeMake(kDefaultWidth, [CheckBoxCell height]);
    }
    return  CGSizeMake(kDefaultWidth, [InputFieldCell height]);
}


- (void)saveContractInfo
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoNumber].text forKey:@"contractNo"];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoStartDate].text forKey:@"startTime"];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoEndDate].text forKey:@"endTime"];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoValidDate].text forKey:@"effectiveTime"];
        [mutableDict setValue:@"7" forKey:@"courseAddressId"];
//    [mutableDict setValue:self.viewModelArr[DDCContractInfoSectionValidStore].text forKey:@"courseAddressId"];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoMoney].text forKey:@"contractPrice"];
    
    NSMutableArray *buyCount = [NSMutableArray array];
    NSMutableArray *courseCategoryId = [NSMutableArray array];
    for (OffLineCourseModel *courseModel in self.courseArr) {
        if(courseModel.isChecked&&courseModel.count&&courseModel.count.length)
        {
            [buyCount addObject:courseModel.count];
            [courseCategoryId addObject:@"1"];
//            [courseCategoryId addObject:courseModel.ID];
        }
    }
    [mutableDict setValue:courseCategoryId forKey:@"courseCategoryId"];
    [mutableDict setValue:buyCount forKey:@"buyCount"];

    [Tools showHUDAddedTo:self.view animated:YES];
    [CreateContractInfoAPIManager saveContractInfo:mutableDict successHandler:^{
        [Tools showHUDAddedTo:self.view animated:NO];
        [self.delegate nextPageWithModel:self.model];
    } failHandler:^(NSError *error) {
        
    }];
}

#pragma mark - getters & setter

- (NSString *)startDate
{
    return self.viewModelArr[DDCContractInfoStartDate].text;
}

- (NSString *)endDate
{
    return self.viewModelArr[DDCContractInfoEndDate].text;
}

- (NSMutableArray<OffLineCourseModel *> *)courseArr
{
  if(!_courseArr)
  {
      _courseArr = [NSMutableArray array];
  }
  return _courseArr;
}

- (NSMutableArray<OffLineStoreModel *> *)storeArr
{
    if(!_storeArr)
    {
        _storeArr = [NSMutableArray array];
    }
    return _storeArr;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
        [_tapGesture requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    }
    return _tapGesture;
}

- (UICollectionView *)collectionView
{
   if(!_collectionView)
   {
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
       layout.minimumLineSpacing = 0;
       layout.minimumInteritemSpacing = 0;
       layout.sectionInset = UIEdgeInsetsMake(0, 0, 35, 0);
       _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
       _collectionView.backgroundColor = [UIColor whiteColor];
       //register
       [_collectionView registerClass:[TitleCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class])];
       [_collectionView registerClass:[InputFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class])];
       [_collectionView registerClass:[CheckBoxCell class] forCellWithReuseIdentifier:NSStringFromClass([CheckBoxCell class])];
   }
   return _collectionView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
