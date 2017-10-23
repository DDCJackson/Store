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

@interface ContractStateInfoCell ()

@property (nonatomic, strong) UIButton *dot;
@property (nonatomic, strong) DDCButton *line_left;
@property (nonatomic, strong) DDCButton *line_right;
@property (nonatomic, strong) DDCButton *titleBtn;


@end

@implementation ContractStateInfoCell

@synthesize dot,line_left,line_right,titleBtn;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        CGFloat r = 16.0f;
        dot = [UIButton buttonWithType:UIButtonTypeCustom];
        [dot setImage:[UIImage imageNamed:@"icon_state_node_done"] forState:UIControlStateNormal];
        [dot setImage:[UIImage imageNamed:@"icon_state_node_doing"] forState:UIControlStateSelected];
        [dot setImage:[UIImage imageNamed:@"icon_state_node_todo"] forState:UIControlStateDisabled];
        [self.contentView addSubview:dot];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(5);
        }];
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = r/2.0f;
        
        CGFloat h_line = 0.5;
        line_left = [DDCButton buttonWithType:UIButtonTypeCustom];
        [line_left setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        [line_left setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateSelected];
        [line_left setBackgroundColor:[UIColor colorWithHexString:@"#D8D8D8" alpha:0.5] forState:UIControlStateDisabled];
        [self.contentView addSubview:line_left];
        [line_left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h_line);
            make.centerY.equalTo(dot.mas_centerY);
            make.right.equalTo(dot.mas_left);
            make.left.equalTo(self.contentView);
        }];
        
        line_right = [DDCButton buttonWithType:UIButtonTypeCustom];
        [line_right setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        [line_right setBackgroundColor:COLOR_MAINORANGE forState:UIControlStateSelected];
        [line_right setBackgroundColor:[UIColor colorWithHexString:@"#D8D8D8" alpha:0.5] forState:UIControlStateDisabled];
        [self.contentView addSubview:line_right];
        [line_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h_line);
            make.centerY.equalTo(dot.mas_centerY);
            make.left.equalTo(dot.mas_right);
            make.right.equalTo(self.contentView);
        }];
        
        titleBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
        titleBtn.titleLabel.numberOfLines = 0;
        [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular] forState:UIControlStateNormal];
         [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular] forState:UIControlStateSelected];
         [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightLight] forState:UIControlStateDisabled];
        [titleBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
        [titleBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateSelected];
        [titleBtn setTitleColor:COLOR_A5A4A4 forState:UIControlStateDisabled];
        [self.contentView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dot.mas_bottom).with.offset(10);
            make.centerX.equalTo(dot);
        }];
    
    }
    return self;
}

- (void)configureCellWithData:(ContractStateInfoViewModel *)data
{
    [titleBtn setTitle:data.title forState:UIControlStateNormal];

    line_right.selected = line_left.selected = titleBtn.selected = dot.selected = data.state == ContractStateDoing;
    line_right.enabled = line_left.enabled = titleBtn.enabled = dot.enabled = data.state != ContractStateTodo;
    line_left.hidden = data.position == ContractStateNodePositionLeft;
    line_right.hidden = data.position == ContractStateNodePositionRight;
    if (data.state == ContractStateDoing) {
       line_right.enabled =  line_right.selected = NO;
    }
}

+ (CGFloat)height
{
    return 60.0f;
}

+ (CGSize)sizeWithData:(ContractStateInfoViewModel *)data width:(CGFloat)width
{
    CGFloat w = [data.title widthWithFont:[UIFont systemFontOfSize:16.0f weight:data.state == ContractStateTodo?UIFontWeightLight:UIFontWeightRegular] constrainedToHeight:20.0f];
    w = MAX(w, width);
    return CGSizeMake(w, [self height]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
