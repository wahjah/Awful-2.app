//
//  SAThreadViewController.h
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-14.
//

#import <UIKit/UIKit.h>
#import "SAModels.h"

@interface SAThreadViewController : UICollectionViewController

- (id)initWithThread:(SAThread *)thread;

@property (readonly, strong, nonatomic) SAThread *thread;

@end
