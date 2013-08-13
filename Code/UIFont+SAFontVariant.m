//
//  UIFont+SAFontVariant.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import "UIFont+SAFontVariant.h"
#import <CoreText/CoreText.h>

@implementation UIFont (SAFontVariant)

- (UIFont *)normalVariant
{
    return FontVariantWithValuesForSymbolicTraits(self, 0, kCTFontBoldTrait | kCTFontItalicTrait);
}

- (UIFont *)boldVariant
{
    return FontVariantWithValuesForSymbolicTraits(self, kCTFontBoldTrait, kCTFontBoldTrait);
}

static UIFont * FontVariantWithValuesForSymbolicTraits(UIFont *font, CTFontSymbolicTraits values,
                                                       CTFontSymbolicTraits mask)
{
    CTFontRef ctfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    CTFontRef ctnewFont = CTFontCreateCopyWithSymbolicTraits(ctfont, 0, NULL, values, mask);
    UIFont *newFont = [UIFont fontWithName:CFBridgingRelease(CTFontCopyPostScriptName(ctnewFont))
                                      size:font.pointSize];
    CFRelease(ctnewFont);
    CFRelease(ctfont);
    return newFont;
}

@end
