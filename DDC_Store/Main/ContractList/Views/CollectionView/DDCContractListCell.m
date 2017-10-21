//
//  DDCContractListCell.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractListCell.h"
#import "DDCContractDetailsModel.h"

@interface DDCStatusViewModel: NSObject

+ (instancetype) initWithColor:(UIColor *)color title:(NSString *)title imgName:(NSString *)imgName;

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imgName;

@end

@implementation DDCStatusViewModel

+ (instancetype) initWithColor:(UIColor *)color title:(NSString *)title imgName:(NSString*)imgName
{
    DDCStatusViewModel * m = [[DDCStatusViewModel alloc] init];
    m.color = color;
    m.title = title;
    m.imgName = imgName;
    return m;
}

@end

static CGFloat const kImgDiameter = 40.f;

@interface DDCContractListCell()

@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UILabel * phoneLbl;
@property (nonatomic, strong) UILabel * dateLbl;
@property (nonatomic, strong) UILabel * statusLbl;
@property (nonatomic, strong) UIImageView * statusImgView;

@property (nonatomic, strong) NSDictionary <NSString*,DDCStatusViewModel*> * statusPairings;

@end

@implementation DDCContractListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self.contentView addSubview:self.statusImgView];
    [self.contentView addSubview:self.nameLbl];
    [self.contentView addSubview:self.phoneLbl];
    [self.contentView addSubview:self.dateLbl];
    [self.contentView addSubview:self.statusLbl];
    
    [self setConstraints];
    return self;
}

- (void)setConstraints
{
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(kImgDiameter);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImgView.mas_right).with.offset(15);
        make.top.equalTo(self.statusImgView);
    }];
    
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl);
        make.bottom.equalTo(self.statusImgView);
    }];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).with.offset(5);
        make.centerY.equalTo(self.nameLbl);
    }];
    
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configureWithModel:(DDCContractDetailsModel *)model
{
    self.nameLbl.text = model.user.nickName;
    self.phoneLbl.text = model.user.userName;
    self.dateLbl.text = model.infoModel.createDate;
    
    DDCStatusViewModel * status = self.statusPairings[@(model.showStatus).stringValue];
    self.statusLbl.text = status.title;
    self.statusLbl.textColor = status.color;
    self.statusImgView.image = [UIImage imageNamed:status.imgName];
}

#pragma mark - Getters
- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _nameLbl.textColor = [UIColor colorWithHexString:@"#474747"];
    }
    return _nameLbl;
}

- (UILabel *)phoneLbl
{
    if (!_phoneLbl)
    {
        _phoneLbl = [[UILabel alloc] init];
        _phoneLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _phoneLbl.textColor = [UIColor colorWithHexString:@"#474747"];
    }
    return _phoneLbl;
}

- (UILabel *)dateLbl
{
    if (!_dateLbl)
    {
        _dateLbl = [[UILabel alloc] init];
        _dateLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _dateLbl.textColor = [UIColor colorWithHexString:@"#A5A4A4"];
    }
    return _dateLbl;
}

- (UIImageView *)statusImgView
{
    if (!_statusImgView)
    {
        _statusImgView = [[UIImageView alloc] init];
        _statusImgView.layer.cornerRadius = kImgDiameter/2;
        _statusImgView.layer.masksToBounds = YES;
        _statusImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _statusImgView;
}

- (UILabel *)statusLbl
{
    if (!_statusLbl)
    {
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _statusLbl.textColor = [UIColor colorWithHexString:@"#474747"];
    }
    return _statusLbl;
}

// 根据Enum排序
- (NSDictionary<NSString *,DDCStatusViewModel *> *)statusPairings
{
    if (!_statusPairings)
    {
        _statusPairings = @{@(DDCContractStatusIneffective).stringValue:
                                [DDCStatusViewModel initWithColor:[UIColor colorWithHexString:@"#FF9C27"] title:DDCContractDetailsModel.displayStatusArray[DDCContractStatusIneffective] imgName:@"Personal_head"],
                            @(DDCContractStatusInComplete).stringValue:
                                  [DDCStatusViewModel initWithColor:[UIColor colorWithHexString:@"#FF5D31"] title:DDCContractDetailsModel.displayStatusArray[DDCContractStatusInComplete] imgName:@"Personal_head"],
                            @(DDCContractStatusEffective).stringValue:
                                  [DDCStatusViewModel initWithColor:[UIColor colorWithHexString:@"#3AC09F"] title:DDCContractDetailsModel.displayStatusArray[DDCContractStatusEffective] imgName:@"Personal_head"],
                            @(DDCContractStatusCompleted).stringValue:
                                  [DDCStatusViewModel initWithColor:[UIColor colorWithHexString:@"#474747"] title:DDCContractDetailsModel.displayStatusArray[DDCContractStatusCompleted] imgName:@"Personal_head"],
                            @(DDCContractStatusRevoked).stringValue:
                                [DDCStatusViewModel initWithColor:[UIColor colorWithHexString:@"#C4C4C4"] title:DDCContractDetailsModel.displayStatusArray[DDCContractStatusRevoked] imgName:@"Personal_head"]
                            };
    }
    return _statusPairings;
}

@end
