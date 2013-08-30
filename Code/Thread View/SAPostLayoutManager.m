//
//  SAPostLayoutManager.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-30.
//

#import "SAPostLayoutManager.h"

@implementation SAPostLayoutManager

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    NSRange characterRange = [self characterRangeForGlyphRange:glyphsToShow actualGlyphRange:nil];
    [self.textStorage enumerateAttribute:SALeftBarAttributeName
                                 inRange:characterRange
                                 options:0
                              usingBlock:^(id value, NSRange range, BOOL *stop)
    {
        if (!value) {
            return;
        }
        NSRange glyphRange = [self glyphRangeForCharacterRange:range actualCharacterRange:nil];
        CGRect firstLineRect = [self lineFragmentUsedRectForGlyphAtIndex:glyphRange.location effectiveRange:nil];
        CGRect lastLineRect = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange) - 1
                                                         effectiveRange:nil];
        CGRect leftBarRect = CGRectMake(CGRectGetMinX(firstLineRect), CGRectGetMinY(firstLineRect),
                                        1, CGRectGetMaxY(lastLineRect) - CGRectGetMinY(firstLineRect));
        const CGFloat leftBarPadding = 10;
        leftBarRect = CGRectOffset(leftBarRect, origin.x - leftBarPadding, origin.y);
        [[UIBezierPath bezierPathWithRect:leftBarRect] fill];
    }];
}

@end

NSString * const SALeftBarAttributeName = @"SALeftBarAttributeName";
