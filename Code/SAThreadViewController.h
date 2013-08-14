//
//  SAThreadViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-14.
//  Copyright (c) 2013 Awful Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAThreadViewController : UICollectionViewController

- (id)initWithThreadID:(NSString *)threadID;

@property (readonly, copy, nonatomic) NSString *threadID;

@end
