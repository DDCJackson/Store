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
#import "DDCContractInfoModel.h"
#import "DDCContractDetailsModel.h"

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

@property (nonatomic,strong)NSArray<ContractInfoViewModel *> *viewModelArr;
@property (nonatomic,strong)NSArray<OffLineCourseModel *> *courseArr;
@property (nonatomic,strong)NSArray<OffLineStoreModel *> *storeArr;

@property (nonatomic,strong)DDCContractInfoModel *infoModel;
@property (nonatomic,strong)NSIndexPath *curIndexPath;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITapGestureRecognizer * tapGesture;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestCourseList];
    [self requestStoreList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)requestCourseList
{
    [Tools showHUDAddedTo:self.view animated:YES];
    [CreateContractInfoAPIManager getCategoryListWithSuccessHandler:^(NSArray<OffLineCourseModel *> *courseArr)
    {
        [Tools showHUDAddedTo:self.view animated:NO];
        if(courseArr.count)
        {
            self.courseArr =[courseArr copy];
            if(self.infoModel.course)
            {
                for (OffLineCourseModel *m in self.courseArr) {
                    for (OffLineCourseModel *subM in self.infoModel.course) {
                        if(subM.ID == m.ID)
                        {
                            m.isChecked = YES;
                            m.count = subM.count;
                        }
                    }
                }
            }
            self.viewModelArr[DDCContractInfoContent].courseArr = self.courseArr;
            [self.collectionView reloadData];
            [self refreshNextPageBtnBgColor];
        }
    } failHandler:^(NSError *error) {
        [Tools showHUDAddedTo:self.view animated:NO];
        DLog(@"课程分类接口请求失败");
    }];
}

- (void)requestStoreList
{
    [CreateContractInfoAPIManager getOffLineStoreListWithSuccessHandler:^(NSArray<OffLineStoreModel *> *storeArr) {
        if(storeArr.count)
        {
            self.storeArr = [storeArr copy];
        }
    } failHandler:^(NSError *error) {
        DLog(@"线下门店地址列表接口请求失败");
    }];
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

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.storeArr[row].name;
}

#pragma mark  - InputFieldCellDelegate
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
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:[self dateFormat]];
            
           if([[dateFormatter dateFromString:self.endDate] compare:[dateFormatter dateFromString:self.startDate]] != NSOrderedDescending)
           {
                self.viewModelArr[indexPath.section].text = @"";
                if(indexPath.section==DDCContractInfoStartDate){
                    [self.view makeDDCToast:@"生效日期不得大于结束日期" image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
                }
                else{
                    [self.view makeDDCToast:@"结束日期不得小于生效日期" image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
                }
                return;
            }
            self.viewModelArr[DDCContractInfoValidDate].text = [self getTimeDifferenceStartDate:[dateFormatter dateFromString:self.startDate] endDate:[dateFormatter dateFromString:self.endDate]];
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
    if(!self.nextPageBtn.clickable)
    {
        [self.view makeDDCToast:@"信息填写不完整，请填写完整" image:[UIImage imageNamed:@"addCar_icon_fail"] imagePosition:ImageTop];
    }
    else
    {
        [self saveContractInfo];
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
        return 1+self.viewModelArr[DDCContractInfoContent].courseArr.count;
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
                [cell configureCellWithViewModel:viewModel btnTitle:viewModel.text.length?@"重新扫描":@"扫一扫"];
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

#pragma mark - 提交合同信息数据
- (void)saveContractInfo
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoNumber].text forKey:@"contractNo"];
    [mutableDict setObject:[Tools timeIntervalWithDateStr:self.startDate andDateFormatter:[self dateFormat]] forKey:@"startTime"];
    [mutableDict setObject:[Tools timeIntervalWithDateStr:self.endDate andDateFormatter:[self dateFormat]] forKey:@"endTime"];
    [mutableDict setObject:self.viewModelArr[DDCContractInfoValidDate].text forKey:@"effectiveTime"];
    [mutableDict setValue:self.viewModelArr[DDCContractInfoValidStore].text forKey:@"courseAddressId"];
    [mutableDict setObject:self.viewModelArr[DDCContractInfoMoney].text forKey:@"contractPrice"];
    DDCUserModel *u = [DDCStore sharedStore].user;
    [mutableDict setObject:u.ID forKey:@"createUid"];//销售
    [mutableDict setObject:self.customModel.nickName forKey:@"uid"];//客户
    NSMutableArray *buyCount = [NSMutableArray array];
    NSMutableArray *courseCategoryId = [NSMutableArray array];
    for (OffLineCourseModel *courseModel in self.courseArr) {
        if(courseModel.isChecked&&courseModel.count&&courseModel.count.length)
        {
            [buyCount addObject:courseModel.count];
            [courseCategoryId addObject:courseModel.ID];
        }
    }
    [mutableDict setObject:[courseCategoryId componentsJoinedByString:@","] forKey:@"courseCategoryId"];
    [mutableDict setObject:[buyCount componentsJoinedByString:@","]forKey:@"buyCount"];
    
    [Tools showHUDAddedTo:self.view animated:YES];
    [CreateContractInfoAPIManager saveContractInfo:mutableDict successHandler:^{
        [Tools showHUDAddedTo:self.view animated:NO];
        [self.delegate nextPageWithModel:self.model];
    } failHandler:^(NSError *error) {
        
    }];
}

//计算两个时间的时间差
- (NSString *)getTimeDifferenceStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendarUnit unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:startDate  toDate:endDate options:0];
    NSString *year = breakdownInfo.year>0?[NSString stringWithFormat:@"%ld 年",breakdownInfo.year]:@"";
    NSString *month = breakdownInfo.month>0?[NSString stringWithFormat:@" / %ld 月",breakdownInfo.month]:@"";
    NSString *day = breakdownInfo.day>0?[NSString stringWithFormat:@" / %ld 天",breakdownInfo.day]:@"";
    return [NSString stringWithFormat:@"%@%@%@",year,month,day];
}

- (NSString *)dateFormat{
    return @"yyyy/MM/dd";
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

- (NSArray<OffLineCourseModel *> *)courseArr
{
    if(!_courseArr)
    {
        _courseArr = [NSArray array];
    }
    return _courseArr;
}

- (NSArray<OffLineStoreModel *> *)storeArr
{
    if(!_storeArr)
    {
        _storeArr = [NSArray array];
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

- (NSArray<ContractInfoViewModel*> *)viewModelArr
{
    if(!_viewModelArr)
    {
        NSMutableArray <ContractInfoViewModel *> *mutableArr =[NSMutableArray array];
        
        ContractInfoViewModel *model = [ContractInfoViewModel modelWithTitle:@"合同编号" placeholder:@"请扫描合同编号" text:self.infoModel.contractNo isRequired:YES tag:DDCContractInfoNumber type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model];
        
        ContractInfoViewModel *model1 = [ContractInfoViewModel modelWithTitle:@"购买内容" placeholder:@"请选择购买内容" text:@"" isRequired:YES tag:DDCContractInfoContent type:ContractInfoModelTypeChecked];
        for (OffLineCourseModel *courseM in model1.courseArr) {
            courseM.isChecked = NO;
            courseM.count = @"";
        }
        [mutableArr addObject:model1];
        
        ContractInfoViewModel *model2 = [ContractInfoViewModel modelWithTitle:@"生效日期" placeholder:@"请选择生效日期" text:self.infoModel.startTime isRequired:YES tag:DDCContractInfoStartDate type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model2];
        
        ContractInfoViewModel *model3 = [ContractInfoViewModel modelWithTitle:@"结束日期" placeholder:@"请选择结束日期" text:self.infoModel.endTime isRequired:YES tag:DDCContractInfoEndDate type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model3];
        
        ContractInfoViewModel *model4 = [ContractInfoViewModel modelWithTitle:@"有效时间" placeholder:@"请选择有效时间" text:self.infoModel.effectiveTime isRequired:YES tag:DDCContractInfoValidDate type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model4];
        
        ContractInfoViewModel *model5 = [ContractInfoViewModel modelWithTitle:@"有效门店" placeholder:@"请选择有效门店" text:[self.infoModel effectiveAddressString] isRequired:YES tag:DDCContractInfoValidStore type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model5];
        
        ContractInfoViewModel *model6 = [ContractInfoViewModel modelWithTitle:@"合同金额" placeholder:@"请填写合同金额" text:self.infoModel.contractPrice isRequired:YES tag:DDCContractInfoMoney type:ContractInfoModelTypeTextField];
        [mutableArr addObject:model6];
        
        _viewModelArr = [mutableArr copy];

    }
    return _viewModelArr;
    
}

- (void)setModel:(GJObject *)model
{
    if([model isKindOfClass:[DDCContractDetailsModel class]])
    {
        DDCContractDetailsModel *detailM = (DDCContractDetailsModel *)model;
        self.infoModel = detailM.infoModel;
        self.customModel =detailM.user;
    }
    else if([model isKindOfClass:[DDCCustomerModel class]])
    {
        DDCCustomerModel *custom = (DDCCustomerModel *)model;
        self.customModel = custom;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
