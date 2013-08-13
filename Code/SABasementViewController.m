//
//  SABasementViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-12.
//

#import "SABasementViewController.h"
#import "SABasementItem.h"
#import "SASidebarViewController.h"

/**
 * An SABasementViewController runs this little state machine.
 */
typedef NS_ENUM(NSInteger, SABasementState)
{
    /**
     * When in the SABasementStateHidden state, no part of the basement is visible.
     */
    SABasementStateHidden,
    
    /**
     * When in the SABasementStateObscured state, part of the basement is visible, perhaps because the user is dragging the main view.
     */
    SABasementStateObscured,
    
    /**
     * When in the SABasementStateVisible state, the whole basement is visible.
     */
    SABasementStateVisible,
};

@interface SABasementViewController () <SASidebarViewControllerDelegate>

@property (assign, nonatomic) SABasementState state;
@property (strong, nonatomic) SASidebarViewController *sidebarViewController;
@property (strong, nonatomic) UIView *mainContainerView;
@property (copy, nonatomic) NSArray *selectedViewControllerConstraints;
@property (copy, nonatomic) NSArray *visibleBasementConstraints;
@property (strong, nonatomic) NSLayoutConstraint *revealBasementConstraint;

@end

@implementation SABasementViewController

@dynamic basementVisible; // Derived from the state property.

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewControllers = [viewControllers copy];
        _selectedViewController = _viewControllers[0];
        NSArray *items = [_viewControllers valueForKey:@"basementItem"];
        _sidebarViewController = [[SASidebarViewController alloc] initWithBasementItems:items];
        _sidebarViewController.delegate = self;
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    UIScreenEdgePanGestureRecognizer *pan = [UIScreenEdgePanGestureRecognizer new];
    pan.edges = UIRectEdgeLeft;
    [pan addTarget:self action:@selector(panFromLeftScreenEdge:)];
    [self.view addGestureRecognizer:pan];
    
    self.mainContainerView = [UIView new];
    self.mainContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainContainerView];
    [self replaceMainViewController:nil withViewController:self.selectedViewController];
}

- (void)panFromLeftScreenEdge:(UIScreenEdgePanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.state = SABasementStateObscured;
        self.revealBasementConstraint.constant = [pan translationInView:self.view].x;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        self.revealBasementConstraint.constant = [pan translationInView:self.view].x;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [self setState:[pan velocityInView:self.view].x > 0 ? SABasementStateVisible : SABasementStateHidden
              animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *root = self.view;
    UIView *main = self.mainContainerView;
    NSDictionary *views = NSDictionaryOfVariableBindings(root, main);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0@500-[main(==root)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    if (self.basementVisible) {
        [self constrainBasementToBeVisible];
        [self.view setNeedsLayout];
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

- (BOOL)basementVisible
{
    return self.state != SABasementStateHidden;
}

- (void)setBasementVisible:(BOOL)basementVisible
{
    [self setBasementVisible:basementVisible animated:NO];
}

- (void)setBasementVisible:(BOOL)basementVisible animated:(BOOL)animated
{
    SABasementState newState = basementVisible ? SABasementStateVisible : SABasementStateHidden;
    [self setState:newState animated:animated];
}

- (void)setState:(SABasementState)state
{
    [self setState:state animated:NO];
}

- (void)setState:(SABasementState)state animated:(BOOL)animated
{
    if (_state == state) return;
    _state = state;
    if (![self isViewLoaded]) return;
    
    if (state == SABasementStateHidden) {
        if (self.revealBasementConstraint) {
            [self.view removeConstraint:self.revealBasementConstraint];
            self.revealBasementConstraint = nil;
        }
        if (self.visibleBasementConstraints) {
            [self.view removeConstraints:self.visibleBasementConstraints];
            self.visibleBasementConstraints = nil;
        }
    } else {
        [self lazilyAddSidebarViewControllerAsChild];
    }
    
    if (state == SABasementStateObscured) {
        if (self.visibleBasementConstraints) {
            [self.view removeConstraints:self.visibleBasementConstraints];
            self.visibleBasementConstraints = nil;
        }
        self.revealBasementConstraint = [NSLayoutConstraint constraintWithItem:self.mainContainerView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:0];
        self.revealBasementConstraint.priority = 750;
        [self.view addConstraint:self.revealBasementConstraint];
    }
    
    if (state == SABasementStateVisible) {
        if (self.revealBasementConstraint) {
            [self.view removeConstraint:self.revealBasementConstraint];
        }
        [self constrainBasementToBeVisible];
    }
    
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)constrainBasementToBeVisible
{
    if (self.visibleBasementConstraints) return;
    UIView *basement = self.sidebarViewController.view;
    UIView *main = self.mainContainerView;
    NSDictionary *views = NSDictionaryOfVariableBindings(basement, main);
    self.visibleBasementConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[basement][main]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views];
    [self.view addConstraints:self.visibleBasementConstraints];
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

#pragma mark SASidebarViewControllerDelegate

- (void)sidebar:(SASidebarViewController *)sidebar didSelectItem:(SABasementItem *)item
{
    NSUInteger i = [sidebar.basementItems indexOfObject:item];
    self.selectedViewController = self.viewControllers[i];
    [self setBasementVisible:NO animated:YES];
}

@end
