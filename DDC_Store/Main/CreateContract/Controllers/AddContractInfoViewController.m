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
#import "DDCContractModel.h"

//controller
#import "DDCQRCodeScanningController.h"

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
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DDCBottomBar *bottomBar;
@property (nonatomic,strong)DDCBottomButton *nextPageBtn;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"合同编号", @"购买内容",@"生效日期",@"结束日期",@"有效时间",@"有效门店",@"合同金额",nil];
    NSArray *placeholderArr = [NSArray arrayWithObjects:@"请扫描合同编号",@"请选择购买内容",@"请选择生效日期",@"请选择有结束日期",@"请选择有效时间",@"请选择有效门店",@"请填写合同金额", nil];
    NSArray *courseTitleArr=[NSMutableArray arrayWithObjects:@"蛋糕课程",@"面点课程",@"烹饪课程", nil];
    
    self.dataArr = [NSMutableArray array];
    for (int i=0; i<titleArr.count; i++) {
        ContractInfoViewModel *model = [[ContractInfoViewModel alloc]init];
        model.title = titleArr[i];
        model.text = @"";
        model.placeholder = placeholderArr[i];
        model.isFill = NO;
        model.type = ContractInfoModelTypeTextField;
        model.isRequired = YES;
        if(i==DDCContractInfoSectionContent)
        {
            model.type = ContractInfoModelTypeChecked;
            NSMutableArray *courseMutableArr = [NSMutableArray array];
            for (int j=0; j<courseTitleArr.count; j++) {
                OffLineCourseModel *courseM = [[OffLineCourseModel alloc]init];
                courseM.title =courseTitleArr[j];
                courseM.isChecked = NO;
                courseM.count = @"";
                [courseMutableArr addObject:courseM];
            }
            model.courseArr = [NSArray arrayWithArray:courseMutableArr];
            self.courseArr = [model.courseArr mutableCopy];
        }
        [self.dataArr addObject:model];
    }
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
    _storeString= [NSString stringWithFormat:@"线下门店%d",row];
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
    return 15;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"线下门店%d",row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark  - InputFieldCellDelegate
- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *infoModel = self.dataArr[indexPath.section];
    //setText
    [self setText:text section:indexPath.section];
    
    if(indexPath.section==DDCContractInfoSectionStartDate||indexPath.section==DDCContractInfoSectionEndDate)
    {
        if(self.startDate.length&&self.endDate.length)
        {
            NSInteger day = [Tools numberOfDaysWithFromDate:[Tools dateWithDateString:self.startDate] toDate:[Tools dateWithDateString:self.endDate]];
            [self setText:[NSString stringWithFormat:@"%li天",day] section:DDCContractInfoSectionValidDate];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoSectionValidDate]];
        }
    }else if (indexPath.section==DDCContractInfoSectionValidStore)
    {
        [self setText:_storeString section:DDCContractInfoSectionValidStore];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:DDCContractInfoSectionValidStore]];

    }
    if(infoModel.isFill)
    {
        [self refreshNextPageBtnBgColor];
    }
    else
    {
        [self.nextPageBtn setClickable:NO];
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
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark - CheckBoxCellDelegate
-(void)clickCheckedBtn:(BOOL)isChecked indexPath:(NSIndexPath *)indexPath
{
    ContractInfoViewModel *infoModel = self.dataArr[DDCContractInfoSectionContent];
    OffLineCourseModel *courseM =  infoModel.courseArr[indexPath.item-1];
    courseM.isChecked = isChecked;
    courseM.count = @"";
    infoModel.placeholder =  infoModel.isFill== YES ?@"请选择购买内容": @"请填写购买数量";
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
    ContractInfoViewModel *infoModel = self.dataArr[DDCContractInfoSectionContent];
    //记录在textfield中填写的内容
    OffLineCourseModel *courseModel = infoModel.courseArr[indexPath.item-1];
    courseModel.count = text;
    //设置是否填写了内容
    infoModel.placeholder =  infoModel.isFill== YES ? @"请选择购买内容": @"请填写购买数量";
    //刷新
    [self refreshNextPageBtnBgColor];
}

#pragma mark -  刷新下一页按钮的背景色
- (void)refreshNextPageBtnBgColor
{
    //遍历,只有满足所有必填项都填写了，颜色为空；否则为灰色
    for (int i =0; i<self.dataArr.count; i++) {
        ContractInfoViewModel *infoModel = self.dataArr[i];
        if(infoModel.isRequired&&!infoModel.isFill)
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
    ContractInfoViewModel *infoModel = self.dataArr[indexPath.section];
    if(indexPath.item == 0)
    {
        TitleCollectionCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
        [titleCell configureWithTitle:infoModel.title isRequired:infoModel.isRequired tips:infoModel.placeholder isShowTips:(!infoModel.isFill&&_isClickedRightBtn)];
        return titleCell;
    }
    else if(indexPath.section==DDCContractInfoSectionContent)
    {
        CheckBoxCell *checkCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CheckBoxCell class]) forIndexPath:indexPath];
        OffLineCourseModel *courseM = infoModel.courseArr[indexPath.item-1];
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
                [cell configureCellWithViewModel:infoModel btnTitle:infoModel.text.length?@"扫一扫":@"重新扫描"];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
            case DDCContractInfoSectionStartDate:
            case DDCContractInfoSectionEndDate:
            {
                [cell configureCellWithViewModel:infoModel];
                cell.style = InputFieldCellStyleDatePicker;
            }
                break;
            case DDCContractInfoSectionValidStore:
            {
                [cell configureCellWithViewModel:infoModel];
                cell.style = InputFieldCellStylePicker;
            }
                break;
            case DDCContractInfoSectionMoney:
            {
                [cell configureCellWithViewModel:infoModel extraTitle:@"元"];
                cell.style = InputFieldCellStyleNumber;

            }
                break;
            default:
            {
                [cell configureCellWithViewModel:infoModel];
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


#pragma mark - getters & setter
- (NSString *)getTextWithSection:(DDCContractInfoSection)section
{
    ContractInfoViewModel *infoModel = (ContractInfoViewModel *)self.dataArr[section];
    return infoModel.text?infoModel.text:nil;
}

- (void)setText:(NSString *)text section:(DDCContractInfoSection)section
{
    ContractInfoViewModel *infoModel = (ContractInfoViewModel *)self.dataArr[section];
    infoModel.text = text;
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
        __weak typeof(self.nextPageBtn) weakRightBtn = self.nextPageBtn;
        self.nextPageBtn = [[DDCBottomButton alloc]initWithTitle:@"下一步" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"下一步");
            _isClickedRightBtn = YES;
            [weakSelf.collectionView reloadData];
            //不可点击的时候
            if(weakRightBtn.clickable)
            {
                [self.view makeDDCToast:@"信息填写不完整，请填写完整" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
            }
            else
            {
                
            }
        }];
        [_bottomBar addBtn:self.nextPageBtn];
        [self.nextPageBtn setClickable:NO];
    
    }
    return _bottomBar;
}

@end
