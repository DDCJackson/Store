//
//  DDCContractListCell.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCContractDetailsModel;

@interface DDCContractListCell : UICollectionViewCell

- (void)configureWithModel:(DDCContractDetailsModel *)model;

@end
