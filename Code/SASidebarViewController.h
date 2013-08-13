//
//  SASidebarViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//

#import <UIKit/UIKit.h>
#import "SABasementItem.h"
@protocol SASidebarViewControllerDelegate;

/**
 * An SASidebarViewController instance is used by SABasementViewController to list the available view controllers.
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

/**
 * The currently-selected item in the list. When setting this property, no messages are sent to the delegate.
 */
@property (strong, nonatomic) SABasementItem *selectedItem;

/**
 * The delegate.
 */
@property (weak, nonatomic) id <SASidebarViewControllerDelegate> delegate;

@end

/**
 * The delegate of an SASidebarViewController is informed when the user changes the selected item.
 */
@protocol SASidebarViewControllerDelegate <NSObject>

/**
 * Informs the delegate that the user has changed the selected item.
 *
 * @param sidebar The SASidebarViewController whose selected item changed.
 * @param item The newly-selected item. Obtain its index by querying the sidebar's `basementItems` array.
 */
- (void)sidebar:(SASidebarViewController *)sidebar didSelectItem:(SABasementItem *)item;

@end
