//
//  DDCContractListView.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCUserProfileView.h"

@class DDCBarCollectionView;
@class DDCNavigationBar;

@protocol DDCContractListViewDelegate <UICollectionViewDelegateFlowLayout, NSObject>

- (void)rightNavButtonPressed;

@end

@interface DDCContractListView : UIImageView

- (instancetype)initWithDelegate:(id<DDCContractListViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource;

@property (nonatomic, strong) DDCNavigationBar * navigationBar;
@property (nonatomic, strong) DDCBarCollectionView * collectionView;
@property (nonatomic, strong) DDCUserProfileView * profileView;
@property (nonatomic, weak) id<DDCContractListViewDelegate> delegate;
@property (nonatomic, weak) id<UICollectionViewDataSource> dataSource;

@end
