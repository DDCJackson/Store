//
//  DDCBarBackgroundView.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCBarBackgroundView.h"


@implementation DDCBarBackgroundView

- (instancetype)initWithRectCornerTopCollectionViewFrame:(CGRect)frame hasShadow:(BOOL)hasShadow
{
    if(self = [super init])
    {
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomBar];
        self.collectionView.frame = self.bounds;
        [self setRectCornerTop:self.collectionView];
        if(hasShadow)
        {
             [self setBlackShadow:self.collectionView];
        }
        
        [self setupViewConstraints];
    }
    return self;
}

- (instancetype)initWithRectCornerTopTableViewFrame:(CGRect)frame hasShadow:(BOOL)hasShadow
{
    if(self = [super init])
    {
        [self addSubview:self.tableView];
        [self addSubview:self.bottomBar];
        self.tableView.frame = self.bounds;
        [self setRectCornerTop:self.tableView];
    
        if(hasShadow)
        {
            [self setBlackShadow:self.tableView];
        }
        
        [self setupViewConstraints];
        
    }
    return self;
}


- (void)setupViewConstraints
{
    if([self.subviews containsObject:self.collectionView])
    {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-[DDCBottomBar height]);
        }];
    }
    else if ([self.subviews containsObject:self.tableView])
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-[DDCBottomBar height]);
        }];
    }
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo([DDCBottomBar height]);
    }];
}


#pragma mark - private
//设置黑色阴影
- (void)setBlackShadow:(UIView *)targetView
{
    targetView.layer.masksToBounds = YES;
    targetView.layer.shadowRadius = 5.0f;
    targetView.layer.shadowOffset = CGSizeMake(10, 10);
    targetView.layer.shadowColor = COLOR_EEEEEE.CGColor;
}

//设置上部圆角
- (void)setRectCornerTop:(UIView *)targetView
{
    CGFloat width = targetView.bounds.size.width;
    CGFloat height = targetView.bounds.size.height;
    if(width==0||height==0) return;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = targetView.bounds;
    maskLayer.path = maskPath.CGPath;
    targetView.layer.mask = maskLayer;
}

#pragma mark - getters -
- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (DDCBottomBar *)bottomBar
{
    if(!_bottomBar)
    {
        _bottomBar = [DDCBottomBar showDDCBottomBarWithPreferredStyle:DDCBottomBarStyleWithLine];
    }
    return _bottomBar;
}

@end
