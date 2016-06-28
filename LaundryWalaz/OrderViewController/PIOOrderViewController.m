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

@interface PIOOrderViewController () <IQActionSheetPickerViewDelegate>

@property (nonatomic, assign, getter=isFromPickUp) BOOL fromPickUp;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *regularDeliveryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressDeliveryButton;
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
    NSDate *today = [NSDate new];
    NSString *todayDateString = [self dateToDateString: today];
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate: today];
    NSString *tomorrowDateString = [self dateToDateString: tomorrow];
    
    [self.todayDateLabel setText: todayDateString];
    [self.tomorrowDateLabel setText: tomorrowDateString];
    
    [self.todayDeliveryDateLabel setText: todayDateString];
    [self.tomorrowDeliveryDateLabel setText: tomorrowDateString];
    
    
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

@end
