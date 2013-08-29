//
//  SAPost.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-27.
//

#import "SAModels.h"
#import <HTMLReader/HTMLReader.h>

@interface HTMLNode (SAPost)

- (NSAttributedString *)sa_innerAttributedString;

@end

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
    
    // Approximately process whitespace according to CSS 2.1 spec.
    // http://www.w3.org/TR/CSS2/text.html#white-space-model
    NSMutableAttributedString *stringContents = [contentsNode.sa_innerAttributedString mutableCopy];
    
    // NSRegularExpressionSearch is not documented to work for any of NSMutableString's methods.
    [stringContents.mutableString replaceOccurrencesOfString:@" +"
                                                  withString:@" "
                                                     options:NSRegularExpressionSearch
                                                       range:NSMakeRange(0, stringContents.length)];
    [stringContents.mutableString replaceOccurrencesOfString:@" ?\n ?"
                                                  withString:@"\n"
                                                     options:NSRegularExpressionSearch
                                                       range:NSMakeRange(0, stringContents.length)];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)stringContents.mutableString);
    
    // Set the default body font anywhere the font attribute is missing.
    [stringContents enumerateAttribute:NSFontAttributeName
                               inRange:NSMakeRange(0, stringContents.length)
                               options:0
                            usingBlock:^(id value, NSRange range, BOOL *stop)
    {
        if (!value) {
            [stringContents addAttribute:NSFontAttributeName
                                   value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                   range:range];
        }
    }];
    post.stringContents = stringContents;
    return post;
}

@end

@implementation HTMLNode (SAPost)

- (NSAttributedString *)sa_innerAttributedString
{
    return nil;
}

@end

@implementation HTMLElementNode (SAPost)

- (NSAttributedString *)sa_innerAttributedString
{
    NSMutableAttributedString *string = [NSMutableAttributedString new];
    for (HTMLNode *child in self.childNodes) {
        NSAttributedString *childStringContents = child.sa_innerAttributedString;
        if (childStringContents) {
            [string appendAttributedString:childStringContents];
        }
    }
    
    if ([self.tagName isEqualToString:@"a"]) {
        NSURL *base = [NSURL URLWithString:@"http://forums.somethingawful.com/"];
        NSURL *url = [NSURL URLWithString:self[@"href"] relativeToURL:base];
        [string addAttribute:NSLinkAttributeName value:url range:NSMakeRange(0, string.length)];
    }
    else if ([self.tagName isEqualToString:@"b"]) {
        [string addAttribute:NSFontAttributeName
                       value:BodyFontWithSymbolicTraits(UIFontDescriptorTraitBold)
                       range:NSMakeRange(0, string.length)];
    }
    else if ([self.tagName isEqualToString:@"br"]) {
        [string.mutableString appendString:@"\n"];
    }
    else if ([self.tagName isEqualToString:@"i"]) {
        [string addAttribute:NSFontAttributeName
                       value:BodyFontWithSymbolicTraits(UIFontDescriptorTraitItalic)
                       range:NSMakeRange(0, string.length)];
    }
    else if ([self.tagName isEqualToString:@"li"]) {
        [string.mutableString insertString:@"•\t" atIndex:0];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        CGSize bulletSpaceSize = [@"•N" sizeWithAttributes:@{ NSFontAttributeName: BodyFontWithSymbolicTraits(0) }];
        CGFloat indent = ceilf(bulletSpaceSize.width);
        
        // No idea why this tab stop won't line up with the headIndent. For now, a trial-and-errored `- 5`.
        style.tabStops = @[ [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural
                                                            location:indent - 5
                                                             options:nil] ];
        style.headIndent = indent;
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    }
    
    return string;
}

static UIFont * BodyFontWithSymbolicTraits(UIFontDescriptorSymbolicTraits traits)
{
    UIFontDescriptor *body = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptorSymbolicTraits newTraits = body.symbolicTraits | traits;
    UIFontDescriptor *bodyWithTraits = [body fontDescriptorWithSymbolicTraits:newTraits];
    return [UIFont fontWithDescriptor:bodyWithTraits size:0];
}

@end

@implementation HTMLTextNode (SAPost)

- (NSAttributedString *)sa_innerAttributedString
{
    // Replace each newline or here with a space so that element nodes (like <br>) can insert newlines or tabs with impunity.
    NSString *data = [self.data stringByReplacingOccurrencesOfString:@"[\n\t]"
                                                          withString:@" "
                                                             options:NSRegularExpressionSearch
                                                               range:NSMakeRange(0, self.data.length)];
    return [[NSAttributedString alloc] initWithString:data];
}

@end
