//
//  SAForum.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import <Foundation/Foundation.h>

/**
 * An SAForum represents a forum or subforum on the Something Awful Forums.
 */
@interface SAForum : NSObject

/**
 * The (presumably) unique identifier of the forum.
 */
@property (copy, nonatomic) NSString *forumID;

/**
 * The name of the forum.
 */
@property (copy, nonatomic) NSString *name;

/**
 * The next forum up in the hierarchy, or nil if this forum is at the top.
 */
@property (weak, nonatomic) SAForum *parentForum;

@end
