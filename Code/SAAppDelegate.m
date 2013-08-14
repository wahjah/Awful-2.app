//
//  SAAppDelegate.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import "SAAppDelegate.h"
#import "SABasementViewController.h"
#import "SAForumsClient.h"
#import "SALoginFormViewController.h"
#import "SAThreadViewController.h"

@interface SAAppDelegate ()

@property (nonatomic) SABasementViewController *basementViewController;

@end

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSArray *titles = @[ @"Forums", @"Bookmarks", @"Read Later", @"Messages", @"Search", @"Settings",
                         @"Archives", @"Leper's Colony", @"Buddy List", @"SAclopedia", @"Posting Gloryhole" ];
    for (NSString *title in titles) {
        UIViewController *viewController = [UIViewController new];
        viewController.title = title;
        viewController.view.backgroundColor = [UIColor whiteColor];
        [viewControllers addObject:viewController];
    }
    SAThreadViewController *awfulThread = [[SAThreadViewController alloc] initWithThreadID:@"3564303"];
    awfulThread.title = @"Awful's Thread";
    [viewControllers addObject:awfulThread];
    for (NSUInteger i = 0; i < viewControllers.count; i++) {
        UIViewController *viewController = viewControllers[i];
        UIBarButtonItem *toggleBasementButton = [[UIBarButtonItem alloc] initWithTitle:@"☜"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(toggleBasement)];
        viewController.navigationItem.leftBarButtonItem = toggleBasementButton;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers replaceObjectAtIndex:i withObject:nav];
    }
    self.basementViewController = [[SABasementViewController alloc] initWithViewControllers:viewControllers];
    self.window.rootViewController = self.basementViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if (![SAForumsClient client].loggedInUserID) {
        SALoginFormViewController *logIn = [SALoginFormViewController new];
        logIn.completionHandler = ^{
            [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
        [self.window.rootViewController presentViewController:nav animated:NO completion:nil];
    }
    return YES;
}

- (void)toggleBasement
{
    [self.basementViewController setBasementVisible:!self.basementViewController.basementVisible animated:YES];
}

@end
