//
//  SABasementItem.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import "SABasementItem.h"

@implementation SABasementItem

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = [title copy];
    }
    return self;
}

@end
