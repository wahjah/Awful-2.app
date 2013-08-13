//
//  SABasementViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-12.
//

#import "SABasementViewController.h"
#import "SABasementItem.h"
#import "SASidebarViewController.h"

@interface SABasementViewController ()

@property (nonatomic) SASidebarViewController *sidebarViewController;
@property (nonatomic) UIView *mainContainerView;
@property (copy, nonatomic) NSArray *selectedViewControllerConstraints;
@property (copy, nonatomic) NSArray *visibleBasementConstraints;

@end

@implementation SABasementViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewControllers = [viewControllers copy];
        _selectedViewController = _viewControllers[0];
        NSArray *items = [_viewControllers valueForKey:@"basementItem"];
        _sidebarViewController = [[SASidebarViewController alloc] initWithBasementItems:items];
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.mainContainerView = [UIView new];
    self.mainContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainContainerView];
    [self replaceMainViewController:nil withViewController:self.selectedViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *root = self.view;
    UIView *main = self.mainContainerView;
    NSDictionary *views = NSDictionaryOfVariableBindings(root, main);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0@750-[main(==root)]-0@750-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    if (self.basementVisible) {
        [self showBasementAnimated:NO];
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if (_selectedViewController == selectedViewController) {
        return;
    }
    UIViewController *old = _selectedViewController;
    _selectedViewController = selectedViewController;
    if ([self isViewLoaded]) {
        [self replaceMainViewController:old withViewController:selectedViewController];
    }
}

- (void)replaceMainViewController:(UIViewController *)oldViewController
               withViewController:(UIViewController *)newViewController
{
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self.mainContainerView removeConstraints:self.selectedViewControllerConstraints ?: @[]];
    [oldViewController.view removeFromSuperview];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainContainerView addSubview:newViewController.view];
    NSMutableArray *constraints = [NSMutableArray new];
    UIView *new = newViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(new);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[new]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[new]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    self.selectedViewControllerConstraints = constraints;
    [self.mainContainerView addConstraints:constraints];
    [oldViewController removeFromParentViewController];
    [newViewController didMoveToParentViewController:self];
}

- (void)setBasementVisible:(BOOL)basementVisible
{
    [self setBasementVisible:basementVisible animated:NO];
}

- (void)setBasementVisible:(BOOL)basementVisible animated:(BOOL)animated
{
    if (basementVisible == _basementVisible) return;
    _basementVisible = basementVisible;
    if (![self isViewLoaded]) return;
    if (basementVisible) {
        [self showBasementAnimated:animated];
    } else {
        [self hideBasementAnimated:animated];
    }
}

- (void)showBasementAnimated:(BOOL)animated
{
    [self lazilyAddSidebarViewControllerAsChild];
    UIView *basement = self.sidebarViewController.view;
    UIView *main = self.mainContainerView;
    NSDictionary *views = NSDictionaryOfVariableBindings(basement, main);
    self.visibleBasementConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[basement][main]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views];
    [self.view addConstraints:self.visibleBasementConstraints];
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideBasementAnimated:(BOOL)animated
{
    [self.view removeConstraints:self.visibleBasementConstraints];
    self.visibleBasementConstraints = nil;
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)lazilyAddSidebarViewControllerAsChild
{
    if ([self.sidebarViewController.parentViewController isEqual:self]) {
        return;
    }
    [self addChildViewController:self.sidebarViewController];
    self.sidebarViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.sidebarViewController.view belowSubview:self.mainContainerView];
    [self.sidebarViewController didMoveToParentViewController:self];
    UIView *basement = self.sidebarViewController.view;
    id top = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(basement, top);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[basement(==280)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top][basement]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

@end
