//
//  PIOOrderSummaryViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/19/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrderSummaryViewController.h"
#import "PIOAppController.h"

@interface PIOOrderSummaryViewController ()

@property (nonatomic, weak) IBOutlet UILabel *orderConfirmationTitleLabel;
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
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Summary" onViewController:self];
    
    [self applyFonts];
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

#pragma mark - Private Methods

- (void)applyFonts
{
    [self.orderConfirmationTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.7f]];
    [self.orderPlacedTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.orderIDTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 6.75f]];
    [self.orderIDLabel setFont: [UIFont PIOMyriadProLightWithSize: 11.25f]];
    [self.pickUpDateTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 6.75f]];
    [self.pickUpDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 11.25f]];
    [self.deliveryDateTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 6.75f]];
    [self.deliverDateLabel setFont: [UIFont PIOMyriadProLightWithSize: 11.25f]];
    [self.AddressTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 6.75f]];
    [self.orderConfirmationTitleLabel setFont: [UIFont PIOMyriadProLightWithSize: 11.25f]];
    [self.cancelButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.65f]];
    [self.orderStatusButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.65f]];
    
}

@end