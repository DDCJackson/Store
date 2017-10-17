//
//  DDCOrderingTableViewController.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCOrderingTableViewController.h"

@interface DDCOrderingTableViewController ()

@property (nonatomic, copy) NSArray * optionsArray;

@end

@implementation DDCOrderingTableViewController

#pragma mark - Table view data source
- (instancetype)initWithStyle:(UITableViewStyle)style selectedBlock:(SelectedBlock)block
{
    if (!(self = [super initWithStyle:style])) return nil;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.block = block;
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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

#pragma mark - Getters
- (NSArray *)optionsArray
{
    if (!_optionsArray)
    {
        _optionsArray = @[NSLocalizedString(@"全部", @""), NSLocalizedString(@"生效中", @""), NSLocalizedString(@"未完成", @""), NSLocalizedString(@"已结束", @"")];
    }
    return _optionsArray;
}

@end
