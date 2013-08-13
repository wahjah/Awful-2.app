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
    SALoginFormViewController *logIn = [SALoginFormViewController new];
    logIn.completionHandler = ^{
        UIAlertView *alert = [UIAlertView new];
        alert.title = @"Logged in!";
        alert.message = @"Good job I guess.";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    };
    UIBarButtonItem *toggleBasementButton = [[UIBarButtonItem alloc] initWithTitle:@"☜"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(toggleBasement)];
    logIn.navigationItem.leftBarButtonItem = toggleBasementButton;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIn];
    UIViewController *basement = [UIViewController new];
    basement.view.backgroundColor = [UIColor orangeColor];
    self.basementViewController = [[SABasementViewController alloc] initWithBasementViewController:basement
                                                                                mainViewController:nav];
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
