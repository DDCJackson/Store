//
//  DDCOrderingHeaderView.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCOrderingHeaderView.h"

@interface DDCOrderingHeaderView()

@property (nonatomic, strong) UILabel * titleLbl;
@property (nonatomic, strong) UIButton * orderingBtn;

@end

@implementation DDCOrderingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLbl];
    [self addSubview:self.orderingBtn];
    
    [self setConstraints];
    return self;
}

- (void)setConstraints
{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(30);
    }];
    
    [self.orderingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self).with.offset(-20);
    }];
}

- (void)configureWithTitle:(NSString *)title delegate:(id<DDCOrderingHeaderViewDelegate>)delegate
{
    self.titleLbl.text = title;
    self.delegate = delegate;
}

#pragma mark - Events
- (void)orderingBtnPressed:(UIButton *)btn
{
    btn.selected = YES;
    if (self.delegate)
    {
        __weak typeof(self) weakSelf = self;
        [self.delegate headerView:self orderingBtnPressedWithUpdateCallback:^(NSString *newOrdering) {
            weakSelf.orderingBtn.selected = NO;
            if (newOrdering && newOrdering.length)
            {
                [weakSelf.orderingBtn setTitle:newOrdering forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - Getters
- (UILabel *)titleLbl
{
    if (!_titleLbl)
    {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLbl.textColor = UIColor.blackColor;
    }
    return _titleLbl;
}

- (UIButton *)orderingBtn
{
    if (!_orderingBtn)
    {
        _orderingBtn = [[UIButton alloc] init];
        [_orderingBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _orderingBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_orderingBtn setTitle:NSLocalizedString(@"全部", @"") forState:UIControlStateNormal];
        [_orderingBtn setImage:[UIImage imageNamed:@"arrowIcon"] forState:UIControlStateNormal];
        [_orderingBtn setImage:[UIImage imageNamed:@"arrowIcon"] forState:UIControlStateSelected];
        [_orderingBtn addTarget:self action:@selector(orderingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderingBtn;
}

@end
