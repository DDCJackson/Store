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

@interface DDCEditClientInfoViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    BOOL      _showHints;
}

@property (nonatomic, strong) DDCBarBackgroundView * view;
@property (nonatomic, strong) DDCCustomerModel * model;
@property (nonatomic, copy) NSArray<ContractInfoViewModel *> * viewModelArray;

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
    __weak typeof(self) weakSelf = self;
    DDCBottomButton * prevBtn = [[DDCBottomButton alloc] initWithTitle:NSLocalizedString(@"上一步", @"") style:DDCBottomButtonStyleSecondary handler:^{
        [weakSelf.delegate previousPage];
    }];
    DDCBottomButton * nextBtn = [[DDCBottomButton alloc] initWithTitle:NSLocalizedString(@"下一步", @"") style:DDCBottomButtonStylePrimary handler:^{
        
        for (ContractInfoViewModel * viewModel in self.viewModelArray)
        {
            if (viewModel.isRequired && !viewModel.isFill)
            {
                if (weakSelf)
                {
                    __strong typeof(weakSelf) sself = weakSelf;
                    sself->_showHints = YES;
                    [sself.view makeDDCToast:NSLocalizedString(@"信息填写不完整，请填写完整", @"") image:[UIImage imageNamed:@"addCar_icon_fail"]];
                    [sself.view.collectionView reloadData];
                }
                return;
            }
        }
        // 创建model
        // 接口
        [weakSelf.delegate nextPageWithModel:self.model];
    }];
    [self.view.bottomBar addBtn:prevBtn];
    [self.view.bottomBar addBtn:nextBtn];
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
    
    return cell;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.viewModelArray[textField.tag].text = textField.text.length ? textField.text : nil;
}

#pragma mark - Getters
- (NSArray<ContractInfoViewModel *> *)viewModelArray
{
    if (!_viewModelArray)
    {
        _viewModelArray = @[[ContractInfoViewModel modelWithTitle:NSLocalizedString(@"姓名", @"") placeholder:NSLocalizedString(@"请输入姓名", @"") text:self.model.nickName isRequired:YES tag:DDCClientTextFieldName],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"性别", @"") placeholder:NSLocalizedString(@"请选择性别", @"") text:DDCCustomerModel.genderArray[self.model.sex] isRequired:YES tag:DDCClientTextFieldSex],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"生日", @"") placeholder:NSLocalizedString(@"请输入生日", @"") text:self.model.formattedBirthday isRequired:YES tag:DDCClientTextFieldBirthday],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"年龄", @"") placeholder:NSLocalizedString(@"年龄", @"") text:self.model.age.stringValue isRequired:NO tag:DDCClientTextFieldAge],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"邮箱", @"") placeholder:NSLocalizedString(@"请输入邮箱", @"") text:self.model.email isRequired:NO tag:DDCClientTextFieldEmail],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"职业", @"") placeholder:NSLocalizedString(@"请选择职业",@"") text:DDCCustomerModel.occupationArray[self.model.career] isRequired:NO tag:DDCClientTextFieldCareer],
                            [ContractInfoViewModel modelWithTitle:NSLocalizedString(@"渠道", @"") placeholder:NSLocalizedString(@"请选择渠道", @"") text:DDCCustomerModel.channelArray[self.model.channel] isRequired:NO tag:DDCClientTextFieldChannel]
                           ];
    }
    return _viewModelArray;
}

@end
