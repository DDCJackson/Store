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
#import "DDCContractModel.h"

//controller
#import "DDCQRCodeScanningController.h"

static const CGFloat kDefaultWidth = 500;
static const NSInteger kBigTextFieldTag = 400;
static const NSInteger kSmallTextFieldTag = 300;
static const NSInteger kCourseSection = 1;

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CheckBoxCellDelegate,InputFieldCellDelegate,ToolBarSearchViewTextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _isClickedRightBtn;
}

@property (nonatomic,strong)NSMutableArray<ContractInfoViewModel *> *dataArr;
@property (nonatomic,strong)NSMutableArray<OffLineCourseModel *> *courseArr;

@property (nonatomic,strong)DDCContractInfoModel *model;

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[DDCContractInfoModel alloc]init];
    [self createData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
        if(i==kCourseSection)
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
    
//    [self.view addSubview:self.bottomBar];
//    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.mas_equalTo([DDCBottomBar height]);
//    }];
}


#pragma mark - UIPickerViewDelegate/DataSource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
    return @"线下门店";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField *textField = [not object];
    
    if(textField.tag>=kBigTextFieldTag)
    {
        NSInteger index = textField.tag - kBigTextFieldTag;
        ContractInfoViewModel *infoModel = self.dataArr[index];
        infoModel.text = textField.text;
        
        BOOL  isFill = textField.text.length ? YES :NO;
        //如果有状态发生改变,才修改值
        if(infoModel.isFill!=isFill)
        {
            infoModel.isFill = isFill;
            //当新的状态为YES的时候,遍历；当所有的值都为YES的时候，按钮才可点击
            if(isFill){
                [self refreshNextPageBtnBgColor];
            }else{
                [self.nextPageBtn setClickable:NO];
            }
        }
    }
    else
    {
        /*********购买内容课程这个section*******/
        NSInteger index = textField.tag - kSmallTextFieldTag;
        ContractInfoViewModel *infoModel = self.dataArr[kCourseSection];
        //记录在textfield中填写的内容
        OffLineCourseModel *courseModel = infoModel.courseArr[index];
        courseModel.count = textField.text;
        //设置是否填写了内容
        infoModel.isFill = [self getOffLineCourseIsFillWithInfoModel:infoModel];
        [self setOffLineCourseTips];
        //刷新
        [self refreshNextPageBtnBgColor];
    }
}

//设置购买内容的提示语
- (void)setOffLineCourseTips
{
    ContractInfoViewModel *infoModel = self.dataArr[kCourseSection];
    for (int i=0; i<infoModel.courseArr.count; i++) {
        OffLineCourseModel *courseM = infoModel.courseArr[i];
        if(courseM.isChecked)
        {
            infoModel.placeholder = @"请填写购买数量";
            break;
        }
        if(i==infoModel.courseArr.count-1)
        {
            infoModel.placeholder = @"请选择购买内容";
        }
    }
}

//获取是否填写了内容
- (BOOL)getOffLineCourseIsFillWithInfoModel:(ContractInfoViewModel *)infoModel
{
    BOOL isFill = NO;
    for (int i =0; i<infoModel.courseArr.count; i++) {
        OffLineCourseModel *courseM = infoModel.courseArr[i];
        if(courseM.isChecked&&courseM.count.length==0)
        {
            isFill = NO;
            break;
        }
        if(courseM.isChecked&&courseM.count.length!=0)
        {
            isFill =YES;
        }
    }
    return isFill;
}

//刷新下一页按钮的背景色
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

#pragma mark -ChildContractViewControllerDelegate
- (void)forwardNextPage
{
    _isClickedRightBtn = YES;
    [self.collectionView reloadData];
    //不可点击的时候
    if(self.nextPageBtn.clickable)
    {
        [self.view makeDDCToast:@"信息填写不完整，请填写完整" image:[UIImage imageNamed:@""] imagePosition:ImageTop];
    }
}

- (void)backwardPreviousPage
{
    
}


#pragma mark - CheckBoxCellDelegate
-(void)clickCheckedBtn:(BOOL)isChecked textFieldTag:(NSInteger)textFieldTag
{
    ContractInfoViewModel *infoModel = self.dataArr[kCourseSection];
    OffLineCourseModel *courseM =  infoModel.courseArr[textFieldTag-kSmallTextFieldTag];
    courseM.isChecked = isChecked;
    courseM.count = @"";
    [self setOffLineCourseTips];
    if(isChecked)
    {
        self.nextPageBtn.clickable = NO;
    }
    else
    {
        infoModel.isFill = [self getOffLineCourseIsFillWithInfoModel:infoModel];
        [self refreshNextPageBtnBgColor];
    }
}

#pragma mark - InputFieldCellDelegate
- (void)clickFieldBehindBtn
{
    /********扫一扫功能*********/
    DDCQRCodeScanningController *scanVC = [[DDCQRCodeScanningController alloc]init];
    __weak typeof(self) weakSelf = self;
    scanVC.identifyResults = ^(NSString *number) {
        weakSelf.model.contractNum = [number copy];
        [weakSelf.collectionView reloadData];
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)clickToobarFinishBtn:(NSString *)str
{
    
}

#pragma mark  - UICollectionViewDelegate&UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==kCourseSection)
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
    else if(indexPath.section==kCourseSection)
    {
        CheckBoxCell *checkCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CheckBoxCell class]) forIndexPath:indexPath];
        OffLineCourseModel *courseM = infoModel.courseArr[indexPath.item-1];
        [checkCell setCourseModel:courseM textFieldTag:kSmallTextFieldTag + indexPath.item-1 delegate:self];
        return checkCell;
    }
    else
    {
         InputFieldCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.tag  = kBigTextFieldTag + indexPath.section;
        switch (indexPath.section) {
            case 0:
            {
                [cell configureWithPlaceholder:infoModel.placeholder btnTitle:self.model.contractNum.length?@"扫一扫":@"重新扫描" text:self.model.contractNum];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
            case 2:
            {
                [cell configureWithPlaceholder:infoModel.placeholder text:self.model.stateDate];
                cell.style = InputFieldCellStyleDatePicker;
                
            }
                break;
            case 3:
            {
                [cell configureWithPlaceholder:infoModel.placeholder text:self.model.endDate];
                cell.style = InputFieldCellStyleDatePicker;
            }
                break;
            case 4:
            {
                [cell configureWithPlaceholder:infoModel.placeholder text:self.model.validDate];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
            case 5:
            {
                [cell configureWithPlaceholder:infoModel.placeholder text:self.model.validStore];
                cell.style = InputFieldCellStylePicker;
            }
                break;
            case 6:
            {
                [cell configureWithPlaceholder:infoModel.placeholder extraTitle:@"元" text:self.model.money];
                cell.style = InputFieldCellStyleNormal;
            }
                break;
                
            default:
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

#pragma mark - getters-

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

@end
