//
//  SABasementViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-12.
//

#import "SABasementViewController.h"

@interface SABasementViewController ()

@property (nonatomic) NSArray *visibleBasementConstraints;

@end

@implementation SABasementViewController

- (id)initWithBasementViewController:(UIViewController *)basementViewController
                  mainViewController:(UIViewController *)mainViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _basementViewController = basementViewController;
        _mainViewController = mainViewController;
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *root = self.view;
    UIView *main = self.mainViewController.view;
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
    [self addBasementViewControllerAsChildIfNeeded];
    UIView *basement = self.basementViewController.view;
    UIView *main = self.mainViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(basement, main);
    self.visibleBasementConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[basement][main]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views];
    [self.view addConstraints:self.visibleBasementConstraints];
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)addBasementViewControllerAsChildIfNeeded
{
    if ([self.basementViewController.parentViewController isEqual:self]) {
        return;
    }
    [self addChildViewController:self.basementViewController];
    self.basementViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.basementViewController.view belowSubview:self.mainViewController.view];
    [self.basementViewController didMoveToParentViewController:self];
    UIView *basement = self.basementViewController.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(basement);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[basement(==280)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[basement]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)hideBasementAnimated:(BOOL)animated
{
    [self.view removeConstraints:self.visibleBasementConstraints];
    self.visibleBasementConstraints = nil;
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
