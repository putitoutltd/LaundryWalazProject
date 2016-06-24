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
    [self configureNavigationBar];
   
    
     self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureNavigationBar
{
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"pio-navigation-menu-button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(sideBarButtonPressed:)];
    self.navigationItem.leftBarButtonItems = @[menuBarButtonItem];
  
}

#pragma mark - IBActions

- (void)sideBarButtonPressed:(id)sender
{
    
   
    self.sideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight: NO];
    self.sideBar.delegate = self;
    PIOSideBarViewController *sideBarViewController = [PIOSideBarViewController new];
    [[[PIOAppController sharedInstance] navigationController].visibleViewController addChildViewController:sideBarViewController];
    self.sideBar.view.frame = CGRectMake(0, 0, 232, self.view.window.frame.size.height);
    sideBarViewController.view.frame = self.sideBar.view.frame;
//    self.sideBar.translucentStyle = UIBarStyleBlack;
    // Set ContentView in SideBar
    [self.sideBar setContentViewInSideBar:sideBarViewController.view];
    
    [self.sideBar show];
}


@end
