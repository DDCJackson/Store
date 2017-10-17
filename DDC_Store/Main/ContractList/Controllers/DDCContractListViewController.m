//
//  DDCContractListViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractListViewController.h"

#import "DDCStore.h"
#import "DDCUserModel.h"
#import "DDCContractModel.h"

#import "DDCLoginRegisterViewController.h"
#import "CreateContractViewController.h"
#import "ContractDetailsViewController.h"

#import "DDCContractListCell.h"
#import "DDCOrderingHeaderView.h"
#import "DDCOrderingTableViewController.h"

@interface DDCContractListViewController() <DDCContractListViewDelegate, UICollectionViewDataSource, DDCOrderingHeaderViewDelegate>

@property (nonatomic, strong) DDCUserModel * user;
@property (nonatomic, strong) DDCOrderingTableViewController * orderingTableViewController;
@property (nonatomic, copy) NSArray * contractArray;

@end

@implementation DDCContractListViewController

@dynamic view;

#pragma mark - Lifecycle

#warning Add Footer and Footer Callback for next page data
- (void)loadView
{
    self.view = [[DDCContractListView alloc] initWithDelegate:self dataSource:self];
    [self.view.collectionHolderView.collectionView registerClass:[DDCContractListCell class] forCellWithReuseIdentifier:NSStringFromClass([DDCContractListCell class])];
    [self.view.collectionHolderView.collectionView registerClass:[DDCOrderingHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DDCOrderingHeaderView class])];
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

- (void)popOrderingMenuAtRect:(CGRect)popRect callback:(OrderingUpdateCallback)callback
{
    self.orderingTableViewController.block = callback;
    UIPopoverPresentationController *popover = self.orderingTableViewController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = popRect;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:self.orderingTableViewController animated:YES completion:nil];
}

- (void)reloadPage
{
    if (self.user)
    {
        self.view.profileView.name = self.user.nickname;
        self.view.profileView.imgUrlStr = self.user.imgUrlStr;
        [self.view.collectionHolderView.collectionView reloadData];
    }
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contractArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCContractListCell * cell = (DDCContractListCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDCContractListCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = (indexPath.row % 2) ? UIColor.whiteColor : [UIColor colorWithHexString:@"#F8F8F8"];
    [cell configureWithModel:self.contractArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ContractDetailsViewController * vc = [[ContractDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEVICE_WIDTH, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(DEVICE_WIDTH, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DDCOrderingHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([DDCOrderingHeaderView class]) forIndexPath:indexPath];
    [view configureWithTitle:NSLocalizedString(@"我创建的合同", @"") delegate:self];
    return view;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.;
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

#pragma mark - Header Delegate
- (void)headerView:(DDCOrderingHeaderView*)headerView orderingBtnPressedWithUpdateCallback:(OrderingUpdateCallback)callback
{
    CGRect popRect = [self.view.collectionHolderView convertRect:headerView.frame toView:self.view];
//    popRect.y =  popRect.origin.y+popRect.size.height;
//    popRect.x = frameInView.origin.x+frameInView.size.width/2;
//    CGPoint popPoint = CGPointMake(x, y);
    
    [self popOrderingMenuAtRect:popRect callback:callback];
}

#pragma mark - Getters

- (DDCUserModel *)user
{
    return [DDCStore sharedInstance].user;
}

- (DDCOrderingTableViewController *)orderingTableViewController
{
    if (!_orderingTableViewController)
    {
        _orderingTableViewController = [[DDCOrderingTableViewController alloc] initWithStyle:UITableViewStylePlain selectedBlock:nil];
    }
    return _orderingTableViewController;
}

- (NSArray *)contractArray
{
    if (!_contractArray)
    {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i = 0; i < 20; i++)
        {
            [arr addObject:[DDCContractModel randomInit]];
        }
        _contractArray = arr;
    }
    return _contractArray;
}

@end
