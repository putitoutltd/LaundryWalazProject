//
//  PIOSideBarViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOSideBarViewController.h"

#import "PIOPriceListViewController.h"
#import "PIOHowToUseViewController.h"
#import "PIOMapViewController.h"
#import "PIOAppController.h"
#import "CDRTranslucentSideBar.h"
#import "PIOFeedbackViewController.h"
#import "PIOConstants.h"

const NSInteger PIOLogOutButtonIndex = 0;

@interface PIOSideBarViewController ()
{
    UIViewController *visibleController;
    NSArray *controllers;
}

@property (weak, nonatomic) IBOutlet UIButton *TermsButton;
@property (weak, nonatomic) IBOutlet UIButton *faqButton;
@property (weak, nonatomic) IBOutlet UIImageView *menuBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;
@property (weak, nonatomic) IBOutlet UIButton *myOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *priceListButton;
@property (weak, nonatomic) IBOutlet UIButton *howItWorksButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end

@implementation PIOSideBarViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = self.view.window.frame;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PIOHideSideBarView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBarView) name:@"PIOHideSideBarView" object:nil];
    [self.pickUpButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.myOrderButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.priceListButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.howItWorksButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.logOutButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.feedbackButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    [self.faqButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.0f]];
    [self.TermsButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 13.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    UIViewController *visibleViewController = [[PIOAppController sharedInstance] navigationController].visibleViewController;
    if ([visibleViewController isKindOfClass:[CDRTranslucentSideBar class]]) {
        CDRTranslucentSideBar *bar = (CDRTranslucentSideBar *)visibleViewController;
        [bar dismissAnimated:YES];
        [visibleViewController removeFromParentViewController];
    }
    
    NSArray *viewControllers = [[PIOAppController sharedInstance] navigationController].viewControllers;
    visibleViewController = [viewControllers objectAtIndex:[viewControllers count]-1];
    
    switch (button.tag) {
        case PIODashboardRowTypeLogout: {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Are you sure you want to log out?"
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Log Out"
                                          otherButtonTitles: nil];
            [actionSheet showInView:[PIOAppController sharedInstance].navigationController.view];
            visibleController = visibleViewController;
            controllers = viewControllers;
            
            break;
        }
        case PIODashboardRowTypeHowItWorks: {
            break;
        }
        case PIODashboardRowTypeOrder: {
            
            if (![visibleViewController isKindOfClass:[PIOMapViewController class]] ) {
                
                PIOMapViewController *orderViewController;
                for (UIViewController *viewController in viewControllers) {
                    if ([viewController isKindOfClass:[PIOMapViewController class]]) {
                        orderViewController = (PIOMapViewController *)viewController;
                        break;
                    }
                }
                if (orderViewController == nil) {
                    orderViewController = [PIOMapViewController new];
                    [[[PIOAppController sharedInstance] navigationController] pushViewController: orderViewController animated:NO];
                } else {
                    
                    [[[PIOAppController sharedInstance] navigationController] popToViewController: orderViewController animated:NO];
                }
            }
            
            break;
        }
        case PIODashboardRowTypePricing: {
            
            if (![visibleViewController isKindOfClass:[PIOPriceListViewController class]] ) {
                
                PIOPriceListViewController *priceListViewController;
                for (UIViewController *viewController in viewControllers) {
                    if ([viewController isKindOfClass:[PIOPriceListViewController class]]) {
                        priceListViewController = (PIOPriceListViewController *)viewController;
                        break;
                    }
                }
                if (priceListViewController == nil) {
                    priceListViewController = [PIOPriceListViewController new];
                    [[[PIOAppController sharedInstance] navigationController] pushViewController: priceListViewController animated:NO];
                } else {
                    
                    [[[PIOAppController sharedInstance] navigationController] popToViewController: priceListViewController animated:NO];
                }
            }
            
            break;
        }
        case PIODashboardRowTypeFAQs: {
            break;
        }
        case PIODashboardRowTypeTerms: {
            break;
        }
        case PIODashboardRowTypeFeedback: {
            
            if (![visibleViewController isKindOfClass:[PIOFeedbackViewController class]] ) {
                
                PIOFeedbackViewController *feedbackViewController;
                for (UIViewController *viewController in viewControllers) {
                    if ([viewController isKindOfClass:[PIOFeedbackViewController class]]) {
                        feedbackViewController = (PIOFeedbackViewController *)viewController;
                        break;
                    }
                }
                if (feedbackViewController == nil) {
                    feedbackViewController = [PIOFeedbackViewController new];
                    [[[PIOAppController sharedInstance] navigationController] pushViewController: feedbackViewController animated:NO];
                } else {
                    
                    [[[PIOAppController sharedInstance] navigationController] popToViewController: feedbackViewController animated:NO];
                }
            }
            break;
        }
        default:
            break;
            
    }
    
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == PIOLogOutButtonIndex) {
        [self callLogoutAPI];
    }
}

- (void)callLogoutAPI
{
    [self flushDataOnLogout: visibleController withViewControllerArray:controllers];
    
}

- (void)flushDataOnLogout:(UIViewController *)visibleViewController withViewControllerArray:(NSArray *)viewControllers
{
    
    if (![visibleViewController isKindOfClass:[PIOHowToUseViewController class]]) {
        PIOHowToUseViewController *loginViewController;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[PIOHowToUseViewController class]]) {
                loginViewController = (PIOHowToUseViewController *)viewController;
                break;
            }
        }
        
        if (loginViewController == nil) {
            loginViewController = [PIOHowToUseViewController new];
            [[PIOAppController sharedInstance].navigationController pushViewController:loginViewController animated:NO];
        }else{
            
            [[PIOAppController sharedInstance].navigationController popToViewController:loginViewController animated:NO];
        }
        
    }
    
    
}

- (void)hideBarView
{
    UIViewController *visibleViewController = [[PIOAppController sharedInstance] navigationController].visibleViewController;
    if ([visibleViewController isKindOfClass:[CDRTranslucentSideBar class]]) {
        CDRTranslucentSideBar *bar = (CDRTranslucentSideBar *)visibleViewController;
        [bar dismissAnimated:YES];
        [visibleViewController removeFromParentViewController];
    }
}
- (IBAction)crossButtonPressed:(id)sender
{
    [self hideBarView];
}

@end
