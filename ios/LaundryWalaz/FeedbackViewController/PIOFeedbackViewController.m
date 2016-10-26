//
//  PIOFeedbackViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/18/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOFeedbackViewController.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOUser.h"

@interface PIOFeedbackViewController () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *dropdownButton;
@property (nonatomic, strong) NSMutableArray *feedbackOpntions;
@property (nonatomic, weak) IBOutlet UITextField *feedbackAboutTextField;
@property (nonatomic, weak) IBOutlet UITextView *feedbackDetailTextView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *orderIDTextField;

@end

@implementation PIOFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
    
    // Do any additional setup after loading the view from its nib.
    
    // Add feedback options for dropdown list
    self.feedbackOpntions = [NSMutableArray arrayWithObjects: @"Your feedback about?", @"Quality", @"Staff", @"Service", nil];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Feedback" onViewController:self];
    
    self.feedbackDetailTextView.layer.borderWidth = 1.0;
    self.feedbackDetailTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Set Tableview Border
    self.tableView.layer.borderWidth = .8;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self hideTableview];
    
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
    if (self.customerNameTextField.text.length == 0) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter customer name." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
        
    }
    else if (self.orderIDTextField.text.length == 0) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter order ID." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
        
    }
    else if (self.feedbackAboutTextField.text.length == 0) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select feedback about option." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
        
    }
    else if ([self.feedbackDetailTextView.text isEqualToString: @"Feedback detail"] || self.feedbackDetailTextView.text.length == 0) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please enter some feedback to send." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
    
    [self feedbackAPICall];
    
}


- (IBAction)dropdownButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    CGRect frame = CGRectMake(self.feedbackAboutTextField.frame.origin.x, self.feedbackAboutTextField.frame.size.height+self.feedbackAboutTextField.frame.origin.y, self.feedbackAboutTextField.frame.size.width,0);
    NSInteger animation = UIViewAnimationOptionCurveEaseIn;
    
    if (!button.isSelected) {
        [self hideTableview];
        frame =  CGRectMake(self.feedbackAboutTextField.frame.origin.x, self.feedbackAboutTextField.frame.size.height+self.feedbackAboutTextField.frame.origin.y, self.feedbackAboutTextField.frame.size.width,120);
        animation = UIViewAnimationOptionCurveEaseOut;
        [button setSelected: YES];
        self.tableView.hidden = NO;
        
    }
    else
    {
        [self hideTableview];
        
    }
    
    [UIView animateWithDuration:.1 delay:0.0 options:animation animations:^{
        self.tableView.frame  = frame;
    } completion:^(BOOL finished) {
        
        
    }];
}


#pragma mark - Private Methods
- (void)applyFonts
{
    [self.feedbackAboutTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.47f]];
    [self.feedbackDetailTextView setFont: [UIFont PIOMyriadProLightWithSize: 13.75f]];
    [self.sendButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.75f]];
}

- (void)hideTableview
{
    self.tableView.hidden = YES;
    [self.dropdownButton setSelected: NO];
    self.tableView.frame =  CGRectMake(self.feedbackAboutTextField.frame.origin.x, self.feedbackAboutTextField.frame.size.height+self.feedbackAboutTextField.frame.origin.y, self.feedbackAboutTextField.frame.size.width,0);
}

- (void)feedbackAPICall
{
    if ([[PIOAppController sharedInstance] connectedToNetwork]) {
        [[PIOAppController sharedInstance] showActivityViewWithMessage: @""];
        [PIOUser userFeedback: self.feedbackAboutTextField.text  customerName: self.customerNameTextField.text orderID: self.orderIDTextField.text feedbackDetail: self.feedbackDetailTextView.text callback:^(NSError *error, BOOL status, id responseObject) {
            [[PIOAppController sharedInstance] hideActivityView];
            if (status) {
                [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Feedback sent successfully." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeSuccess];
                self.feedbackDetailTextView.text = nil;
                self.feedbackAboutTextField.text = nil;
            }
            else {
                PIOAPIResponse * APIResponse = (PIOAPIResponse *) responseObject;
                [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: APIResponse.message withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            }
        }];
    }
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.detailTextLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [cell.detailTextLabel setText: [self.feedbackOpntions objectAtIndex: indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame  = CGRectMake(self.feedbackAboutTextField.frame.origin.x, self.feedbackAboutTextField.frame.size.height+self.feedbackAboutTextField.frame.origin.y, self.feedbackAboutTextField.frame.size.width,0);
    } completion:^(BOOL finished) {
        [self.feedbackAboutTextField setText: [self.feedbackOpntions objectAtIndex: indexPath.row]];
        [self hideTableview];
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.feedbackDetailTextView) {
        if ([textView.text isEqualToString:@"Feedback detail"]) {
            self.feedbackDetailTextView.text = @"";
            self.feedbackDetailTextView.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
        }
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.feedbackDetailTextView.text.length == 0){
        self.feedbackDetailTextView.textColor = [UIColor lightGrayColor];
        self.feedbackDetailTextView.text = @"Feedback detail";
        [self.feedbackDetailTextView resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.feedbackDetailTextView.text.length == 0){
        self.feedbackDetailTextView.textColor = [UIColor lightGrayColor];
        self.feedbackDetailTextView.text = @"Feedback detail";
        [self.feedbackDetailTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        return YES;
    }
    else if(self.feedbackDetailTextView.text.length > 500)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
