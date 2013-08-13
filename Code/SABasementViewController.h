//
//  SABasementViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-12.
//

#import <UIKit/UIKit.h>

/**
 * A container view controller that keeps a sidebar below a main view.
 */
@interface SABasementViewController : UIViewController

/**
 * Initializes and returns a new basement view controller.
 *
 * This method is the designated initializer.
 *
 * @param basementViewController The basement view controller.
 * @param mainViewController The main view controller.
 */
- (id)initWithBasementViewController:(UIViewController *)basementViewController
                  mainViewController:(UIViewController *)mainViewController;

/**
 * The basement view controller.
 */
@property (readonly, strong, nonatomic) UIViewController *basementViewController;

/**
 * The main view controller.
 */
@property (readonly, strong, nonatomic) UIViewController *mainViewController;

/**
 * Whether the basement is currently visible. Defaults to NO.
 *
 * Assigning values to this property is equivalent to sending `-setBasementVisible:animated:` and passing NO for the `animated` parameter.
 */
@property (nonatomic) BOOL basementVisible;

/**
 * Show or hide the basement view controller.
 *
 * @param basementVisible YES if the basement should be shown, or NO if it should be hidden.
 * @param animated YES if the transition between show and hidden should be animated, or NO if the transition should be immediate.
 */
- (void)setBasementVisible:(BOOL)basementVisible animated:(BOOL)animated;

@end
