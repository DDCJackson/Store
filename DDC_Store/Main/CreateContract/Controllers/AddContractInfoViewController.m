//
//  AddContactInfoViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "AddContractInfoViewController.h"
#import "InputFieldCell.h"
#import "TitleCollectionCell.h"
#import "DDCBottomBar.h"

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)NSArray *placeholderArr;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData
{
    self.titleArr = [NSArray arrayWithObjects:@"合同编号", @"购买内容",@"生效日期",@"结束日期",@"有效时间",@"有效门店",@"合同金额",nil];
    self.placeholderArr = [NSArray arrayWithObjects:@"请扫描合同编号",@"请选择内容",@"请选择生效日期",@"请选择有结束日期",@"请选择有效时间",@"请选择有效门店",@"请填写合同金额", nil];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(70);
        make.right.equalTo(self.view).offset(-70);
        make.top.bottom.equalTo(self.view);
    }];
    
    DDCBottomBar *bar = [DDCBottomBar showDDCBottomBarWithPreferredStyle:DDCBottomBarStyleWithLine];
    [self.view addSubview:bar];
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([DDCBottomBar height]);
    }];
    [bar addBtn:[[DDCBottomButton alloc]initWithTitle:@"上一步" style:DDCBottomButtonStyleSecondary handler:^{
        DLog(@"上一步");
    }]];
    
    [bar addBtn:[[DDCBottomButton alloc]initWithTitle:@"下一步" style:DDCBottomButtonStylePrimary handler:^{
        DLog(@"下一步");
    }]];

}

#pragma mark  - UICollectionViewDelegate&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.titleArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(indexPath.item == 0)
    {
        TitleCollectionCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
        [titleCell configureWithTitle:self.titleArr[indexPath.section] isRequired:YES tips:self.placeholderArr[indexPath.section] isShowTips:YES];
        return titleCell;
    }
    else
    {
         InputFieldCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class]) forIndexPath:indexPath];
        if(indexPath.section==1)
        {
            [cell configureWithPlaceholder:self.placeholderArr[indexPath.section] btnTitle:@"扫一扫"];

        }else
        {
            [cell configureWithPlaceholder:self.placeholderArr[indexPath.section]];
        }
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item==0)
    {
        return CGSizeMake(DEVICE_WIDTH - 160, [TitleCollectionCell height]);
    }
    return  CGSizeMake(DEVICE_WIDTH - 160, 60);
}

#pragma mark - getters-

- (UICollectionView *)collectionView
{
   if(!_collectionView)
   {
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
       layout.minimumLineSpacing = 10;
       layout.minimumInteritemSpacing = 10;
       layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
       _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
       _collectionView.backgroundColor = [UIColor whiteColor];
       //register
       [_collectionView registerClass:[TitleCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class])];
       [_collectionView registerClass:[InputFieldCell class] forCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class])];
   }
   return _collectionView;
}

@end
