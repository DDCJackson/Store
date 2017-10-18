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
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomBar];
        self.frame = frame;
        [self setRectCornerTop];
        if(hasShadow)
        {
            [self setBlackShadow];
        }
        
        [self setupViewConstraints];
    }
    return self;
}

- (instancetype)initWithRectCornerTopTableViewFrame:(CGRect)frame hasShadow:(BOOL)hasShadow
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        [self addSubview:self.bottomBar];
        self.frame = frame;
        [self setRectCornerTop];
        if(hasShadow)
        {
            [self setBlackShadow];
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
- (void)setBlackShadow
{
    self.layer.masksToBounds = YES;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOffset = CGSizeMake(20, 20);
    self.layer.shadowColor = COLOR_EEEEEE.CGColor;
}

//设置上部圆角
- (void)setRectCornerTop
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if(width==0||height==0) return;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
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
