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
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Order Status" onViewController:self];
    self.backgroundImageView.image = [UIImage imageForDeviceWithName: @"status-01"];
    //[self.backgroundImageView setContentMode: UIViewContentModeScaleAspectFit];
   //
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pickupTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 31.06f]];
    [self.timeLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.46f]];
    [self.dayLabel setFont: [UIFont PIOMyriadProLightWithSize: 12.04f]];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
