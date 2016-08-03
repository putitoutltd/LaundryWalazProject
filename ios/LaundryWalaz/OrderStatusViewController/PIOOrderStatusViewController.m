//
//  PIOOrderStatusViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/20/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrderStatusViewController.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOOrder.h"

@interface PIOOrderStatusViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *pickupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation PIOOrderStatusViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PIORefreshStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshStatus) name:@"PIORefreshStatus" object:nil];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Order Status" onViewController:self];
    self.backgroundImageView.image = [UIImage imageForDeviceWithName: @"status-01"];
    //[self.backgroundImageView setContentMode: UIViewContentModeScaleAspectFit];
   //
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pickupTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.46f]];
    [self.timeLabel setFont: [UIFont PIOMyriadProLightWithSize: 31.06f]];
    [self.dayLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.04f]];
    
    [self.pickupTitleLabel setText: @""];
    [self.timeLabel setText: @""];
    [self.dayLabel setText: @""];
    self.backgroundImageView.image = nil;
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self orderStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Private Methods

- (void)refreshStatus
{
    [self orderStatus];
}

- (void)orderStatus
{
    if ([[PIOAppController sharedInstance] connectedToNetwork]) {
        [[PIOAppController sharedInstance] showActivityViewWithMessage: @""];
        [PIOOrder orderStatusCallback:^(NSError *error, BOOL status, id responseObject) {
            [[PIOAppController sharedInstance] hideActivityView];
            if (status) {
                [self.pickupTitleLabel setText: @"Delivery at"];
                NSString *status = (NSString *)responseObject;
                UIImage *backgroundImage = nil;
                switch ( [status integerValue]) {
                    case 0:
                    {
                        backgroundImage = [UIImage imageForDeviceWithName: @"status-01"];
                        [self dateToDateString: [PIOAppController sharedInstance].LoggedinUser.pickupTime];
                        [self.pickupTitleLabel setText: @"Pick-Up at"];
                        break;
                    }
                    case 1:
                    {
                        backgroundImage = [UIImage imageForDeviceWithName: @"status-02"];
                        [self dateToDateString: [PIOAppController sharedInstance].LoggedinUser.deliveronTime];
                        break;
                    }
                    case 2:
                    {
                        backgroundImage = [UIImage imageForDeviceWithName: @"status-03"];
                        [self dateToDateString: [PIOAppController sharedInstance].LoggedinUser.deliveronTime];
                        break;
                    }
                    case 3:
                    {
                        backgroundImage = [UIImage imageForDeviceWithName: @"status-04"];
                        [self dateToDateString: [PIOAppController sharedInstance].LoggedinUser.deliveronTime];
                        break;
                    }
                    case 4:
                    {
                        [self.pickupTitleLabel setText: @"Delivered at"];
                        backgroundImage = [UIImage imageForDeviceWithName: @"status-05"];
                        [self dateToDateString: [PIOAppController sharedInstance].LoggedinUser.deliveronTime];
                        break;
                    }
                        
                    default:
                        break;
                }
                self.backgroundImageView.image = backgroundImage;
                
                
            }
            else {
                PIOAPIResponse * APIResponse = (PIOAPIResponse *) responseObject;
                [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: APIResponse.message withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            }
        }];
    }
}


- (void)dateToDateString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *dateStr = [dateFormatter stringFromDate: date];
    NSDate *dddddd = [dateFormatter dateFromString:dateStr];
    
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init] ;
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [monthDayFormatter setDateFormat:@"EEEE MMMM, dd"];
    NSString *day = [monthDayFormatter stringFromDate:dddddd] ;
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    [monthDayFormatter setTimeZone: outputTimeZone];
    [monthDayFormatter setDateFormat:@"hh:mm a"];
    NSString *time = [monthDayFormatter stringFromDate:dddddd];
    
    self.dayLabel.text = day;
    self.timeLabel.text = time;
    
}

@end
