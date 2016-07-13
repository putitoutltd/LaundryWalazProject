//
//  PIOOrderViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrderViewController.h"
#import "IQActionSheetPickerView.h"
#import "PIOContactInfoViewController.h"
#import "PIOAppController.h"

@interface PIOOrderViewController () <IQActionSheetPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *deliveryDateContainerView;

@property (weak, nonatomic) IBOutlet UIView *pickupDateContainerView;
@property (weak, nonatomic) IBOutlet UIButton *otherDayDeliveryButton;

@property (weak, nonatomic) IBOutlet UIButton *tomorrowDeliveryButton;

@property (weak, nonatomic) IBOutlet UIButton *todayDeliveryButton;

@property (weak, nonatomic) IBOutlet UIButton *otherDayPickupButton;

@property (weak, nonatomic) IBOutlet UIButton *tomorrowPickupButton;

@property (weak, nonatomic) IBOutlet UIButton *todayPickupButton;
@property (nonatomic, assign, getter=isFromPickUp) BOOL fromPickUp;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *regularDeliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *expressDeliveryButton;
@property (weak, nonatomic) IBOutlet UILabel *whenTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayPickUpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowPickUpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDayPickUpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *openCalendarTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDeliveryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDeliveryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowDeliveryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowDeliveryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDayDeliveryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *openCalendarDeliveryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDeliveryDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation PIOOrderViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"New Order";
    [self setUpInitialVauesForView];
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

#pragma mark - IBAction

- (IBAction)regularButtonPressed:(id)sender
{
    [self blockScreenContentForFalseOrder: YES];
    [self.regularDeliveryButton setSelected: YES];
    [self.expressDeliveryButton setSelected: NO];
}

- (IBAction)expressButtonPressed:(id)sender
{
    [self.regularDeliveryButton setSelected: NO];
    [self.expressDeliveryButton setSelected: YES];
    if (![self currentTime]) {
        [self setButtonStateIfSelected: self.todayPickupButton isSelected:NO];
        [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected:NO];
        [self setButtonStateIfSelected: self.otherDayPickupButton isSelected:NO];
        [self blockScreenContentForFalseOrder: NO];
        return;
        
    }
    
}
- (void)blockScreenContentForFalseOrder:(BOOL)block
{
    [self.pickupDateContainerView setUserInteractionEnabled: block];
    [self.deliveryDateContainerView setUserInteractionEnabled: block];
    [self.continueButton setEnabled: block];
    
}
- (IBAction)pickupAndDeliveryButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0: {
            button = self.todayPickupButton;
            break;
        }
        case 1: {
            button = self.tomorrowPickupButton;
            break;
        }
        case 2: {
            button = self.otherDayPickupButton;
            break;
        }
        case 3: {
            button = self.todayDeliveryButton;
            break;
        }
        case 4: {
            button = self.tomorrowDeliveryButton;
            break;
        }
        case 5: {
            button = self.otherDayDeliveryButton;
            break;
        }
            
        default:
            break;
    }
    
    if (![self currentTime]) {
        [self setButtonStateIfSelected: button isSelected:YES];
        
    }
    else {
        [self setButtonStateIfSelected: self.todayPickupButton isSelected:YES];
    }
}


- (IBAction)otherPickUpDateButtonPressed:(id)sender
{
    self.fromPickUp = YES;
    self.selectedDate = nil;
    [self showDatePickerWithMinDate: [NSDate new]];
}

- (IBAction)otherDeliveryDateButtonPressed:(id)sender
{
    self.fromPickUp = NO;
    [self showDatePickerWithMinDate: self.selectedDate];
}

- (IBAction)continueButtonPressed:(id)sender
{
    PIOContactInfoViewController *contactInfoViewController = [PIOContactInfoViewController new];
    [self.navigationController pushViewController: contactInfoViewController animated: YES];
}

#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    if (self.isFromPickUp) {
        [self.otherDateLabel setText: [self dateToDateString: date]];
    }
    else {
        [self.otherDeliveryDateLabel setText: [self dateToDateString: date]];
    }
    
    
    self.selectedDate = date;
}


#pragma mark - Private Methods

- (void)showDatePickerWithMinDate:(NSDate *)minDate
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    picker.minimumDate = minDate;
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
    
}

- (void)setUpInitialVauesForView
{
    [self applyFonts];
    
    // Today and Tomorrow date
    NSDate *today = [NSDate new];
    NSString *todayDateString = [self dateToDateString: today];
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate: today];
    NSString *tomorrowDateString = [self dateToDateString: tomorrow];
    
    [self.todayDateLabel setText: todayDateString];
    [self.tomorrowDateLabel setText: tomorrowDateString];
    
    [self.todayDeliveryDateLabel setText: todayDateString];
    [self.tomorrowDeliveryDateLabel setText: tomorrowDateString];
    [self multiLineTextForButton];
    BOOL isExpressDeliveryAvailable = [self currentTime];
    [self.expressDeliveryButton setSelected: isExpressDeliveryAvailable];
    if (isExpressDeliveryAvailable) {
        [self.expressDeliveryButton setSelected: NO];
    }
    
    
}

- (void)applyFonts
{
    // When Label
    [self.whenTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 28.12f]];
    // PickUp Label
    [self.pickUpTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47f]];
    // Today Box labels (Pickup)
    [self.todayPickUpTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.todayDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    // Tomorrow Box labels (Pickup)
    [self.tomorrowPickUpTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.tomorrowDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    // Other Date Box labels (Pickup)
    [self.otherDayPickUpTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.openCalendarTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    
    // PickUp Label
    [self.deliverTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47f]];
    
    // Today Box labels (Delivery)
    [self.todayDeliveryTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.todayDeliveryDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    // Tomorrow Box labels (Delivery)
    [self.tomorrowDeliveryTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.tomorrowDeliveryDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    // Other Date Box labels (Delivery)
    [self.otherDayDeliveryTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    [self.openCalendarDeliveryTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 7.86]];
    
    // Continue Button
    [self.continueButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.65f]];
}

- (NSString *)dateToDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateStr = [dateFormatter stringFromDate: date];
    NSDate *d = [dateFormatter dateFromString:dateStr];
   
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init] ;
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [monthDayFormatter setDateFormat:@"d MMM"];
    int date_day = [[monthDayFormatter stringFromDate:d] intValue];
    
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *format = [NSString stringWithFormat:@"%d",date_day];
    NSString *dateStrfff = [format stringByAppendingString:suffix];
    
    [monthDayFormatter setDateFormat:@"MMM"];
    NSString *monthString = [monthDayFormatter stringFromDate:d];
    [monthDayFormatter setDateFormat:@"yyyy"];
    NSString *yearString = [monthDayFormatter stringFromDate:d];
    NSString *final = [dateStrfff stringByAppendingString:@" "];
    final = [final stringByAppendingString:monthString];
    final = [final stringByAppendingString:@" "];
    final = [final stringByAppendingString:yearString];
    NSLog(@"final string:---> %@",final);
    return final;
}

- (void)multiLineTextForButton
{
    // We want 2 lines for our buttons' title label
    [[self.regularDeliveryButton titleLabel] setNumberOfLines:2];
    
    // Setup the string
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@"REGULAR\nnext day delivery"];
    
    // Set the font to bold from the beginning of the string to the ","
    [titleText addAttributes:[NSDictionary dictionaryWithObject:[UIFont PIOMyriadProLightWithSize:17.96f] forKey:NSFontAttributeName] range:NSMakeRange(0, 7)];
    
    // Normal font for the rest of the text
    [titleText addAttributes:[NSDictionary dictionaryWithObject:[UIFont PIOMyriadProLightWithSize:9] forKey:NSFontAttributeName] range:NSMakeRange(7, 18)];
    
    // Set the attributed string as the buttons' title text
    [self.regularDeliveryButton setAttributedTitle:titleText forState:UIControlStateNormal];
    
    // We want 2 lines for our buttons' title label
    [[self.expressDeliveryButton titleLabel] setNumberOfLines:3];
    
    // Setup the string
   titleText = [[NSMutableAttributedString alloc] initWithString:@"EXPRESS\n6 hour delivery"];
    
    // Set the font to bold from the beginning of the string to the ","
    [titleText addAttributes:[NSDictionary dictionaryWithObject:[UIFont PIOMyriadProLightWithSize:17.96f] forKey:NSFontAttributeName] range:NSMakeRange(0, 7)];
    
    // Normal font for the rest of the text
    [titleText addAttributes:[NSDictionary dictionaryWithObject:[UIFont PIOMyriadProLightWithSize:9] forKey:NSFontAttributeName] range:NSMakeRange(7, 16)];
    
    // Set the attributed string as the buttons' title text
    [self.expressDeliveryButton setAttributedTitle:titleText forState:UIControlStateNormal];
}

-(BOOL)currentTime
{
    BOOL isExpressDeliveryAvailable = YES;
    //Get current time
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    
    if (hour>12)
    {
        hour=hour%12;
        
        am_OR_pm = @"PM";
        isExpressDeliveryAvailable = NO;
    }
    
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    NSLog(@"Current Time  %@",[NSString stringWithFormat:@"%02ld:%02ld:%02ld %@", (long)hour, (long)minute, (long)second,am_OR_pm]);
    return  isExpressDeliveryAvailable;
}

- (void)setButtonStateIfSelected:(UIButton *)button isSelected:(BOOL)isSelected
{
    [button setSelected: isSelected];
    
    if (isSelected) {
        [button setBackgroundColor: [UIColor clearColor]];
    }
    else {
        [button setBackgroundColor: [UIColor whiteColor]];
        [button setAlpha:0.62f];
    }
    
}

@end
