//
//  SAThread.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import <Foundation/Foundation.h>
@class SAForum;
@class SAUser;

/**
 * An SAThread represents a thread on the Something Awful Forums.
 */
@interface SAThread : NSObject

/**
 * The (presumably) unique identifier of the thread.
 */
@property (copy, nonatomic) NSString *threadID;

/**
 * The name of the thread.
 */
@property (copy, nonatomic) NSString *name;

/**
 * The forum in which the thread was posted.
 */
@property (weak, nonatomic) SAForum *forum;

/**
 * The user who posted the thread.
 */
@property (strong, nonatomic) SAUser *originalPoster;

/**
 * The user who most recently posted in the thread.
 */
@property (strong, nonatomic) SAUser *killedByPoster;

/**
 * The number of unread posts in the thread.
 */
@property (assign, nonatomic) NSInteger unreadPostsCount;

/**
 * YES if the thread is in the user's bookmarked threads, or NO otherwise.
 */
@property (assign, nonatomic) BOOL bookmarked;

@end

@interface SAThread (Fetching)

/**
 * Fetch all posts in the thread from a given page.
 *
 * @param page The page to fetch.
 * @param completionHandler A block to call after fetching posts. The block has no return value and takes two parameters: nil on success, or an NSError instance describing the failure; and an array of SAPost instances on success, or nil on failure.
 */
- (void)postsOnPage:(NSInteger)page
  completionHandler:(void (^)(NSError *error, NSArray *posts))completionHandler;

@end
