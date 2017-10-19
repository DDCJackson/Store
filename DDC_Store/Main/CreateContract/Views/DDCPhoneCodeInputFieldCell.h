//
//  DDCPhoneCodeInputFieldCell.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/19/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularTextFieldWithExtraButtonView.h"

@interface DDCPhoneCodeInputFieldCell : UICollectionViewCell

@property (nonatomic, strong) CircularTextFieldWithExtraButtonView * inputFieldView;


- (void)configureWithPlaceholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate;

@end
