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

//model
#import "ContractInfoModel.h"
#import "OffLineCourseModel.h"

static const CGFloat kDefaultWidth = 500;
static const NSInteger kBigTextFieldTag = 400;
static const NSInteger kSmallTextFieldTag = 300;
static const NSInteger kCourseSection = 1;

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CheckBoxCellDelegate,InputFieldCellDelegate>
{
    BOOL _isClickedRightBtn;
}

@property (nonatomic,strong)NSMutableArray<ContractInfoModel *> *dataArr;
@property (nonatomic,strong)NSMutableArray *courseArr;

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DDCBottomBar *bottomBar;
@property (nonatomic,strong)DDCBottomButton *nextPageBtn;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)createData
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"合同编号", @"购买内容",@"生效日期",@"结束日期",@"有效时间",@"有效门店",@"合同金额",nil];
    NSArray *placeholderArr = [NSArray arrayWithObjects:@"请扫描合同编号",@"请选择内容",@"请选择生效日期",@"请选择有结束日期",@"请选择有效时间",@"请选择有效门店",@"请填写合同金额", nil];
    self.courseArr =[NSMutableArray arrayWithObjects:@"蛋糕课程",@"面点课程",@"烹饪课程", nil];
    
    self.dataArr = [NSMutableArray array];
    for (int i=0; i<titleArr.count; i++) {
        ContractInfoModel *model = [[ContractInfoModel alloc]init];
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
            for (int j=0; j<self.courseArr.count; j++) {
                OffLineCourseModel *courseM = [[OffLineCourseModel alloc]init];
                courseM.title =self.courseArr[j];
                courseM.isChecked = NO;
                courseM.count = @"";
                [courseMutableArr addObject:courseM];
            }
            model.courseArr = [NSArray arrayWithArray:courseMutableArr];
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

#pragma mark - Notification Events
- (void)textFieldDidChange:(NSNotification *)not
{
    UITextField *textField = [not object];
    
    if(textField.tag>=kBigTextFieldTag)
    {
        NSInteger index = textField.tag - kBigTextFieldTag;
        ContractInfoModel *infoModel = self.dataArr[index];
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
        ContractInfoModel *infoModel = self.dataArr[kCourseSection];
        //记录在textfield中填写的内容
        OffLineCourseModel *courseModel = infoModel.courseArr[index];
        courseModel.count = textField.text;
        //设置是否填写了内容
        infoModel.isFill = [self getOffLineCourseIsFillWithInfoModel:infoModel];
        //刷新
        [self refreshNextPageBtnBgColor];
    }
}

//获取是否填写了内容
- (BOOL)getOffLineCourseIsFillWithInfoModel:(ContractInfoModel *)infoModel
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
        ContractInfoModel *infoModel = self.dataArr[i];
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

#pragma mark - CheckBoxCellDelegate
-(void)clickCheckedBtn:(BOOL)isChecked textFieldTag:(NSInteger)textFieldTag
{
    ContractInfoModel *infoModel = self.dataArr[kCourseSection];
    OffLineCourseModel *courseM =  infoModel.courseArr[textFieldTag-kSmallTextFieldTag];
    courseM.isChecked = isChecked;
    courseM.count = @"";
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
    //扫一扫
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
    ContractInfoModel *infoModel = self.dataArr[indexPath.section];
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
        [cell setTextFieldTag:kBigTextFieldTag + indexPath.section text:infoModel.text];
        if(indexPath.section==0)
        {
            [cell configureWithPlaceholder:infoModel.placeholder btnTitle:[cell isBlankOfTextField]?@"扫一扫":@"重新扫描"];

        }
        else if(indexPath.section==6)
        {
            [cell configureWithPlaceholder:infoModel.placeholder extraTitle:@"元"];
        }
        else
        {
            [cell configureWithPlaceholder:infoModel.placeholder];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
