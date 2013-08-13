//
//  UIFont+SAFontVariant.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Adds methods to obtain variants of UIFont that differ in their normal/bold/italic traits.
 */
@interface UIFont (SAFontVariant)

/**
 * Returns a UIFont identical to this one except that it is neither bold nor italic.
 */
- (UIFont *)normalVariant;

/**
 * Returns a UIFont identical to this one except that it is bold.
 */
- (UIFont *)boldVariant;

@end
