//
//  DDCOrderingHeaderView.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderingUpdateCallback)(NSString *newOrdering);

@class DDCOrderingHeaderView;
@protocol DDCOrderingHeaderViewDelegate <NSObject>

- (void)headerView:(DDCOrderingHeaderView *)headerView orderingBtnPressedWithUpdateCallback:(OrderingUpdateCallback)callback;

@end

@interface DDCOrderingHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<DDCOrderingHeaderViewDelegate> delegate;

- (void)configureWithTitle:(NSString *)title delegate:(id<DDCOrderingHeaderViewDelegate>)delegate;

@end
