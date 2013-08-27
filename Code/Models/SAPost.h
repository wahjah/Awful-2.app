//
//  SAPost.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import <Foundation/Foundation.h>
#import <HTMLReader/HTMLReader.h>
@class SAThread;
@class SAUser;

/**
 * An SAPost represents a single post in a thread on the Something Awful Forums.
 */
@interface SAPost : NSObject

/**
 * The (presumably) unique identifier of the post.
 */
@property (copy, nonatomic) NSString *postID;

/**
 * The thread where the post appears.
 */
@property (weak, nonatomic) SAThread *thread;

/**
 * The post's author.
 */
@property (weak, nonatomic) SAUser *author;

/**
 * The post's contents as HTML.
 */
@property (copy, nonatomic) NSString *HTMLContents;

/**
 * The post's contents as an attributed string.
 */
@property (copy, nonatomic) NSAttributedString *stringContents;

/**
 * The date the post was made.
 */
@property (strong, nonatomic) NSDate *postDate;

/**
 * The 1-based index of the post in its thread.
 */
@property (assign, nonatomic) NSInteger indexInThread;

@end

@interface SAPost (Parsing)

+ (instancetype)postWithHTMLTableElement:(HTMLElementNode *)table;

@end
