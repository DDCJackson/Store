//
//  DDCContractListCell.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCContractModel;

@interface DDCContractListCell : UICollectionViewCell

- (void)configureWithModel:(DDCContractModel *)model;

@end
