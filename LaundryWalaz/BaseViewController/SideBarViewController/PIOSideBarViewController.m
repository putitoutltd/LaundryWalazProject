//
//  PIOSideBarViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOSideBarViewController.h"
#import "PIOSideBarCustomTableViewCell.h"
#import "PIOPriceListViewController.h"
#import "PIOHowToUseViewController.h"
#import "PIOMapViewController.h"
#import "PIOAppController.h"
#import "CDRTranslucentSideBar.h"
#import "PIOConstants.h"

const NSInteger PIOLogOutButtonIndex = 0;

@interface PIOSideBarViewController ()
{
    UIViewController *visibleController;
    NSArray *controllers;
}
@property (nonatomic, weak) IBOutlet UITableView *dashboardTableView;

@end

@implementation PIOSideBarViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        CGRect tableViewRect = self.dashboardTableView.frame;
        tableViewRect.size.height = 7 * 42;
        self.dashboardTableView.frame = tableViewRect;
    self.dashboardTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.dashboardTableView setSeparatorInset:UIEdgeInsetsZero];
    self.view.frame = self.view.window.frame;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PIOHideSideBarView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBarView) name:@"PIOHideSideBarView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIOSideBarCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIOSideBarCustomTableViewCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PIOSideBarCustomTableViewCell" owner:self options:nil] objectAtIndex:0];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    }
    
    //    cell.iconImageView.image = [UIImage imageNamed:[self.dashboardImages objectAtIndex:indexPath.row]];
    
    cell.titleLabel.text = PIODashboardTitles[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *visibleViewController = [[PIOAppController sharedInstance] navigationController].visibleViewController;
    if ([visibleViewController isKindOfClass:[CDRTranslucentSideBar class]]) {
        CDRTranslucentSideBar *bar = (CDRTranslucentSideBar *)visibleViewController;
        [bar dismissAnimated:YES];
        [visibleViewController removeFromParentViewController];
    }
    
    NSArray *viewControllers = [[PIOAppController sharedInstance] navigationController].viewControllers;
    visibleViewController = [viewControllers objectAtIndex:[viewControllers count]-1];
    
    switch (indexPath.row) {
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
        default:
            break;
            
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
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
