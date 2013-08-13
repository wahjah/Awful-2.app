//
//  SASidebarViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//

#import <UIKit/UIKit.h>

/**
 * SABasementViewController uses an instance of SASidebarViewController to list the available view controllers.
 */
@interface SASidebarViewController : UITableViewController

/**
 * Initializes a new basement view controller.
 *
 * @param basementItems An array of SABasementItem instances.
 */
- (id)initWithBasementItems:(NSArray *)basementItems;

/**
 * The instances of SABasementItem shown by this sidebar view controller.
 */
@property (readonly, copy, nonatomic) NSArray *basementItems;

@end
