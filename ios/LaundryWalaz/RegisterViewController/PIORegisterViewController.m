//
//  PIORegisterViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/14/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIORegisterViewController.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOUser.h"

@interface PIORegisterViewController ()


@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, weak) IBOutlet UIImageView *profileCoverImageView;
@property (nonatomic, strong) NSString *imagePath;
@end

@implementation PIORegisterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applyFonts];
    
    // hide Menu button from right side of the navigation bar.
     self.menuButtonNeedToHide = YES;
    
    // profile image cover according to screen
    [self.profileCoverImageView setImage: [UIImage imageForDeviceWithName:@"register-icon"]];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Register" onViewController:self];
    
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

- (IBAction)registerButtonPressed:(id)sender
{
    
    if (self.firstNameTextField.text.length == 0 || self.lastNameTextField.text.length == 0 || self.phoneTextField.text.length == 0 || self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0 ) {
       
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please fill empty fields." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else if (![[PIOAppController sharedInstance] isValidEmailAddress:self.emailTextField.text]) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please enter a valid email address." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else {
        if ([[PIOAppController sharedInstance] connectedToNetwork]) {
            
            [[PIOAppController sharedInstance] showActivityViewWithMessage: @""];
            PIOUser *user = [[PIOUser alloc] initWithParametersID: nil firstName: self.firstNameTextField.text lastName:self.lastNameTextField.text email: self.emailTextField.text password: self.passwordTextField.text phone: self.phoneTextField.text address: nil locationID: nil];
            
            [PIOUser userRegistration: user callback:^(NSError *error, BOOL status, id responseObject) {
                [[PIOAppController sharedInstance] hideActivityView];
                if (status) {
                    [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Verification email has been sent to your email address. Please verify your email address before login." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
                    [self.navigationController popViewControllerAnimated: YES];
                }
                else {
                    PIOAPIResponse * APIResponse = (PIOAPIResponse *) responseObject;
                    [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: APIResponse.message withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
                }
                
            }];
        }
    }
}

#pragma mark - Private Methods

- (void)applyFonts
{
    [self.firstNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.lastNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.phoneTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.emailTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.passwordTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.registerButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 14.75f]];
    
}

@end
