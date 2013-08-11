//
//  SALoginFormViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-11.
//

#import <UIKit/UIKit.h>

@interface SALoginFormViewController : UIViewController

/**
 * A block that's called after successfully logging in using the app-wide SAForumsClient.
 */
@property (copy, nonatomic) void (^completionHandler)(void);

@end
