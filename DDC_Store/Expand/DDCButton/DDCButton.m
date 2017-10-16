//
//  DDCButton.m
//  DayDayCook
//
//  Created by 张秀峰 on 2016/10/10.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "DDCButton.h"

@interface DDCButton ()

@property (nonatomic, retain) NSMutableDictionary<NSNumber *, UIColor *> *bgColors;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, UIColor *> *LayerBorderColors;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, UIFont *> *fonts;
@property (nonatomic, retain) UIFont *font;

@end

@implementation DDCButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    DDCButton *selfBtn = [super buttonWithType:buttonType];
    selfBtn.bgColors = [NSMutableDictionary dictionary];
    selfBtn.LayerBorderColors = [NSMutableDictionary dictionary];
    selfBtn.fonts = [NSMutableDictionary dictionary];
    return selfBtn;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.bgColors = [NSMutableDictionary dictionary];
        self.LayerBorderColors = [NSMutableDictionary dictionary];
        self.fonts = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.bgColors = [NSMutableDictionary dictionary];
        self.LayerBorderColors = [NSMutableDictionary dictionary];
        self.fonts = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (!backgroundColor) return;
    [self.bgColors setObject:backgroundColor forKey:[NSNumber numberWithUnsignedInteger:state]];
    if (state == UIControlStateNormal) {
        self.backgroundColor = backgroundColor;
    }
}

- (void)setLayerBorderColor:(UIColor *)LayerBorderColor forState:(UIControlState)state
{
    if (!LayerBorderColor) return;
    self.layer.borderWidth = 0.5f;
    [self.LayerBorderColors setObject:LayerBorderColor forKey:[NSNumber numberWithUnsignedInteger:state]];
    if (state == UIControlStateNormal) {
        self.layer.borderColor = LayerBorderColor.CGColor;
    }
}

- (void)setFont:(UIFont *)font forState:(UIControlState)state
{
    if (!font) return;
    [self.fonts setObject:font forKey:[NSNumber numberWithUnsignedInteger:state]];
    if (state == UIControlStateNormal) {
        self.titleLabel.font = font;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    NSNumber *key = [NSNumber numberWithUnsignedInteger:enabled?UIControlStateNormal:UIControlStateDisabled];
    [self configuareWithKey:key];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
//    NSNumber *key = [NSNumber numberWithUnsignedInteger:highlighted?UIControlStateHighlighted:UIControlStateNormal];
    NSNumber *key = [NSNumber numberWithUnsignedInteger:UIControlStateNormal];
    if(highlighted){
        key = [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted];
    }else if (self.selected){
        key = [NSNumber numberWithUnsignedInteger:UIControlStateSelected];
    }
    [self configuareWithKey:key];

    self.imageView.alpha = highlighted ? 0.6 :1.0;
}



- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:selected?UIControlStateSelected:UIControlStateNormal];
    [self configuareWithKey:key];
}

- (void)configuareWithKey:(NSNumber *)key
{
    if (self.bgColors && [[self.bgColors allKeys] containsObject:key]) {
        self.backgroundColor = self.bgColors[key];
    }
    
    if (self.LayerBorderColors && [[self.LayerBorderColors allKeys] containsObject:key]) {
        self.layer.borderColor = self.LayerBorderColors[key].CGColor;
    }else{
        self.layer.borderColor = self.backgroundColor.CGColor;
    }
    
    if (self.fonts && [[self.fonts allKeys] containsObject:key]) {
        self.titleLabel.font = self.fonts[key];
    }
}



- (void)setFont:(UIFont *)font
{
    self.titleLabel.font = font;
//    _font = font;
}


- (UIFont *)font
{
    return self.titleLabel.font;
}

//- (void)setBgColorState:(UIControlState)bgColorState
//{
//    
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
// 
//    [super drawRect:rect];
//}


//-  (void)setImageSieze:(CGSize)imageSieze
//{
//    _imageSieze = imageSieze;
//}



//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    
//    return [super titleRectForContentRect:contentRect];
//}
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return [super imageRectForContentRect:contentRect];
//}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect f_title = self.titleLabel.frame;
//    f_title.size.height = [self.currentTitle boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:self.titleLabel.font forKey:NSFontAttributeName] context:nil].size.height+5;
//    f_title.size.width = self.frame.size.width;
//    self.titleLabel.frame = f_title;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    CGRect f_imgae = self.imageView.frame;
//    f_imgae.size = self.imageSieze;//CGSizeMake(70, 70);
//    self.imageView.frame = f_imgae;
//    UIEdgeInsets insets_title = self.titleEdgeInsets;
//    UIEdgeInsets insets_image = self.imageEdgeInsets;
//    CGFloat h_image = f_imgae.size.height/2.0f;
//    CGFloat h_title = f_title.size.height/2.0f;
//    CGFloat l_y = (h_title + h_image + insets_image.bottom + insets_title.top);
//    self.imageView.center = CGPointMake(self.center.x, self.center.y-l_y*h_title/(h_title+h_image));
//    self.titleLabel.center = CGPointMake(self.center.x, self.center.y+l_y*h_image/(h_image+h_title));
//}

//- (void)layoutIfNeeded
//{
//    [super layoutIfNeeded];
//}




@end
