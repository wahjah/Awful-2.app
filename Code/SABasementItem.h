//
//  SABasementItem.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//

#import <Foundation/Foundation.h>

/**
 * An SABasementItem represents a single view controller in an SABasementViewController.
 */
@interface SABasementItem : NSObject

/**
 * Initializes a basement item. This is the designated initializer.
 *
 * @param title The name of the view controller represented by this item.
 */
- (id)initWithTitle:(NSString *)title;

/**
 * The name of the view controller represented by this item.
 */
@property (copy, nonatomic) NSString *title;

@end

@interface UIViewController (SABasementItem)

/**
 * Defaults to a basement item that takes its title from this view controller.
 */
@property (strong, nonatomic) SABasementItem *basementItem;

@end
