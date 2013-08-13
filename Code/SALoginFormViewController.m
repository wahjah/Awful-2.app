//
//  SALoginFormViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-11.
//

#import "SALoginFormViewController.h"
#import "SAForumsClient.h"

@interface SALoginFormViewController () <UIAlertViewDelegate>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;

@end

@implementation SALoginFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Awful Login";
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *username = [UITextField new];
    username.translatesAutoresizingMaskIntoConstraints = NO;
    username.placeholder = @"Username";
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    [username addTarget:self action:@selector(updateUsername:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:username];
    
    UITextField *password = [UITextField new];
    password.translatesAutoresizingMaskIntoConstraints = NO;
    password.secureTextEntry = YES;
    password.placeholder = @"Password";
    [password addTarget:self action:@selector(updatePassword:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:password];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeSystem];
    submit.translatesAutoresizingMaskIntoConstraints = NO;
    [submit setTitle:@"Log In" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
    id topGuide = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(username, password, submit, topGuide);
    NSString *format;
    
    format = @"V:[topGuide]-20-[username]-20-[password]-20-[submit]";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];
    
    format = @"H:|-20-[username]-20-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:username
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:password
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
}

- (void)updateUsername:(UITextField *)textField
{
    self.username = textField.text;
}

- (void)updatePassword:(UITextField *)textField
{
    self.password = textField.text;
}

- (void)logIn
{
    if (self.username.length == 0 || self.password.length == 0) {
        return;
    }
    [[SAForumsClient client] logInWithUsername:self.username
                                      password:self.password
                             completionHandler:^(NSError *error)
    {
        if (error) {
            UIAlertView *alert = [UIAlertView new];
            alert.title = @"Could Not Log In";
            alert.message = error.localizedDescription;
            [alert addButtonWithTitle:@"OK"];
            [alert show];
        } else {
            if (self.completionHandler) {
                self.completionHandler();
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
