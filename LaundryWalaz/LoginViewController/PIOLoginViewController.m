//
//  PIOLoginViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOLoginViewController.h"
#import "PIOAppController.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "PIOContactInfoViewController.h"

@interface PIOLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UILabel *rememberMeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end

@implementation PIOLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginButton  setBackgroundImage: [UIImage imageForDeviceWithName:@"login-btn"] forState:UIControlStateNormal];
    //[self.loginButton setImage: [UIImage imageForDeviceWithName:@"login-btn"]];
    self.navigationController.navigationBar.hidden = NO;
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Login" onViewController:self];
    [self applyFonts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)forgotPasswordButtonPressed:(id)sender
{
}

- (IBAction)rememberMeButtonPressed:(id)sender
{
    if (self.rememberMeButton.isSelected) {
        [self.rememberMeButton setSelected: NO];
    }
    else {
        [self.rememberMeButton setSelected: YES];
    }
}

- (IBAction)loginButtonPressed:(id)sender
{
    if (self.emailAddressTextField.text.length == 0) {
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Enter Email address." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
     else if (![[PIOAppController sharedInstance] isValidEmailAddress: self.emailAddressTextField.text]) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter a valid email address."withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
    else if (self.passwordTextField.text.length == 0 ) {
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Enter Password." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
    else {
        NSArray *viewControllers = [[PIOAppController sharedInstance] navigationController].viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[PIOContactInfoViewController class]]) {
                [self.navigationController popViewControllerAnimated: YES];
                break;
            }
        }
    }

    
    
}

#pragma mark - Private Methods

- (void)applyFonts
{
    [self.emailAddressTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.passwordTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.rememberMeTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.loginButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 14.75f]];
    [self.forgotPasswordButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    
}

#pragma mark - Public Methods

@end
