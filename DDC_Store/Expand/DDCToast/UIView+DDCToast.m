//
//  UIView+DDCToast.m
//  DayDayCook
//
//  Created by DAN on 16/9/3.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "UIView+DDCToast.h"
#import "KeyboardStateListener.h"

#define kBgViewWidth           X_SCALER(193., 240.)
#define kImgAndTitleSpace      Y_SCALER( 10., 15.)
#define kTitleLeftPadding      X_SCALER( 14., 15.)
#define kTitleLineSpace        Y_SCALER (7., 7.)
#define kTopOrBootomPadding    Y_SCALER(20., 25.)
#define kTitleHeight           (IS_IPHONE_DEVICE ? 18.: 20.)
#define kTitleFont             FONT(FONT_LIGHT_14,FONT_LIGHT_16)

@implementation DDCToastModel

- (instancetype)initWithMessage:(NSString *)message imageStr:(NSString *)imageStr position:(ImagePosition)position
{
    if (!(self = [super init])) return nil;
    
    self.message = message;
    self.imageStr = imageStr;
    self.position = position;
    return self;
}

@end


@implementation UIView (DDCToast)

- (void)makeDDCToast:(NSString *)message image:(UIImage *)image imagePosition:(ImagePosition)position finishedBlock:(void (^)())finishedBlock
{
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds =YES;
    bgView.layer.cornerRadius = 8.0;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.70];
    bgView.alpha = 0.0;
    [self addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font =kTitleFont;
    [bgView addSubview:titleLabel];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView setImage:image];
    [bgView addSubview:imgView];
    
    NSMutableAttributedString *msgAttStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kTitleLineSpace];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];//居中
    [msgAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    [msgAttStr addAttribute:NSFontAttributeName value:kTitleFont range:NSMakeRange(0, [message length])];
    
    CGFloat titleH = [msgAttStr boundingRectWithSize:CGSizeMake(kBgViewWidth-2*kTitleLeftPadding,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    if(titleH<30)
    {
        titleH = kTitleHeight;
    }
    else
    {
        titleH = kTitleHeight*2 + kTitleLineSpace;
    }
    
    titleLabel.attributedText = msgAttStr;

    switch (position) {
        case ImageTop:
        case ImageBottom:
        {
            CGFloat bgH = kTopOrBootomPadding*2 + image.size.height +kImgAndTitleSpace + titleH;
//            bgView.frame =CGRectMake(self.center.x-(kBgViewWidth/2),self.center.y-(bgH/2) , kBgViewWidth, bgH);
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                if ([KeyboardStateListener sharedInstance].visible && IS_IPHONE5)
                {
                    make.centerY.equalTo(self).with.offset(-50);
                }
                else
                {
                    make.centerY.equalTo(self);
                }
                make.width.mas_equalTo(kBgViewWidth);
                make.height.mas_equalTo(bgH);
            }];
            
            if (position == ImageTop) {
                
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(kTopOrBootomPadding);
                    make.centerX.equalTo(bgView);
                    make.width.mas_equalTo(image.size.width);
                    make.height.mas_equalTo(image.size.height);
                }];
                
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(bgView).with.offset(-kTopOrBootomPadding);
                    make.left.equalTo(bgView).with.offset(kTitleLeftPadding);
                    make.right.equalTo(bgView).with.offset(-kTitleLeftPadding);
                    make.height.mas_equalTo(titleH);

                }];
//                imgView.frame = CGRectMake((bgView.bounds.size.width-image.size.width)/2, kTopOrBootomPadding, image.size.width, image.size.height);
//                titleLabel.frame =CGRectMake(0, imgView.frame.size.height+imgView.frame.origin.y+kTitleTopPadding, w, kTitleHeight);
            }else{
                
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(kTopOrBootomPadding);
                    make.left.equalTo(bgView).with.offset(kTitleLeftPadding);
                    make.right.equalTo(bgView).with.offset(-kTitleLeftPadding);
                    make.height.mas_equalTo(titleH);
                    
                }];
                
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(bgView).with.offset(-kTopOrBootomPadding);
                    make.centerX.equalTo(bgView);
                    make.width.mas_equalTo(image.size.width);
                    make.height.mas_equalTo(image.size.height);
                }];

            }
        }
            break;
            
        default:
        {
            if (ImageLeft) {
                
            }else{
                
            }
        }
            break;
    }
    /*
     if(position == ImageTop)
     {
     CGFloat titleH = v_title_size.height;
     CGFloat bgH = kImgTopPadding + image.size.height +kTitleTopPadding +titleH + kTitleBottomPadding;
     bgView.frame =CGRectMake(self.center.x-(kBgViewWidth/2),self.center.y-(bgH/2) , kBgViewWidth, bgH);
     imgView.frame = CGRectMake((bgView.bounds.size.width-image.size.width)/2, 20, image.size.width, image.size.height);
     titleLabel.frame =CGRectMake(0, imgView.frame.size.height+imgView.frame.origin.y+kTitleTopPadding, bgView.frame.size.width, titleH);
     }
     else if (position == ImageLeft)
     {
     
     }
     else if (position == ImageBottom)
     {
     CGFloat titleH = v_title_size.height;
     CGFloat bgH = kImgTopPadding+image.size.height+kTitleTopPadding+titleH+kTitleBottomPadding;
     bgView.frame =CGRectMake(self.center.x-(kBgViewWidth/2),self.center.y-(bgH/2) , kBgViewWidth, bgH);
     titleLabel.frame =CGRectMake(0, kTitleTopPadding, kBgViewWidth, titleH);
     imgView.frame = CGRectMake((kBgViewWidth-image.size.width)/2, kImgTopPadding+titleH+titleLabel.frame.origin.y, image.size.width, image.size.height);
     
     }
     else if (position == ImageRight)
     {
     
     
     }
     */
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         bgView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              bgView.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [bgView removeFromSuperview];
                                              if (finishedBlock) {
                                                  finishedBlock();
                                              }
                                          }];
                     }];
    

}


- (void)makeDDCToast:(NSString *)message image:(UIImage *)image imagePosition:(ImagePosition)position
{
    [self makeDDCToast:message image:image imagePosition:position finishedBlock:nil];
}

- (void)makeDDCToast:(DDCToastModel *)model
{
    [self makeDDCToast: model.message image: [UIImage imageNamed:model.imageStr] imagePosition: model.position];
}

- (void)makeDDCToast:(NSString *)message image:(UIImage *)image
{
    [self makeDDCToast:message image:image imagePosition:ImageTop];
}


@end
