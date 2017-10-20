//
//  DDCTitleTextFieldCell.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/20/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractLabel.h"
#import "CircularTextFieldView.h"

@interface DDCTitleTextFieldCell : UICollectionViewCell

@property (nonatomic, strong) DDCContractLabel * titleLabel;
@property (nonatomic, strong) CircularTextFieldView * textFieldView;

@end
