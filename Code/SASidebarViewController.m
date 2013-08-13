//
//  SASidebarViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//

#import "SASidebarViewController.h"
#import "SABasementItem.h"
#import "UIFont+SAFontVariant.h"

@interface SASidebarTableViewCell : UITableViewCell

@end

@implementation SASidebarViewController

- (id)initWithBasementItems:(NSArray *)basementItems
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _basementItems = [basementItems copy];
        _selectedItem = _basementItems[0];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.tableView registerClass:[SASidebarTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectRowForSelectedItem];
    
    // Normally on first appear this table's rows are inserted with an animation. This disables that animation.
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)setSelectedItem:(SABasementItem *)selectedItem
{
    if (_selectedItem == selectedItem) return;
    _selectedItem = selectedItem;
    if ([self isViewLoaded]) {
        [self selectRowForSelectedItem];
    }
}

- (void)selectRowForSelectedItem
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.basementItems indexOfObject:self.selectedItem]
                                                inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SABasementItem *item = self.basementItems[indexPath.row];
    [self.delegate sidebar:self didSelectItem:item];
}

@end

@implementation SASidebarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    UIFont *font = self.textLabel.font;
    self.textLabel.font = selected ? [font boldVariant] : [font normalVariant];
}

@end
