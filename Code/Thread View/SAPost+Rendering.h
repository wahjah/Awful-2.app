//
//  SAPost+Rendering.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-30.
//

#import "SAPost.h"

@interface SAPost (Rendering)

/**
 * The post's contents as an attributed string, suitable for display in an SAPostTextView.
 */
- (NSAttributedString *)stringContents;

@end
