//
//  PIOOrderSummaryViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/19/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrderSummaryViewController.h"
#import "PIOOrderStatusViewController.h"
#import "PIOMapViewController.h"
#import "PIOAppController.h"

@interface PIOOrderSummaryViewController ()

@property (nonatomic, weak) IBOutlet UILabel *orderPlacedTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderIDTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderIDLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickUpDateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickUpDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *deliveryDateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *deliverDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *AddressTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *orderStatusButton;


@end

@implementation PIOOrderSummaryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Hide Back button
    self.navigationItem.leftBarButtonItem=nil;
    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
   
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Summary" onViewController:self];
    
    [self applyFonts];
    [self showOrderSummary];
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

- (IBAction)cancelOrderButtonPressed:(id)sender
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle: @"" message: @"" delegate: self cancelButtonTitle: nil otherButtonTitles:@"YES", @"NO", nil];
    [alert show];
    
}

- (IBAction)orderStatusButtonPressed:(id)sender
{
    PIOOrderStatusViewController *orderStatusViewController = [PIOOrderStatusViewController new];
    [self.navigationController pushViewController: orderStatusViewController animated: YES];
}

#pragma mark - Private Methods

- (void)applyFonts
{
    [self.orderPlacedTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 20.5f]];
    [self.orderIDTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.75f]];
    [self.orderIDLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.25f]];
    [self.pickUpDateTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.75f]];
    [self.pickUpDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.25f]];
    [self.deliveryDateTitleLabel setFont: [UIFont PIOMyriadProLightWithSize:15.75f]];
    [self.deliverDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.25f]];
    [self.AddressTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.75f]];
    [self.addressLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.25f]];
    [self.cancelButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.65f]];
    [self.orderStatusButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.65f]];
    
}


- (void)showOrderSummary
{
    self.orderIDLabel.text = [PIOAppController sharedInstance].order.ID;
    self.pickUpDateLabel.text = [self dateToDateString: [PIOAppController sharedInstance].order.pickupTime  isDeliveryDateAndTime: NO];
    NSString *deliverDate = [self dateToDateString: [PIOAppController sharedInstance].order.deliveronTime  isDeliveryDateAndTime: YES];
    
    self.deliverDateLabel.text = [deliverDate stringByAppendingString: @" 6:00 PM to 9:00 PM"];
    self.addressLabel.text = [PIOAppController sharedInstance].order.address;
    
    NSDictionary *fontAttributes = @{NSFontAttributeName : [UIFont PIOMyriadProLightWithSize: 11.25f]};
    CGSize textSize = [self.addressLabel.text sizeWithAttributes:fontAttributes];
    CGFloat textHeight = textSize.height;
    CGRect frame = self.addressLabel.frame;
    frame.size.height = textHeight;
    self.addressLabel.frame = frame;
}
- (NSString *)dateToDateString:(NSString *)dateStr isDeliveryDateAndTime:(BOOL)isDeliveryMode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *dateStr = [dateFormatter stringFromDate: date];
    NSDate *dddddd = [dateFormatter dateFromString:dateStr];
    
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init] ;
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [monthDayFormatter setDateFormat:@"EEEE"];
    NSString *day = [monthDayFormatter stringFromDate:dddddd] ;
    
    [monthDayFormatter setDateFormat:@"d MMM"];
    int date_day = [[monthDayFormatter stringFromDate:dddddd] intValue];
    
    
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *format = [NSString stringWithFormat:@"%d",date_day];
    NSString *dateStrfff = [format stringByAppendingString:suffix];
    
    [monthDayFormatter setDateFormat:@"MMM"];
    NSString *monthString = [monthDayFormatter stringFromDate:dddddd];
    
    [monthDayFormatter setDateFormat:@"yyyy"];
//    NSString *yearString = [monthDayFormatter stringFromDate:dddddd];
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    [monthDayFormatter setTimeZone: outputTimeZone];
    [monthDayFormatter setDateFormat:@"hh:mm a"];
    NSString *time = [monthDayFormatter stringFromDate:dddddd];
    
    NSString *final = [day stringByAppendingString:@", "];
    final = [final stringByAppendingString:dateStrfff];
    final = [final stringByAppendingString:@" "];
    final = [final stringByAppendingString:monthString];
    if (!isDeliveryMode) {
        final = [final stringByAppendingString:@" "];
        final = [final stringByAppendingString:time];
    }
    
    return final;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (![self.navigationController.visibleViewController isKindOfClass:[PIOMapViewController class]] ) {
            
            PIOMapViewController *orderViewController;
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[PIOMapViewController class]]) {
                    orderViewController = (PIOMapViewController *)viewController;
                    break;
                }
            }
            if (orderViewController == nil) {
                orderViewController = [PIOMapViewController new];
                [[[PIOAppController sharedInstance] navigationController] pushViewController: orderViewController animated:NO];
            } else {
                
                [[[PIOAppController sharedInstance] navigationController] popToViewController: orderViewController animated:NO];
            }
        }
    }
    
}

@end
