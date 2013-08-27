//
//  SAPost.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import "SAPost.h"

@implementation SAPost

+ (instancetype)postWithHTMLTableElement:(HTMLElementNode *)table
{
    SAPost *post = [self new];
    post.postID = [table[@"id"] substringFromIndex:4];
    post.HTMLContents = [table firstNodeMatchingSelector:@"td.postbody"].innerHTML;
    return post;
}

@end
