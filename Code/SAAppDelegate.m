//
//  SAAppDelegate.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import "SAAppDelegate.h"
#import "SALoginFormViewController.h"

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SALoginFormViewController *logIn = [SALoginFormViewController new];
    logIn.completionHandler = ^{
        UIAlertView *alert = [UIAlertView new];
        alert.title = @"Logged in!";
        alert.message = @"Good job I guess.";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
