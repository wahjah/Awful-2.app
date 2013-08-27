//
//  SAForumsClient.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import <Foundation/Foundation.h>
#import <HTMLReader/HTMLReader.h>

/**
 * SAForumsClient instances communicate with the Something Awful Forums over HTTP.
 *
 * This includes fetching content, submitting forms, and authentication.
 */
@interface SAForumsClient : NSObject

/**
 * Returns the app-wide instance of SAForumsClient.
 */
+ (instancetype)client;

/**
 * The ID of the logged-in user, or nil if no user is logged in.
 */
@property (readonly, copy, nonatomic) NSString *loggedInUserID;

/**
 * Logs in to the Something Awful Forums.
 *
 * @param username The user's name.
 * @param password The user's password.
 * @param completionHandler A block to call after attempting to log in. This block has no return value and takes one parameter: nil on success, or an NSError instance describing the failure.
 *
 * @return The started `NSURLSessionDataTask` for logging in.
 */
- (NSURLSessionDataTask *)logInWithUsername:(NSString *)username
                                   password:(NSString *)password
                          completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Fetches posts.
 *
 * @param threadID The ID of the thread with the posts.
 * @param page The 1-indexed page of posts to fetch.
 * @param completionHandler A block to call after fetching posts. The block has no return value and takes two parameters: nil on success, or an NSError instance describing the failure; and an HTMLDocument instance for further parsing on success, or nil on failure.
 *
 * @return The started `NSURLSessionDataTask` for fetching posts.
 */
- (NSURLSessionDataTask *)fetchPostsFromThreadWithID:(NSString *)threadID
                                                page:(NSInteger)page
                                   completionHandler:(void (^)(NSError *error, HTMLDocument *document))completionHandler;

@end

/**
 * The domain of all NSError instances passed into completion handlers by an SAForumsClient.
 */
extern NSString * const SAForumsClientErrorDomain;

/**
 * Possible error codes for NSError instances in the SAForumsClientErrorDomain.
 */
typedef NS_ENUM(NSInteger, SAForumsClientErrorCode)
{
    SAForumsClientErrorUnknown = -1,
    SAForumsClientErrorInvalidUsernameOrPassword = -100,
};
