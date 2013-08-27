//
//  SAThread.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import "SAModels.h"
#import "SAForumsClient.h"

@implementation SAThread

- (void)postsOnPage:(NSInteger)page
  completionHandler:(void (^)(NSError *error, NSArray *posts))completionHandler
{
    [[SAForumsClient client] fetchPostsFromThreadWithID:self.threadID
                                                   page:page
                                      completionHandler:^(NSError *error, HTMLDocument *document)
    {
        if (error) {
            if (completionHandler) {
                completionHandler(error, nil);
            }
            return;
        }
        HTMLElementNode *namedLinkToThread = [document firstNodeMatchingSelector:@".breadcrumbs a:last-of-type"];
        self.name = [(HTMLTextNode *)namedLinkToThread.childNodes[0] data];
        
        // TODO Parse forum/subforum/etc.
        // TODO Parse bookmarked. (Check for button-unbookmark.png or button-bookmark.png image. Or maybe img.thread_bookmark.bookmark versus img.thread_bookmark.unbookmark)
        // TODO pull out each post and pass them off for parsing.
        NSMutableArray *posts = [NSMutableArray new];
        for (HTMLElementNode *table in [document nodesMatchingSelector:@"table.post"]) {
            [posts addObject:[SAPost postWithHTMLTableElement:table]];
        }
        [posts setValue:self forKey:@"thread"];
        if (completionHandler) {
            completionHandler(nil, posts);
        }
    }];
}

@end
