//
//  PayWayCell.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "PayWayCell.h"
#import "PayWayModel.h"
#import "PayInfoView.h"

@interface PayWayCell ()
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) PayInfoView *payInfoView;


@property (nonatomic, strong) PayWayModel *data;

@end

@implementation PayWayCell

@synthesize icon, titleBtn, checkBtn, payInfoView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        
        checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setImage:[UIImage imageNamed:@"icon_selection_selected"] forState:UIControlStateSelected];
        [checkBtn setImage:[UIImage imageNamed:@"icon_selection_desselected"] forState:UIControlStateNormal];
        checkBtn.userInteractionEnabled = NO;
        
        [self.contentView addSubview:checkBtn];
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(icon);
            make.width.height.mas_equalTo(30);
        }];
    

        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(checkBtn.mas_right).with.offset(5);
            make.width.height.mas_equalTo(50);
        }];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 10.0f;
        
        
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.userInteractionEnabled = NO;
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"#474747"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        [self.contentView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.offset(10);
            make.centerY.equalTo(checkBtn);
        }];
        
        payInfoView = [[PayInfoView alloc] init];
        payInfoView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:payInfoView];
        [payInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).with.offset(50);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-30);
        }];
        
        payInfoView.hidden = YES;
        
        self.clipsToBounds = YES;
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    checkBtn.selected = selected;
    titleBtn.selected = selected;
    if (self.data.isEnable) {
        payInfoView.hidden = !selected;
    }
}


- (void)showCellWithData:(PayWayModel *)data
{
    if (!data) return;
    self.data = data;
    icon.image = [UIImage imageNamed:data.icon];
//    [icon sd_setImageWithURL:[NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"default"] ];
    [titleBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:data.name] forState:UIControlStateNormal];
    NSString *des = self.data.Description;
    if (des && des.length > 0) {
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",self.data.name, des]];
        [title addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f weight:UIFontWeightLight], NSForegroundColorAttributeName:COLOR_MAINORANGE} range:NSMakeRange(title.length-des.length, des.length)];
        [titleBtn setAttributedTitle:title forState:UIControlStateSelected];
    }
}

+ (CGFloat)heightWithData:(PayWayModel *)data
{
    CGFloat h = 75.0f;
    if (data.isSelected && data.isEnable) {
        h += [PayInfoView height];
    }
    return h;
}

@end
