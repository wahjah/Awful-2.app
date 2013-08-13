//
//  SAAppDelegate.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import "SAAppDelegate.h"
#import "SABasementViewController.h"
#import "SALoginFormViewController.h"

@interface SAAppDelegate ()

@property (nonatomic) SABasementViewController *basementViewController;

@end

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSMutableArray *viewControllers = [NSMutableArray new];
    SALoginFormViewController *logIn = [SALoginFormViewController new];
    logIn.completionHandler = ^{
        UIAlertView *alert = [UIAlertView new];
        alert.title = @"Logged in!";
        alert.message = @"Good job I guess.";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    };
    [viewControllers addObject:logIn];
    for (NSString *title in @[ @"Forums", @"Bookmarks", @"Read Later", @"Messages", @"Search", @"Settings"]) {
        UIViewController *viewController = [UIViewController new];
        viewController.title = title;
        [viewControllers addObject:viewController];
    }
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
    return YES;
}

- (void)toggleBasement
{
    [self.basementViewController setBasementVisible:!self.basementViewController.basementVisible animated:YES];
}

@end
