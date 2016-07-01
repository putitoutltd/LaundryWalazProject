//
//  PIOBaseViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOBaseViewController.h"
#import "CDRTranslucentSideBar.h"
#import "PIOSideBarViewController.h"
#import "PIOAppController.h"

@interface PIOBaseViewController () <CDRTranslucentSideBarDelegate>
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@end

@implementation PIOBaseViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self applyImageBackgroundToTheNavigationBar];
    [self configureNavigationBar];
   
   
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:226.0/255.0 green: 243.0/255.0 blue:255.0/255.0 alpha: 1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureNavigationBar
{
    UIImage *backgroundImageForDefaultBarMetrics = [UIImage imageNamed:@"pio-navigation-bar-background"];
    
   
    CGFloat navBarHeight = backgroundImageForDefaultBarMetrics.size.height-5;
    CGRect frame = CGRectMake(0.0f, 0.0f, backgroundImageForDefaultBarMetrics.size.width, navBarHeight);
    [self.navigationController.navigationBar setFrame:frame];
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"pio-navigation-menu-button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(sideBarButtonPressed:)];
    self.navigationItem.leftBarButtonItems = @[menuBarButtonItem];
  
}

- (void)applyImageBackgroundToTheNavigationBar
{
    // These background images contain a small pattern which is displayed
    // in the lower right corner of the navigation bar.
    UIImage *backgroundImageForDefaultBarMetrics = [UIImage imageNamed:@"pio-navigation-bar-background"];
    
    // Both of the above images are smaller than the navigation bar's
    // size.  To enable the images to resize gracefully while keeping their
    // content pinned to the bottom right corner of the bar, the images are
    // converted into resizable images width edge insets extending from the
    // bottom up to the second row of pixels from the top, and from the
    // right over to the second column of pixels from the left.  This results
    // in the topmost and leftmost pixels being stretched when the images
    // are resized.  Not coincidentally, the pixels in these rows/columns
    // are empty.
    backgroundImageForDefaultBarMetrics = [backgroundImageForDefaultBarMetrics resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, backgroundImageForDefaultBarMetrics.size.height-1, backgroundImageForDefaultBarMetrics.size.width-1)];
    
    // You should use the appearance proxy to customize the appearance of
    // UIKit elements.  However changes made to an element's appearance
    // proxy do not effect any existing instances of that element currently
    // in the view hierarchy.  Normally this is not an issue because you
    // will likely be performing your appearance customizations in
    // -application:didFinishLaunchingWithOptions:.  However, this example
    // allows you to toggle between appearances at runtime which necessitates
    // applying appearance customizations directly to the navigation bar.
    /* id navigationBarAppearance = [UINavigationBar appearanceWhenContainedIn:[NavigationController class], nil]; */
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    // The bar metrics associated with a background image determine when it
    // is used.  The background image associated with the Default bar metrics
    // is used when a more suitable background image can not be found.
    [navigationBarAppearance setBackgroundImage:backgroundImageForDefaultBarMetrics forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setOpaque:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - IBActions

- (void)sideBarButtonPressed:(id)sender
{
    
   
    self.sideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight: NO];
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


@end
