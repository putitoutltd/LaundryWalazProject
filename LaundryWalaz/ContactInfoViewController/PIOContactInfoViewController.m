//
//  PIOContactInfoViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/28/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOContactInfoViewController.h"
#import "PIOLoginViewController.h"
#import "PIOOrderSummaryViewController.h"
#import "PIOAppController.h"
#import "PIOUserPref.h"

@interface PIOContactInfoViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveForFutureButton;
@property (nonatomic, assign, getter= isInfoSavedForFuture) BOOL infoSavedForFuture;
@property (nonatomic, weak) IBOutlet UILabel *topTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *infoTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UILabel *futureOrderTitleLabel;
@property (nonatomic, weak) IBOutlet UITextView *specialInstrructionsTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@end

@implementation PIOContactInfoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applyFonts];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Contact" onViewController:self];
     self.specialInstrructionsTextView.layer.borderWidth = 1.0;
    self.specialInstrructionsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self fillScreenContentIfSavedForFuture];
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

- (IBAction)loginButtonPressed:(id)sender
{
    PIOLoginViewController *loginViewController = [PIOLoginViewController new];
    [self.navigationController pushViewController: loginViewController animated: YES];
}

- (IBAction)rememberMeButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.isSelected) {
        [button setSelected: NO];
        [PIOUserPref setInforSavedForFuture: NO];
        [self saveInfoForFuture: NO];
    }
    else {
        [button setSelected: YES];
        [PIOUserPref setInforSavedForFuture: YES];
        [self saveInfoForFuture: YES];
    }

}

- (IBAction)saveButtonPressed:(id)sender
{
    
    if (self.firstNameTextField.text.length == 0 || self.lastNameTextField.text.length == 0 || self.phoneTextField.text.length == 0 || self.emailTextField.text.length == 0 ) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please fill empty fields." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else if (![[PIOAppController sharedInstance] isValidEmailAddress:self.emailTextField.text]) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please enter a valid email address." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else {
        if ([PIOUserPref isInforSavedForFuture]) {
            [self saveInfoForFuture: YES];
        }
        PIOOrderSummaryViewController *orderSummaryViewController = [PIOOrderSummaryViewController new];
        [self.navigationController pushViewController: orderSummaryViewController animated: YES];
    }
}

#pragma mark - Private Methods

- (void)fillScreenContentIfSavedForFuture
{
    if ([PIOUserPref isInforSavedForFuture]) {
        [self.saveForFutureButton setSelected: YES];
        [self.firstNameTextField setText:[PIOUserPref requestFirstName]];
        [self.lastNameTextField setText:[PIOUserPref requestLastName]];
        [self.emailTextField setText:[PIOUserPref requestEmailAddress]];
        [self.phoneTextField setText:[PIOUserPref requestPhoneNumber]];
    }
    
}

- (void)saveInfoForFuture:(BOOL)isSaved
{
    
    if (isSaved) {
        [PIOUserPref setFirstName: self.firstNameTextField.text];
        [PIOUserPref setLastName: self.lastNameTextField.text];
        [PIOUserPref setEmailAddress: self.emailTextField.text];
        [PIOUserPref setPhoneNumber: self.phoneTextField.text];
    }
    else {
        [PIOUserPref setFirstName: @""];
        [PIOUserPref setLastName: @""];
        [PIOUserPref setEmailAddress: @""];
        [PIOUserPref setPhoneNumber: @""];
    }
    
}


- (void)applyFonts
{
    [self.topTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47]];
    [self.loginButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75f]];
    [self.infoTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47]];
    [self.firstNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.lastNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.emailTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.phoneTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.futureOrderTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.saveButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75f]];
    [self.specialInstrructionsTextView setFont: [UIFont PIOMyriadProLightWithSize: 14.98f]];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.specialInstrructionsTextView) {
        if ([textView.text isEqualToString:@"Special Instructions"]) {
            self.specialInstrructionsTextView.text = @"";
            self.specialInstrructionsTextView.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
        }
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.specialInstrructionsTextView.text.length == 0){
        self.specialInstrructionsTextView.textColor = [UIColor lightGrayColor];
        self.specialInstrructionsTextView.text = @"Special Instructions";
        [self.specialInstrructionsTextView resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.specialInstrructionsTextView.text.length == 0){
        self.specialInstrructionsTextView.textColor = [UIColor lightGrayColor];
        self.specialInstrructionsTextView.text = @"Special Instructions";
        [self.specialInstrructionsTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        return YES;
    }
    else if(self.specialInstrructionsTextView.text.length > 150)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
