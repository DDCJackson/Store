//
//  PostStateInfoCell.m
//  DayDayCook
//
//  Created by 张秀峰 on 2016/11/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "ContractStateInfoCell.h"
#import "ContractStateInfoViewModel.h"
#import "DDCButton.h"

#define TRACE_TITLE_FONT_L [UIFont systemFontOfSize:14 weight:UIFontWeightLight]
#define TRACE_TITLE_FONT_M [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]

@interface ContractStateInfoCell ()

@property (nonatomic, retain) DDCButton *dot;
@property (nonatomic, retain) UIView *line_top;
@property (nonatomic, retain) UIView *line_bottom;
@property (nonatomic, retain) DDCButton *titleBtn;
@property (nonatomic, retain) UILabel *timeLbl;

@end

@implementation ContractStateInfoCell

@synthesize dot,line_top,line_bottom,titleBtn,timeLbl;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        CGFloat w = DEVICE_WIDTH;
//        CGFloat left_padding = IS_IPHONE_DEVICE? 40 : -0.135*w;
//        CGFloat right_padding = IS_IPHONE_DEVICE? 0 : -0.3*w;
//        self.separatorInset = UIEdgeInsetsMake(0, left_padding, 0, right_padding);
        CGFloat r = 10.0f;
        dot = [DDCButton buttonWithType:UIButtonTypeCustom];
        [dot setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateSelected];
        [dot setBackgroundColor:[UIColor colorWithHexString:@"#E1E1E1"] forState:UIControlStateNormal];
        [self.contentView addSubview:dot];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(14);
            make.width.height.mas_equalTo(r);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = r/2.0f;
        
        CGFloat w_line = 0.5;
        line_top = [[UIView alloc] init];
        line_top.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:line_top];
        [line_top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.mas_equalTo(w_line);
            make.centerX.equalTo(dot.mas_centerX);
            make.bottom.equalTo(dot.mas_top);
        }];
        
        line_bottom = [[UIView alloc] init];
        line_bottom.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:line_bottom];
        [line_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dot.mas_bottom);
            make.width.mas_equalTo(w_line);
            make.centerX.equalTo(dot.mas_centerX);
            make.bottom.equalTo(self.contentView);
        }];
        
        titleBtn = [[DDCButton alloc] init];
        titleBtn.titleLabel.numberOfLines = 0;
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [titleBtn setFont:TRACE_TITLE_FONT_L forState:UIControlStateNormal];
        [titleBtn setFont:TRACE_TITLE_FONT_M forState:UIControlStateSelected];
        [titleBtn setTitleColor:COLOR_FONTGRAY forState:UIControlStateNormal];
        [titleBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateSelected];
        [self.contentView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dot.mas_right).with.offset(14);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.top.equalTo(self.contentView.mas_top).with.offset(20);
        }];
        
        timeLbl = [[UILabel alloc] init];
        timeLbl.textColor = COLOR_FONTGRAY;
        timeLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        [self.contentView addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(titleBtn);
            make.top.equalTo(titleBtn.mas_bottom).with.offset(10);
        }];
        
    }
    return self;
}

- (void)showCellWithData:(ContractStateInfoViewModel *)data width:(CGFloat)width
{
    [titleBtn setTitle:data.title forState:UIControlStateNormal];
    titleBtn.selected = data.isLast;
//    if (data.isLast) {
//        titleLbl.textColor = COLOR_MAINORANGE;
//        titleLbl.font = TRACE_TITLE_FONT_M;
//    }
    if (data.title && data.title.isValidStringValue) {
        [titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([data.title heightWithFont:titleBtn.titleLabel.font constrainedToWidth:width]+5);
        }];
    }
    timeLbl.text = data.title;
    dot.selected = data.isLast;
    line_top.hidden = data.isLast;
    line_bottom.hidden = data.isFirst;
}

+ (CGFloat)heightWithData:(ContractStateInfoViewModel *)data width:(CGFloat)width
{
    CGFloat h = 60;
    if (!data || !data.title || !data.title.isValidStringValue) return h;
    return h + [data.title heightWithFont:data.isLast?TRACE_TITLE_FONT_M:TRACE_TITLE_FONT_L constrainedToWidth:width]+5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
