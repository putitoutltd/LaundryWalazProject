//
//  PIOFeedbackViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/18/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOFeedbackViewController.h"
#import "PIOAppController.h"

@interface PIOFeedbackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dropdownButton;
@property (nonatomic, strong) NSMutableArray *feedbackOpntions;
@property (weak, nonatomic) IBOutlet UITextField *feedbackAboutTextField;
@property (weak, nonatomic) IBOutlet UITextView *feedbackDetailTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation PIOFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add feedback options for dropdown list
    self.feedbackOpntions = [NSMutableArray arrayWithObjects: @"Cantt", @"Cavalary ground", @"DHA Phase 5&6", @"Gulberg I-V", nil];
    
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
//    [self performSelector: @selector(abc) withObject: nil afterDelay: 1.0];
    
}
- (void)abc
{
    UIImage *backgroundImageForDefaultBarMetrics = [UIImage imageNamed:@"pio-navigation-bar-background"];
    
    
    CGFloat navBarHeight = backgroundImageForDefaultBarMetrics.size.height-5;
    CGRect frame = CGRectMake(0.0f, 0.0f, backgroundImageForDefaultBarMetrics.size.width, navBarHeight);
    [self.navigationController.navigationBar setFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
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
