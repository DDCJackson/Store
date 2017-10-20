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
#import "DDCBottomBar.h"
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

typedef NS_ENUM(NSUInteger,DDCContractInfoSection)
{
    DDCContractInfoSectionNumber = 0,
    DDCContractInfoSectionContent,
    DDCContractInfoSectionStartDate,
    DDCContractInfoSectionEndDate,
    DDCContractInfoSectionValidDate,
    DDCContractInfoSectionValidStore,
    DDCContractInfoSectionMoney
};

static const CGFloat kDefaultWidth = 500;

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CheckBoxCellDelegate,InputFieldCellDelegate,ToolBarSearchViewTextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _isClickedRightBtn;
    NSString *_storeString;
}

/*生效日期*/
@property (nonatomic,strong)NSString *startDate;
/*结束日期*/
@property (nonatomic,strong)NSString *endDate;

@property (nonatomic,strong)NSMutableArray<ContractInfoViewModel *> *dataArr;
@property (nonatomic,strong)NSMutableArray<OffLineCourseModel *> *courseArr;
@property (nonatomic,strong)NSMutableArray<OffLineStoreModel *> *storeArr;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DDCBottomBar *bottomBar;
@property (nonatomic,strong)DDCBottomButton *nextPageBtn;
@property (nonatomic,strong)DDCContractInfoModel *infoModel;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestCourseList];
    [self requestStoreList];
   
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
//    NSArray *courseTitleArr=[NSMutableArray arrayWithObjects:@"蛋糕课程",@"面点课程",@"烹饪课程", nil];
    
    self.dataArr = [NSMutableArray array];
    for (int i=0; i<titleArr.count; i++) {
        ContractInfoViewModel *model = [ContractInfoViewModel modelWithTitle:titleArr[i] placeholder: placeholderArr[i] text:@"" isRequired:YES tag:i];
        model.isFill = NO;
        model.type = ContractInfoModelTypeTextField;
        model.isRequired = YES;
        if(i==DDCContractInfoSectionContent)
        {
            model.type = ContractInfoModelTypeChecked;
            model.courseArr = self.courseArr;
            for (OffLineCourseModel *courseM in model.courseArr) {
                courseM.isChecked = NO;
                courseM.count = @"";
            }
        }
        [self.dataArr addObject:model];
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
    
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([DDCBottomBar height]);
    }];
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


#pragma mark  - InputFieldCellDelegate
- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.dataArr[indexPath.section];
    //setText
    [self setText:text section:indexPath.section];
    
    //下一步按钮颜色的处理
    if(viewModel.isFill){
        [self refreshNextPageBtnBgColor];
    }else{
        [self.nextPageBtn setClickable:NO];
    }
}

//弹出picker后，点击确定按钮
- (void)clickeDoneBtn:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==DDCContractInfoSectionValidStore)
    {
        /******有效门店*****/
        [self setText:_storeString section:DDCContractInfoSectionValidStore];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoSectionValidStore]];
    }
    
    if(indexPath.section==DDCContractInfoSectionStartDate||indexPath.section==DDCContractInfoSectionEndDate)
    {
        [self setText:text section:indexPath.section];
        /******自动计算有效时间*****/
        if(self.startDate&&self.startDate.length&&self.endDate&&self.endDate.length)
        {
            NSInteger day = [Tools numberOfDaysWithFromDate:[Tools dateWithDateString:self.startDate] toDate:[Tools dateWithDateString:self.endDate]];
            if(day<=0)
            {
                [self setText:@"" section:indexPath.section];
                if(indexPath.section==DDCContractInfoSectionStartDate){
                    [self.view makeDDCToast:@"生效日期不得大于结束日期" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
                }
                else{
                    [self.view makeDDCToast:@"结束日期不得小于生效日期" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
                }
                return;
            }
            [self setText:[NSString stringWithFormat:@"%li天",day] section:DDCContractInfoSectionValidDate];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoSectionValidDate]];
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
        [weakSelf setText:number section:DDCContractInfoSectionNumber];
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [weakSelf refreshNextPageBtnBgColor];
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark - CheckBoxCellDelegate
-(void)clickCheckedBtn:(BOOL)isChecked indexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.dataArr[DDCContractInfoSectionContent];
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
    ContractInfoViewModel *viewModel = self.dataArr[DDCContractInfoSectionContent];
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
    for (int i =0; i<self.dataArr.count; i++) {
        ContractInfoViewModel *viewModel = self.dataArr[i];
        if(viewModel.isRequired&&!viewModel.isFill)
        {
            self.nextPageBtn.clickable = NO;
            break;
        }
        if(i==self.dataArr.count-1)
        {
            self.nextPageBtn.clickable = YES;
        }
    }
}

#pragma mark  - UICollectionViewDelegate&UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==DDCContractInfoSectionContent)
    {
        return 1+self.courseArr.count;
    }
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *viewModel = self.dataArr[indexPath.section];
    if(indexPath.item == 0)
    {
        TitleCollectionCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
        [titleCell configureWithTitle:viewModel.title isRequired:viewModel.isRequired tips:viewModel.placeholder isShowTips:(!viewModel.isFill&&_isClickedRightBtn)];
        return titleCell;
    }
    else if(indexPath.section==DDCContractInfoSectionContent)
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
            case DDCContractInfoSectionNumber:
            {
                [cell configureCellWithViewModel:viewModel btnTitle:viewModel.text.length?@"扫一扫":@"重新扫描"];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
            case DDCContractInfoSectionStartDate:
            case DDCContractInfoSectionEndDate:
            {
                [cell configureCellWithViewModel:viewModel];
                cell.style = InputFieldCellStyleDatePicker;
            }
                break;
            case DDCContractInfoSectionValidStore:
            {
                [cell configureCellWithViewModel:viewModel];
                cell.style = InputFieldCellStylePicker;
            }
                break;
            case DDCContractInfoSectionMoney:
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
    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionNumber] forKey:@"contractNo"];
    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionStartDate] forKey:@"startTime"];
    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionEndDate] forKey:@"endTime"];
    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionValidDate] forKey:@"effectiveTime"];
        [mutableDict setValue:@"7" forKey:@"courseAddressId"];
//    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionValidStore] forKey:@"courseAddressId"];
    [mutableDict setValue:[self getTextWithSection:DDCContractInfoSectionMoney] forKey:@"contractPrice"];
    
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
- (NSString *)getTextWithSection:(DDCContractInfoSection)section
{
    ContractInfoViewModel *viewModel = (ContractInfoViewModel *)self.dataArr[section];
    return viewModel.text?viewModel.text:@"";
}

- (void)setText:(NSString *)text section:(DDCContractInfoSection)section
{
    ContractInfoViewModel *viewModel = (ContractInfoViewModel *)self.dataArr[section];
    viewModel.text = text;
}

- (NSString *)startDate
{
    return [self getTextWithSection:DDCContractInfoSectionStartDate];
}

- (NSString *)endDate
{
    return [self getTextWithSection:DDCContractInfoSectionEndDate];
}

- (NSMutableArray *)courseArr
{
  if(!_courseArr)
  {
      _courseArr = [NSMutableArray array];
  }
  return _courseArr;
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

- (DDCBottomBar *)bottomBar
{
    if(!_bottomBar)
    {
        _bottomBar = [DDCBottomBar showDDCBottomBarWithPreferredStyle:DDCBottomBarStyleWithLine];
        [_bottomBar addBtn:[[DDCBottomButton alloc]initWithTitle:@"上一步" style:DDCBottomButtonStyleSecondary handler:^{
            DLog(@"上一步");
        }]];
        
        __weak typeof(self) weakSelf = self;
        self.nextPageBtn = [[DDCBottomButton alloc]initWithTitle:@"下一步" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"下一步");
            _isClickedRightBtn = YES;
            [weakSelf.collectionView reloadData];
            //不可点击的时候
            if(!weakSelf.nextPageBtn.clickable)
            {
                [weakSelf.view makeDDCToast:@"信息填写不完整，请填写完整" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
            }
            else
            {
                [weakSelf saveContractInfo];
            }
        }];
        [_bottomBar addBtn:self.nextPageBtn];
        [self.nextPageBtn setClickable:NO];
    
    }
    return _bottomBar;
}

@end
