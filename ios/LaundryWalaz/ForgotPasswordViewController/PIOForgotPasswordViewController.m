//
//  PIOForgotPasswordViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/15/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOForgotPasswordViewController.h"
#import "PIOAppController.h"

@interface PIOForgotPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;

@end

@implementation PIOForgotPasswordViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applyFonts];
    
    // hide Menu button from right side of the navigation bar.
    self.menuButtonNeedToHide = YES;
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Forgot Login details" onViewController:self];
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
- (IBAction)sendButtonPressed:(id)sender
{
    if (self.emailAddressTextField.text.length == 0) {
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter Email address." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
    else if (![[PIOAppController sharedInstance] isValidEmailAddress: self.emailAddressTextField.text]) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter a valid email address."withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
    else {
        
    }
}

#pragma mark - Private Methods
- (void)applyFonts
{
    [self.emailAddressTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.detailLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.0f]];
    [self.sendButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75f]];
    
}


@end
