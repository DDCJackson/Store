//
//  Fonts.h
//  DayDayCook
//
//  Created by DAN on 2016/11/17.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#ifndef Fonts_h
#define Fonts_h

#define FONT_LIGHT_40      [UIFont systemFontOfSize:40.0 weight:UIFontWeightLight]
#define FONT_LIGHT_36      [UIFont systemFontOfSize:36.0 weight:UIFontWeightLight]
#define FONT_LIGHT_32      [UIFont systemFontOfSize:32.0 weight:UIFontWeightLight]
#define FONT_LIGHT_20     [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight]
#define FONT_LIGHT_18     [UIFont systemFontOfSize:18.0 weight:UIFontWeightLight]
#define FONT_LIGHT_16     [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight]
#define FONT_LIGHT_14     [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]
#define FONT_LIGHT_12     [UIFont systemFontOfSize:12.0 weight:UIFontWeightLight]
#define FONT_LIGHT_10     [UIFont systemFontOfSize:10.0 weight:UIFontWeightLight]
#define FONT_LIGHT_9      [UIFont systemFontOfSize:9.0 weight:UIFontWeightLight]
#define FONT_LIGHT_8      [UIFont systemFontOfSize:8.0 weight:UIFontWeightLight]

#define FONT_MEDIUM_26    [UIFont systemFontOfSize:26.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_22    [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_20    [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_18    [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_16    [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_14    [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_12    [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_11    [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_10    [UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_9     [UIFont systemFontOfSize:9.0 weight:UIFontWeightMedium]
#define FONT_MEDIUM_8     [UIFont systemFontOfSize:8.0 weight:UIFontWeightMedium]

#define FONT_REGULAR_20   [UIFont systemFontOfSize:20.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_18   [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_16   [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_14   [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_12   [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_10   [UIFont systemFontOfSize:10.0 weight:UIFontWeightRegular]
#define FONT_REGULAR_8    [UIFont systemFontOfSize:8.0 weight:UIFontWeightRegular]

#define FONT_SEMIBOLD_20     [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_18     [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_16     [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_14     [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_12     [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_10     [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold]
#define FONT_SEMIBOLD_8      [UIFont systemFontOfSize:8.0 weight:UIFontWeightSemibold]

#define FONT_ASHBY_18     [UIFont fontWithName:@"Ashby Black" size:18.0f]

/*
 *设置iPhone和iPad下的字体尺寸和Font_weight属性
 *IPHONE  IPHONE设备下的字体
 *IPAD    IPAD设备下的字体
 *
 *例如：FONT(FONT_LIGHT_16,FONT_LIGHT_18) 表示iphone下字体是16，Light；Ipad下字体是18，Light
 *
 */
#define FONT(IPHONE,IPAD)    (IS_IPHONE_DEVICE?IPHONE:IPAD)

#endif /* Fonts_h */
