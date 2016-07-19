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
@property (nonatomic, weak) IBOutlet UILabel *deliveronDateTitleLabel;

// Time slots Morning, Afternoon, Evening.
@property (nonatomic, weak) IBOutlet UIButton *morningSlotPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *afternoonSlotPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *eveningSlotPickupButton;


@property (nonatomic, weak) IBOutlet UIView *deliveryDateContainerView;
@property (nonatomic, weak) IBOutlet UIView *pickupDateContainerView;

@property (nonatomic, weak) IBOutlet UIButton *otherDayDeliveryButton;
@property (nonatomic, weak) IBOutlet UIButton *tomorrowDeliveryButton;
@property (nonatomic, weak) IBOutlet UIButton *todayDeliveryButton;

@property (nonatomic, weak) IBOutlet UIButton *otherDayPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *tomorrowPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *todayPickupButton;

@property (nonatomic, assign, getter=isFromPickUp) BOOL fromPickUp;
@property (nonatomic, strong) NSDate *pickupSelectedDate;
@property (nonatomic, strong) NSDate *deliverOnSelectedDate;
@property (nonatomic, weak) IBOutlet UIButton *regularDeliveryButton;
@property (nonatomic, weak) IBOutlet UIButton *expressDeliveryButton;
@property (nonatomic, weak) IBOutlet UILabel *whenTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickUpTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayPickUpTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tomorrowPickUpTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tomorrowDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherDayPickUpTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *openCalendarTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *deliverTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayDeliveryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayDeliveryDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tomorrowDeliveryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tomorrowDeliveryDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherDayDeliveryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *openCalendarDeliveryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherDeliveryDateLabel;
@property (nonatomic, weak) IBOutlet UIButton *continueButton;

@end

@implementation PIOOrderViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = NO;
    
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
- (IBAction)timeSlotButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self setButtonStateIfSelected: button isSelected: YES withColor: [UIColor lightGrayColor]];
    
    switch (button.tag) {
        case PIOTimeSlotMorning: {
            [self setButtonStateIfSelected: self.afternoonSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            [self setButtonStateIfSelected: self.eveningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            break;
        }
        case PIOTimeSlotAfternoon: {
            [self setButtonStateIfSelected: self.morningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            [self setButtonStateIfSelected: self.eveningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            break;
        }
        case PIOTimeSlotEvening: {
            [self setButtonStateIfSelected: self.morningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            [self setButtonStateIfSelected: self.afternoonSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
            break;
        }
        default:
            break;
    }
}

- (IBAction)regularButtonPressed:(id)sender
{
    
    if (self.regularDeliveryButton.isSelected) {
        return;
    }
    [self resetAllButtonsStates];
    [self blockScreenContentForFalseOrder: YES];
    [self.regularDeliveryButton setSelected: YES];
    [self.expressDeliveryButton setSelected: NO];
   
    // Disable Today Deliver On button If Pickup today selected.
    if (self.todayDeliveryButton.isSelected) {
        [self setButtonStateIfSelected: self.todayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    }
    self.todayDeliveryButton.enabled = NO;
    self.afternoonSlotPickupButton.enabled = YES;
    self.eveningSlotPickupButton.enabled = YES;
}

- (IBAction)expressButtonPressed:(id)sender
{
    
    if (self.expressDeliveryButton.isSelected) {
        return;
    }
    
    [self resetAllButtonsStates];
    [self.regularDeliveryButton setSelected: NO];
    [self.expressDeliveryButton setSelected: YES];
    if (![self currentTimeForPickUpSlot: PIOTimeSlotMorning]) {
        [self blockScreenContentForFalseOrder: NO];
        return;
        
    }
    
    [self setButtonStateIfSelected: self.todayPickupButton isSelected:YES withColor: [UIColor clearColor]];
    [self pickupAndDeliveryButtonPressed: self.todayPickupButton];
    [self timeSlotButtonPressed: self.morningSlotPickupButton];
    self.afternoonSlotPickupButton.enabled = NO;
    self.eveningSlotPickupButton.enabled = NO;
    [self.deliveryDateContainerView setUserInteractionEnabled: NO];
    [self.pickupDateContainerView setUserInteractionEnabled: NO];
    
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
        case PIOOrderDayTodayPickUp: {
            button = self.todayPickupButton;
            
            self.tomorrowDeliveryButton.enabled = YES;
            // Disable Morning slot if not available for Pickup
            BOOL isPickupAvailable = [self currentTimeForPickUpSlot: PIOTimeSlotMorning];
            if (!isPickupAvailable) {
                self.morningSlotPickupButton.enabled = NO;
            }
            
            // Disable Afternoon slot if not available for Pickup
            isPickupAvailable = [self currentTimeForPickUpSlot: PIOTimeSlotAfternoon];
            if (!isPickupAvailable) {
                self.afternoonSlotPickupButton.enabled = NO;
            }
            
            // Disable Afternoon slot if not available for Pickup
            isPickupAvailable = [self currentTimeForPickUpSlot: PIOTimeSlotEvening];
            if (!isPickupAvailable) {
                self.eveningSlotPickupButton.enabled = NO;
            }
            
            [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.pickupSelectedDate = [self stringToDate: self.todayDateLabel.text];
            
            break;
        }
        case PIOOrderDayTomorrowPickUp: {
            button = self.tomorrowPickupButton;
            
            self.morningSlotPickupButton.enabled = YES;
            self.afternoonSlotPickupButton.enabled = YES;
            self.eveningSlotPickupButton.enabled = YES;
            self.tomorrowDeliveryButton.enabled = NO;
            
            [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.pickupSelectedDate = [self stringToDate: self.tomorrowDateLabel.text];
            
            break;
        }
        case PIOOrderDayOtherDayPickUp: {
            
            // Date will be selected using calender
            
            button = self.otherDayPickupButton;
            
            self.morningSlotPickupButton.enabled = YES;
            self.afternoonSlotPickupButton.enabled = YES;
            self.eveningSlotPickupButton.enabled = YES;
            
            [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            
            break;
        }
        case PIOOrderDayTodayDeliverOn: {
            button = self.todayDeliveryButton;
            
            [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.deliverOnSelectedDate = [self stringToDate: self.todayDeliveryDateLabel.text];
            
            break;
        }
        case PIOOrderDayTomorrowDeliverOn: {
            button = self.tomorrowDeliveryButton;
            
            [self setButtonStateIfSelected: self.todayDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.deliverOnSelectedDate = [self stringToDate: self.todayDeliveryDateLabel.text];
            
            break;
        }
        case PIOOrderDayOtherDayDeliverOn: {
            button = self.otherDayDeliveryButton;
            
            [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.todayDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            
            break;
        }
            
        default:
            break;
    }
    
    if (![self currentTimeForPickUpSlot: PIOTimeSlotMorning]) {
        [self setButtonStateIfSelected: button isSelected:YES withColor: [UIColor clearColor]];
        
    }
    else {
        [self setButtonStateIfSelected: button isSelected:YES withColor: [UIColor clearColor]];
    }
}


- (IBAction)otherPickUpDateButtonPressed:(id)sender
{
    self.fromPickUp = YES;
    self.pickupSelectedDate = nil;
    [self showDatePickerWithMinDate: [NSDate new]];
}

- (IBAction)otherDeliveryDateButtonPressed:(id)sender
{
    self.fromPickUp = NO;
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate: self.pickupSelectedDate];
    [self showDatePickerWithMinDate: tomorrow ];
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
        self.pickupSelectedDate = date;
        [self.otherDateLabel setText: [self dateToDateString: date]];
    }
    else {
        self.deliverOnSelectedDate = date;
        [self.otherDeliveryDateLabel setText: [self dateToDateString: date]];
    }
    
    
    self.pickupSelectedDate = date;
}


#pragma mark - Private Methods

- (void)resetAllButtonsStates
{
    [self setButtonStateIfSelected: self.todayPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.otherDayPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    
    [self setButtonStateIfSelected: self.todayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.otherDayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    
    [self setButtonStateIfSelected: self.afternoonSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
    [self setButtonStateIfSelected: self.eveningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
    [self setButtonStateIfSelected: self.morningSlotPickupButton isSelected: NO withColor: [UIColor clearColor]];
}

- (void)applyBorderToTimeSlots
{
    
    [self setbordersForTimeSlots: self.morningSlotPickupButton borderWidth:0.4 borderColor:[UIColor lightGrayColor]];
    [self setbordersForTimeSlots: self.afternoonSlotPickupButton borderWidth:0.4 borderColor:[UIColor lightGrayColor]];
    [self setbordersForTimeSlots: self.eveningSlotPickupButton borderWidth:0.8 borderColor:[UIColor lightGrayColor]];
}

- (void)setbordersForTimeSlots:(UIButton *)button borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    
    button.layer.borderWidth = .8f;
    button.layer.borderColor = borderColor.CGColor;
}

- (void)showDatePickerWithMinDate:(NSDate *)minDate
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    picker.minimumDate = minDate;
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
    
}

- (void)setUpInitialVauesForView
{
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"When?" onViewController:self];
    
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
    BOOL isExpressDeliveryAvailable = [self currentTimeForPickUpSlot: PIOTimeSlotMorning];
    [self.expressDeliveryButton setSelected: isExpressDeliveryAvailable];
    if (isExpressDeliveryAvailable) {
        [self.expressDeliveryButton setSelected: NO];
    }
    
    [self regularButtonPressed: nil];
    [self pickupAndDeliveryButtonPressed: self.todayPickupButton];
    [self applyBorderToTimeSlots];
    
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
    
    [self.deliveronDateTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.35f]];
    
    // Continue Button
    [self.continueButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.65f]];
}

- (NSDate *)stringToDate:(NSString *)dateString
{
    dateString = [dateString stringByReplacingOccurrencesOfString:@"th" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"st" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"nd" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"rd" withString:@""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return  date;
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

-(BOOL)currentTimeForPickUpSlot:(NSInteger)timeSlot
{
    BOOL isExpressDeliveryAvailable = YES;
    //Get current time
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    
    if (hour>12 && timeSlot == PIOTimeSlotMorning)
    {
        hour=hour%12;
        
        am_OR_pm = @"PM";
        isExpressDeliveryAvailable = NO;
    }
    else if ((hour >17 && timeSlot == PIOTimeSlotAfternoon) || (hour >21 && timeSlot == PIOTimeSlotEvening ))
    {
     isExpressDeliveryAvailable = NO;
    }
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    NSLog(@"Current Time  %@",[NSString stringWithFormat:@"%02ld:%02ld:%02ld %@", (long)hour, (long)minute, (long)second,am_OR_pm]);
    return  isExpressDeliveryAvailable;
}

- (void)setButtonStateIfSelected:(UIButton *)button isSelected:(BOOL)isSelected withColor:(UIColor *)color
{
    [button setSelected: isSelected];
    
    if (isSelected) {
        [button setBackgroundColor: color];
    }
    else {
        [button setBackgroundColor: color];
        [button setAlpha:0.62f];
    }
    
}

@end
