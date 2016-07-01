//
//  PIOHowToUseViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOHowToUseViewController.h"
#import "PIOLoginViewController.h"
#import "PIOMapViewController.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "PIOAppController.h"

@interface PIOHowToUseViewController ()

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (weak, nonatomic) IBOutlet UIButton *pickupButton;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation PIOHowToUseViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    PIOLoginViewController *loginViewController = [PIOLoginViewController new];
    [self.navigationController pushViewController: loginViewController animated: YES];
}

- (IBAction)startNowButtonPressed:(id)sender
{
    PIOMapViewController *mapViewController = [PIOMapViewController new];
    [self.navigationController pushViewController: mapViewController animated: YES];
}

#pragma mark - Private Methods

- (void)initializeView
{
    self.swipeView.pagingEnabled = YES;
    self.items = [NSMutableArray array];
    [self.items addObject: @"first-slide"];
    [self.items addObject: @"second-slide"];
    [self.items addObject: @"third-slide"];
    
    [self.pickupButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.pickupButton setBackgroundImage: [UIImage imageForDeviceWithName: @"pick-up"] forState: UIControlStateNormal];
}

#pragma mark - Public Methods

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    
    //don't do anything specific to the index within
    //this `if (view == nil) {...}` statement because the view will be
    //recycled and used with other index values later
    view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame: view.frame];
    imageView.image = [UIImage imageForDeviceWithName: [self.items objectAtIndex: index]];
    [imageView setContentMode: UIViewContentModeScaleAspectFit];
    imageView.autoresizingMask = view.autoresizingMask;
    [view addSubview:imageView];
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}
@end
