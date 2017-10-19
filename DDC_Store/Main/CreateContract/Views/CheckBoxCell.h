//
//  CheckBoxCell.h
//  DDC_Store
//
//  Created by DAN on 2017/10/17.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OffLineCourseModel;

@protocol CheckBoxCellDelegate<NSObject>

-(void)clickCheckedBtn:(BOOL)isChecked textFieldTag:(NSInteger)textFieldTag;

@end

@interface CheckBoxCell : UICollectionViewCell

@property (nonatomic,assign)id<CheckBoxCellDelegate> delegate;
@property (nonatomic,assign)BOOL isChecked;

- (void)setCourseModel:(OffLineCourseModel *)courseModel textFieldTag:(NSInteger)textFieldTag delegate:(id<CheckBoxCellDelegate>)delegate;

+ (CGFloat)height;

@end
