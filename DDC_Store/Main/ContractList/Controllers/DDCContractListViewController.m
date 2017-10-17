//
//  DDCContractListViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractListViewController.h"
#import "DDCLoginRegisterViewController.h"
#import "DDCStore.h"
#import "DDCUserModel.h"
#import "CreateContractViewController.h"

@interface DDCContractListViewController() <DDCContractListViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) DDCUserModel * user;

@end

@implementation DDCContractListViewController

@dynamic view;

#pragma mark - Lifecycle

- (void)loadView
{
    self.view = [[DDCContractListView alloc] initWithDelegate:self dataSource:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self login];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Private
- (void)login
{
    __weak typeof(self) weakSelf = self;
    if (!self.user)
    {
        [DDCLoginRegisterViewController loginWithTarget:self successHandler:^(BOOL success) {
            if (success)
            {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [weakSelf reloadPage];
                }];
            }
        }];
    }
    else
    {
        [self reloadPage];
    }
}

- (void)reloadPage
{
    if (self.user)
    {
        self.view.profileView.name = self.user.nickname;
        self.view.profileView.imgUrlStr = self.user.imgUrlStr;
    }
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEVICE_WIDTH, 80);
}

#pragma mark - View Delegate
- (void)rightNaviBtnPressed
{
    __weak typeof(self) weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"你确定要登出吗？", @"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DDCStore sharedInstance].user = nil;
        [weakSelf login];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createNewContract
{
    CreateContractViewController * vc = [[CreateContractViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters

- (DDCUserModel *)user
{
    return [DDCStore sharedInstance].user;
}

@end
