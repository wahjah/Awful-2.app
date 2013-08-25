//
//  SAThreadViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-14.
//

#import <UIKit/UIKit.h>

@interface SAThreadViewController : UICollectionViewController

- (id)initWithThreadID:(NSString *)threadID;

@property (readonly, copy, nonatomic) NSString *threadID;

@end
