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
#import "CreateContractBottomView.h"

@interface AddContractInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation AddContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
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
    
    UIView *bottomView = [CreateContractBottomView showOneBtnWithBtnTitle:@"下一步" clickAction:^{
        
    }];
    bottomView.backgroundColor =[UIColor redColor];
    [self.collectionView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.collectionView);
        make.height.mas_equalTo(100);
    }];
    
}

#pragma mark  - UICollectionViewDelegate&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TitleCollectionCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TitleCollectionCell class]) forIndexPath:indexPath];
    
    InputFieldCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InputFieldCell class]) forIndexPath:indexPath];
    //随意写下
    if(indexPath.section==0)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }
        [cell configureWithTitle:@"合同编号" placeholder:@"请扫面合同编号"];
    }else if(indexPath.section==1)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }
        [cell configureWithTitle:@"生效日期" placeholder:@"请选择生效日期"];

    }else if(indexPath.section==2)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }

        [cell configureWithTitle:@"有效时间" placeholder:@"有效时间"];

    }else if(indexPath.section==3)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }

        [cell configureWithTitle:@"有效门店" placeholder:@"请选择有效门店"];

    }else if(indexPath.section==4)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }

        [cell configureWithTitle:@"合同金额" placeholder:@"请输入合同金额"];

    }else if(indexPath.section==5)
    {
        if(indexPath.item==0){
            titleCell.titleLabel.text = @"测试";
            return titleCell;
        }

        [cell configureWithTitle:@"合同编号" placeholder:@"请扫面合同编号"];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(80, 80);
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
