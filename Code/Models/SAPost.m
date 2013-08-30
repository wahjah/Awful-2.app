//
//  SAPost.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import "SAModels.h"

@implementation SAPost

+ (instancetype)postWithHTMLTableElement:(HTMLElementNode *)table
{
    SAPost *post = [self new];
    post.postID = [table[@"id"] substringFromIndex:4];
    SAUser *author = [SAUser new];
    author.username = [[table firstNodeMatchingSelector:@"dt.author"] innerHTML];
    post.author = author;
    HTMLElementNode *contentsNode = [table firstNodeMatchingSelector:@"td.postbody"];
    post.HTMLContents = contentsNode.innerHTML;
    return post;
}

@end
