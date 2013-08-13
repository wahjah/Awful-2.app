//
//  SABasementItem.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-13.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import "SABasementItem.h"
#import <objc/runtime.h>

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

@implementation UIViewController (SABasementItem)

- (SABasementItem *)basementItem
{
    SABasementItem *item = objc_getAssociatedObject(self, &BasementItemKey);
    if (!item) {
        item = [[SABasementItem alloc] initWithTitle:self.title];
        self.basementItem = item;
    }
    return item;
}

- (void)setBasementItem:(SABasementItem *)basementItem
{
    objc_setAssociatedObject(self, &BasementItemKey, basementItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char BasementItemKey;

@end
