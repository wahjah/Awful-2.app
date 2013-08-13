//
//  SASidebarViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import "SASidebarViewController.h"
#import "SABasementItem.h"

@interface SASidebarTableViewCell : UITableViewCell

@end

@implementation SASidebarViewController

- (id)initWithBasementItems:(NSArray *)basementItems
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _basementItems = [basementItems copy];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.tableView registerClass:[SASidebarTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.basementItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SASidebarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    SABasementItem *item = self.basementItems[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

@end

@implementation SASidebarTableViewCell

@end
