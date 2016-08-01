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
#import "CDRTranslucentSideBar.h"
#import "PIOSideBarViewController.h"

@interface PIOHowToUseViewController () <CDRTranslucentSideBarDelegate>
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, weak) IBOutlet UIButton *pickupButton;
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
    if ([PIOAppController sharedInstance].accessToken != nil) {
        self.loginButton.hidden = YES;
        self.pickupButton.hidden = YES;
    }
    else {
        [self refreshScreenContent];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)crossButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated: NO];
}

- (IBAction)loginButtonPressed:(id)sender
{
    PIOLoginViewController *loginViewController = [PIOLoginViewController new];
    loginViewController.fromDemoScreen = YES;
    [self.navigationController pushViewController: loginViewController animated: YES];
}

- (IBAction)startNowButtonPressed:(id)sender
{
    PIOMapViewController *mapViewController = [PIOMapViewController new];
    mapViewController.fromDemoScreen = YES;
    [self.navigationController pushViewController: mapViewController animated: YES];
}


- (IBAction)sideBarButtonPressed:(id)sender
{
    self.sideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight: YES];
    self.sideBar.delegate = self;
    PIOSideBarViewController *sideBarViewController = [PIOSideBarViewController new];
    [[[PIOAppController sharedInstance] navigationController].visibleViewController addChildViewController:sideBarViewController];
    self.sideBar.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
    sideBarViewController.view.frame = self.sideBar.view.frame;
    //    self.sideBar.translucentStyle = UIBarStyleBlack;
    // Set ContentView in SideBar
    self.sideBar.sideBarWidth = self.view.window.frame.size.width;
    [self.sideBar setContentViewInSideBar:sideBarViewController.view];
    [self.sideBar show];
}

#pragma mark - Private Methods

- (void)initializeView
{
    self.swipeView.pagingEnabled = YES;
    self.items = [NSMutableArray array];
    [self.items addObject: @"first-slide"];
    [self.items addObject: @"second-slide"];
    [self.items addObject: @"third-slide"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PIORefreshHowToUseScreen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshScreenContent) name:@"PIORefreshHowToUseScreen" object:nil];
    
    [self.pickupButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.loginButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.pickupButton setBackgroundImage: [UIImage imageForDeviceWithName: @"pick-up"] forState: UIControlStateNormal];
}

- (void)refreshScreenContent
{
    self.loginButton.hidden = NO;
    self.pickupButton.hidden = NO;
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
