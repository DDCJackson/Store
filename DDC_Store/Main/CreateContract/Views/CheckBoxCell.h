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

- (void)clickCheckedBtn:(BOOL)isChecked indexPath:(NSIndexPath *)indexPath;

- (void)checkBoxContentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

@end

@interface CheckBoxCell : UICollectionViewCell

@property (nonatomic,strong)NSIndexPath  *indexPath;
@property (nonatomic,assign)id<CheckBoxCellDelegate> delegate;
@property (nonatomic,assign)BOOL isChecked;

- (void)setCourseModel:(OffLineCourseModel *)courseModel delegate:(id<CheckBoxCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)height;

@end
