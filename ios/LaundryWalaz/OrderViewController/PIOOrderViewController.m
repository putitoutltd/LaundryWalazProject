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
#import "PIOLoginViewController.h"
#import "PIOAppController.h"

@interface PIOOrderViewController () <IQActionSheetPickerViewDelegate>
{
    UIButton *dropdownButton;
    NSMutableArray *slots;
    NSString *timeString;
}
@property (weak, nonatomic) IBOutlet UILabel *deliverMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *todayTimePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowTimePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *otherdayTimePickerButton;
@property (nonatomic, weak) IBOutlet UILabel *deliveronDateTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *deliveryDateContainerView;
@property (nonatomic, weak) IBOutlet UIView *pickupDateContainerView;

@property (nonatomic, weak) IBOutlet UIButton *otherDayDeliveryButton;
@property (nonatomic, weak) IBOutlet UIButton *tomorrowDeliveryButton;
@property (nonatomic, weak) IBOutlet UIButton *todayDeliveryButton;

@property (nonatomic, weak) IBOutlet UIButton *otherDayPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *tomorrowPickupButton;
@property (nonatomic, weak) IBOutlet UIButton *todayPickupButton;

@property (nonatomic, assign, getter=isFromExpressDelivery) BOOL fromExpressDelivery;
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
    self.menuButtonNeedToHide = NO;
    
    // Set Tableview Border
    self.tableView.layer.borderWidth = .8;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self setUpInitialVauesForView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self hideTableview];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)regularButtonPressed:(id)sender
{
    
    if (self.regularDeliveryButton.isSelected) {
        return;
    }
    self.fromExpressDelivery = NO;
    self.pickupMessageLabel.hidden = YES;
    [self resetAllButtonsStates];
    [self blockScreenContentForFalseOrder: YES];
    [self.regularDeliveryButton setSelected: YES];
    [self.expressDeliveryButton setSelected: NO];
    
    // Disable Today Deliver On button If Pickup today selected.
    if (self.todayDeliveryButton.isSelected) {
        [self setButtonStateIfSelected: self.todayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    }
    self.todayDeliveryButton.enabled = NO;
    BOOL isTimeGreaterThan9AM = [self compareTimeIf6PMWithTimeToCompare:18];
    if (isTimeGreaterThan9AM) {
        [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
        self.todayPickupButton.enabled = NO;
        [self hideAllDropdownButtons];
    }
    else {
        [self pickupAndDeliveryButtonPressed: self.todayPickupButton];
    }
}

- (IBAction)expressButtonPressed:(id)sender
{
    self.fromExpressDelivery = YES;
    self.pickupMessageLabel.hidden = NO;
    if (self.expressDeliveryButton.isSelected) {
        return;
    }
    self.pickupSelectedDate = nil;
    self.deliverOnSelectedDate = nil;
    [self resetAllButtonsStates];
    [self hideAllDropdownButtons];
    
    
    
    
    [self.regularDeliveryButton setSelected: NO];
    [self.expressDeliveryButton setSelected: YES];
    
    
    [self setButtonStateIfSelected: self.todayPickupButton isSelected:YES withColor: [UIColor clearColor]];
    
    
    [self.deliveryDateContainerView setUserInteractionEnabled: NO];
    // [self.pickupDateContainerView setUserInteractionEnabled: NO];
    
    BOOL isTimeGreaterThan9AM = [self compareTimeIf6PMWithTimeToCompare:9];
    if (isTimeGreaterThan9AM) {
        [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
        self.todayPickupButton.enabled = NO;
        [self hideAllDropdownButtons];
    }
    else {
        [self pickupAndDeliveryButtonPressed: self.todayPickupButton];
    }
    
}

- (void)blockScreenContentForFalseOrder:(BOOL)block
{
    [self.pickupDateContainerView setUserInteractionEnabled: block];
    [self.deliveryDateContainerView setUserInteractionEnabled: block];
    
    
}
- (IBAction)pickupAndDeliveryButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self hideTableview];
    switch (button.tag) {
        case PIOOrderDayTodayPickUp: {
            
            dropdownButton = self.todayTimePickerButton;
            [self.todayTimePickerButton setTitle: @"00:00" forState:UIControlStateNormal];
            button = self.todayPickupButton;
            
            self.todayTimePickerButton.hidden = self.isFromExpressDelivery;
            self.tomorrowTimePickerButton.hidden = YES;
            self.otherdayTimePickerButton.hidden = YES;
            self.tomorrowDeliveryButton.enabled = YES;
            // Disable Morning slot if not available for Pickup
            
            [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.pickupSelectedDate = [self stringToDate: self.todayDateLabel.text];
            
            break;
        }
        case PIOOrderDayTomorrowPickUp: {
            [self.tomorrowTimePickerButton setTitle: @"00:00" forState:UIControlStateNormal];
            button = self.tomorrowPickupButton;
            dropdownButton = self.tomorrowTimePickerButton;
            self.tomorrowTimePickerButton.hidden = self.isFromExpressDelivery;
            self.todayTimePickerButton.hidden = YES;
            self.otherdayTimePickerButton.hidden = YES;
            
            self.tomorrowDeliveryButton.enabled = NO;
            
            [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            [self setButtonStateIfSelected: self.otherDayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
            
            self.pickupSelectedDate = [self stringToDate: self.tomorrowDateLabel.text];
            break;
        }
        case PIOOrderDayOtherDayPickUp: {
            
            // Date will be selected using calender
            
            dropdownButton = self.otherdayTimePickerButton;
            [self.otherdayTimePickerButton setTitle: @"00:00" forState:UIControlStateNormal];
            button = self.otherDayPickupButton;
            
            self.otherdayTimePickerButton.hidden = self.isFromExpressDelivery;
            self.tomorrowTimePickerButton.hidden = YES;
            self.todayTimePickerButton.hidden = YES;
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
            
            self.deliverOnSelectedDate = [self stringToDate: self.tomorrowDeliveryDateLabel.text];
            
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
    
    //    if (![self currentTimeForPickUpSlot: PIOTimeSlotMorning]) {
    //        [self setButtonStateIfSelected: button isSelected:YES withColor: [UIColor clearColor]];
    //
    //    }
    //    else {
    [self setButtonStateIfSelected: button isSelected:YES withColor: [UIColor clearColor]];
    //    }
}


- (IBAction)otherPickUpDateButtonPressed:(id)sender
{
    self.fromPickUp = YES;
    self.pickupSelectedDate = nil;
    NSDate *date = [NSDate new];
    if ((UIButton *)sender == self.otherDayPickupButton) {
        date = [NSDate dateWithTimeInterval:(24*60*60)*2 sinceDate: [NSDate new]];
    }
    [self showDatePickerWithMinDate: date];
}

- (IBAction)otherDeliveryDateButtonPressed:(id)sender
{
    self.fromPickUp = NO;
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate: self.pickupSelectedDate];
    [self showDatePickerWithMinDate: tomorrow ];
}

- (IBAction)continueButtonPressed:(id)sender
{
    if (self.regularDeliveryButton.isSelected) {
       
        if ([dropdownButton.titleLabel.text isEqualToString: @"00:00"]) {
           
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Pick-Up time." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            return;
        }
        else if ( self.pickupSelectedDate == nil)
        {
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Pick-Up day." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            return;
        }
        else if (self.deliverOnSelectedDate == nil)
        {
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Deliver On day." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            return;
        }
    }
    else if (self.expressDeliveryButton.isSelected) {
        
        if ( self.pickupSelectedDate == nil)
        {
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Pick-Up day." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            return;
        }
        
        self.deliverOnSelectedDate = self.pickupSelectedDate;
        
    }
    else {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message:@"Please select Regular or Express delivery category." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
        return;
    }
   
    if ([PIOAppController sharedInstance].accessToken) {
        NSString *pickupDateString = [self addTimeToDate: self.pickupSelectedDate time: timeString isOnlyDae: NO];
        NSString *deliverOnDateString = [self addTimeToDate: self.deliverOnSelectedDate time: nil isOnlyDae: YES];
        
        [PIOAppController sharedInstance].order.pickupTime = pickupDateString;
        [PIOAppController sharedInstance].order.deliveronTime = deliverOnDateString;
        
        PIOContactInfoViewController *contactInfoViewController = [PIOContactInfoViewController new];
        [self.navigationController pushViewController: contactInfoViewController animated: YES];
    }
    else {
        PIOLoginViewController *loginViewController = [PIOLoginViewController new];
        loginViewController.fromDemoScreen = NO;
        [self.navigationController pushViewController: loginViewController animated: YES];
    }
    
}

- (IBAction)dropdownButtonPressed:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    NSDate *date = [NSDate new];
    BOOL isToday = YES;
    
    if (button == self.tomorrowTimePickerButton) {
        
        date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate: [NSDate new]];
        isToday = NO;
    }
    else if (button == self.otherdayTimePickerButton) {
        date = [NSDate dateWithTimeInterval:(24*60*60)*2 sinceDate: [NSDate new]];
        isToday = NO;
    }
    
    
    slots = [self generateTimeSlotsForOrderWiOption: isToday withDate: date];
    
    
    [self.tableView reloadData];
    
    
    dropdownButton = button;
    self.tableView.frame = CGRectMake(button.frame.origin.x, self.pickupDateContainerView.frame.size.height+self.pickupDateContainerView.frame.origin.y, button.frame.size.width,0);
    
    CGRect frame = CGRectMake(button.frame.origin.x, self.pickupDateContainerView.frame.size.height+self.pickupDateContainerView.frame.origin.y, button.frame.size.width,0);
    NSInteger animation = UIViewAnimationOptionCurveEaseIn;
    
    if (!button.isSelected) {
        [self hideTableview];
        frame =  CGRectMake(button.frame.origin.x, self.pickupDateContainerView.frame.size.height+self.pickupDateContainerView.frame.origin.y, button.frame.size.width, 150);
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



#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    if (self.isFromPickUp) {
        self.pickupSelectedDate = date;
        [self.openCalendarTitleLabel setText: [self dateToDateString: date]];
    }
    else {
        self.deliverOnSelectedDate = date;
        [self.openCalendarDeliveryTitleLabel setText: [self dateToDateString: date]];
    }
    
}


#pragma mark - Private Methods

- (NSString *)addTimeToDate:(NSDate *)date time:(NSString *)time isOnlyDae:(BOOL)isOnlyDate
{
    NSDate *newDate;
    if (!isOnlyDate) {
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSArray *array = [time componentsSeparatedByString: @" "];
        
        array = [[array objectAtIndex: 0] componentsSeparatedByString: @":"];
        NSInteger hour = [[array objectAtIndex: 0] integerValue];
        if (hour <= 8) {
            hour = hour+12;
        }
        comps.hour   = hour;
        comps.minute = [[array objectAtIndex: 1]integerValue];
        comps.second = 00;
        newDate = [calendar dateFromComponents:comps];
    }
    else {
        newDate = date;
    }
    
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [outputDateFormatter stringFromDate:newDate];
}

- (BOOL)compareTimeIf6PMWithTimeToCompare:(NSInteger)time
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit ) fromDate:[NSDate date]];
    
    NSDate *todayCurrentTime = [calendar dateFromComponents:components];
    
    [components setHour:time];
    NSDate *todayAt6PM = [calendar dateFromComponents:components];
    
    NSComparisonResult result = [todayCurrentTime compare:todayAt6PM];
    
    if(result == NSOrderedDescending)
    {
        NSLog(@"date1 is later than date2");
        
        return YES;
        
    }
    else if(result == NSOrderedAscending)
    {
        NSLog(@"date2 is later than date1");
        return  NO;
    }
    else
    {
        
        NSLog(@"date1 is equal to date2");
        return  NO;
    }
    
    
}

- (NSMutableArray *)generateTimeSlotsForOrderWiOption:(BOOL)isToday withDate:(NSDate *)date
{
    NSMutableArray * timeSlots = [[NSMutableArray alloc] init];
    
    //  use gregorian calendar for calendrical calculations
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //  get current date
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    
    
    
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    units |= NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *currentComponents = [gregorian components:units fromDate:date];
    if (! isToday) {
        [currentComponents setHour:11];
        currentComponents.minute = 0;
    }
    
    NSDate* newDate = [gregorian dateFromComponents:currentComponents];
    
    //  format and display the time
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm aa";
    NSString *currentTimeString = [timeFormatter stringFromDate:newDate];
    NSLog(@"Current hour = %@",currentTimeString);
    if (!isToday) {
        [timeSlots addObject: currentTimeString];
    }
    
    NSInteger hour = [currentComponents hour];
    
    hour=hour%12;
    NSInteger count = 0;
    if ((8-hour>0)) {
        count = 8-hour;
    }
    else if (hour <= 11)
    {
        count = 10;
        currentComponents.minute = 0;
    }
    for (int i = 1; i<=count; i++) {
        //  add two hours
        NSDateComponents *incrementalComponents = [[NSDateComponents alloc] init];
        if (i ==1 && isToday) {
            incrementalComponents.hour = 2;
        }
        else {
            NSInteger increment = i+1;
            if (!isToday) {
                increment = i;
            }
            incrementalComponents.hour = increment ;
        }
        
        NSDate *twoHoursLater = [gregorian dateByAddingComponents:incrementalComponents toDate:newDate options:0];
        
        //  format and display new time
        NSString *twoHoursLaterStr = [timeFormatter stringFromDate:twoHoursLater];
        NSArray *array = [twoHoursLaterStr componentsSeparatedByString: @":"];
        NSString *amORpm = [[[array objectAtIndex: 1] componentsSeparatedByString: @" "] objectAtIndex: 1];
        if ([[array objectAtIndex:0] integerValue] == 8) {
            NSLog(@"Two hours later = 8:00 PM");
            [timeSlots addObject: @"08:00 PM"];
            break;
        }else if ([[array objectAtIndex:0] integerValue] == 9 && [amORpm isEqualToString: @"PM"] ) {
            break;
        }
        [timeSlots addObject: twoHoursLaterStr];
        NSLog(@"Two hours later = %@",twoHoursLaterStr);
    }
    
    
    return  timeSlots;
}

- (void)hideTableview
{
    self.tableView.hidden = YES;
    [dropdownButton setSelected: NO];
    
}


- (void)resetAllButtonsStates
{
    [self setButtonStateIfSelected: self.todayPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.tomorrowPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.otherDayPickupButton isSelected:NO withColor: [UIColor whiteColor]];
    
    [self setButtonStateIfSelected: self.todayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.tomorrowDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    [self setButtonStateIfSelected: self.otherDayDeliveryButton isSelected:NO withColor: [UIColor whiteColor]];
    
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
    
    self.pickupMessageLabel.hidden = YES;
    
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
    //    BOOL isExpressDeliveryAvailable = [self currentTimeForPickUpSlot: PIOTimeSlotMorning];
    //    [self.expressDeliveryButton setSelected: isExpressDeliveryAvailable];
    //    if (isExpressDeliveryAvailable) {
    //        [self.expressDeliveryButton setSelected: NO];
    //    }
    
//    [self regularButtonPressed: nil];
    BOOL isTimeGreaterThan6PM = [self compareTimeIf6PMWithTimeToCompare:18];
    if (isTimeGreaterThan6PM) {
        [self setButtonStateIfSelected: self.todayPickupButton isSelected: NO withColor:[UIColor whiteColor]];
        self.todayPickupButton.enabled = NO;
        
        
    }
    [self hideAllDropdownButtons];
//    else {
//        [self pickupAndDeliveryButtonPressed: self.todayPickupButton];
//    }
    
    
}

- (void)hideAllDropdownButtons
{
    self.todayTimePickerButton.hidden = YES;
    self.tomorrowTimePickerButton.hidden = YES;
    self.otherdayTimePickerButton.hidden = YES;
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
    
    [self.pickupMessageLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47f]];
    [self.deliverMessageLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.47f]];
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

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return slots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.detailTextLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.0]];
    [cell.detailTextLabel setText: [slots objectAtIndex: indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame  = CGRectMake(dropdownButton.frame.origin.x, self.pickupDateContainerView.frame.size.height+self.pickupDateContainerView.frame.origin.y, dropdownButton.frame.size.width,0);
    } completion:^(BOOL finished) {
        [dropdownButton setTitle: [slots objectAtIndex: indexPath.row] forState:UIControlStateNormal];
        [dropdownButton.titleLabel setText: [slots objectAtIndex: indexPath.row]];
        timeString = [slots objectAtIndex: indexPath.row];
        
        [self hideTableview];
        
        
        
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}


@end
