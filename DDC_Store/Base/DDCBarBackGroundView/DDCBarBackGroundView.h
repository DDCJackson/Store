//
//  DDCBarCollectionView.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCBottomBar.h"

@interface DDCBarBackGroundView : UIView

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DDCBottomBar  *bottomBar;

/*
 *  初始化 包含CollectionView
 *  @param  frame        frame--用来设置顶部圆角的;如果frame为CGRectZero则没有顶部圆角
 *  @param  hasShadow    是否需要设置边框
 *
 */
- (instancetype)initWithRectCornerTopCollectionViewFrame:(CGRect)frame hasShadow:(BOOL)hasShadow;

/*
 *  初始化 包含TableView
 *  @param  frame        frame--用来设置顶部圆角的;如果frame为CGRectZero则没有顶部圆角
 *  @param  hasShadow    是否需要设置边框
 *
 */
- (instancetype)initWithRectCornerTopTableViewFrame:(CGRect)frame hasShadow:(BOOL)hasShadow;

-(id) init __attribute__((unavailable("必须用自定义的初始方法:")));

@end
