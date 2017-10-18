//
//  DDCOrderingTableViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCOrderingTableViewController.h"

static CGFloat const kRowHeight = 50;
static CGFloat const kPreferredWidth = 100;

@interface DDCOrderingTableViewController () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, copy) NSArray * optionsArray;

@end

@implementation DDCOrderingTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style sortArray:(NSArray *)sortArray selectedBlock:(SelectedBlock)block
{
    if (!(self = [super initWithStyle:style])) return nil;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.popoverPresentationController.delegate = self;
    self.optionsArray = sortArray;
    self.block = block;
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#474747"];
    cell.textLabel.text = self.optionsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block)
    {
        self.block(self.optionsArray[indexPath.row]);
    }
}

#pragma mark - PopoverDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    if (self.block)
    {
        self.block(nil);
    }
}

#pragma mark - Getters

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationPopover;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(kPreferredWidth, self.optionsArray.count * kRowHeight);
}

@end
