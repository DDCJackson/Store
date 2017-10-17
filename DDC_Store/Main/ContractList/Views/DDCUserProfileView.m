//
//  DDCUserProfileView.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCUserProfileView.h"

static CGFloat kImgDiameter = 80.;
static CGFloat kImgBorderWidth = 3;
static CGFloat kSpacing = 25.;

@interface DDCUserProfileView()
{
    BOOL _setConstraints;
}

@property (nonatomic, strong) UIView * profileImgViewHolder;
@property (nonatomic, strong) UIImageView * profileImgView;
@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UIFont * nameFont;

@end

@implementation DDCUserProfileView

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    [self addSubview:self.profileImgViewHolder];
    [self addSubview:self.nameLbl];
    return self;
}

- (void)updateConstraints
{
    if (_setConstraints == NO)
    {
        [self.profileImgViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(kImgBorderWidth+kImgDiameter);
        }];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileImgViewHolder.mas_right).with.offset(25);
            make.centerY.equalTo(self.profileImgView);
        }];
        _setConstraints = YES;
    }
    [super updateConstraints];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat w, h;
    CGFloat imgHi = self.profileImgView.bounds.size.height;
    h = size.height > imgHi ? imgHi : size.height;
    
    CGFloat availableWid = size.width - kImgDiameter - kSpacing;
    CGFloat lblWid = [self.name boundingRectWithSize:CGSizeMake(availableWid, h) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nameFont} context:nil].size.width;
    
    w = lblWid + availableWid;
    return CGSizeMake(w, h);
}

#pragma mark - Setters
- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLbl.text = name;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr
{
    _imgUrlStr = imgUrlStr;
    [self.profileImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"Personal_head"]];
}

#pragma mark - Getters
- (UIView *)profileImgViewHolder
{
    if (!_profileImgView)
    {
        _profileImgViewHolder = [[UIView alloc] init];
        _profileImgViewHolder.layer.cornerRadius = (kImgDiameter+kImgBorderWidth)/2;
        _profileImgViewHolder.layer.masksToBounds = YES;
        _profileImgViewHolder.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.05].CGColor;
        _profileImgViewHolder.layer.borderWidth = kImgBorderWidth;
        [_profileImgViewHolder addSubview:self.profileImgView];
        [self.profileImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_profileImgViewHolder);
            make.width.height.mas_equalTo(kImgDiameter);
        }];
    }
    return _profileImgViewHolder;
}

- (UIImageView *)profileImgView
{
    if (!_profileImgView)
    {
        _profileImgView = [[UIImageView alloc] init];
        _profileImgView.layer.cornerRadius = kImgDiameter/2;
        _profileImgView.layer.masksToBounds = YES;
        _profileImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _profileImgView;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = self.nameFont;
        _nameLbl.textColor = UIColor.whiteColor;
    }
    return _nameLbl;
}

- (UIFont *)nameFont
{
    if (!_nameFont)
    {
        _nameFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _nameFont;
}

- (CGFloat)height
{
    return (kImgDiameter+kImgBorderWidth);
}

@end
