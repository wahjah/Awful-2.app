//
//  SAForumsClient.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import <Foundation/Foundation.h>

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
