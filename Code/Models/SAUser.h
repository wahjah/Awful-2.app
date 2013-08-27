//
//  SAUser.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import <Foundation/Foundation.h>

/**
 * An SAUser represents a user of the Something Awful Forums (a "goon").
 */
@interface SAUser : NSObject

/**
 * The (presumably) unique identifier of the user.
 */
@property (copy, nonatomic) NSString *userID;

/**
 * The user's (presumably unique) name.
 */
@property (copy, nonatomic) NSString *username;

/**
 * The day the user registered. (Ignore date components smaller than one day.)
 */
@property (strong, nonatomic) NSDate *regdate;

/**
 * The URL for the user's avatar image, or nil if the user has no avatar.
 *
 * May also be nil while the logged-in user has toggled the Forums setting "Show user's avatar in their posts?" to "no".
 */
@property (strong, nonatomic) NSURL *avatarURL;

@end
