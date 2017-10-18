//
//  DDCOrderingTableViewController.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString * selected);

@interface DDCOrderingTableViewController : UITableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style sortArray:(NSArray *)sortArray selectedBlock:(SelectedBlock)block;

@property (nonatomic, copy) SelectedBlock block;

@end
