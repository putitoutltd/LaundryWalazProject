//
//  PIOPriceListViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/30/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOPriceListViewController.h"
#import "PIOPriceListCustomTableViewCell.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOOrder.h"
#import "PIOPricingList.h"

@interface PIOPriceListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PIOOrder *order;
@property (nonatomic, strong) NSMutableArray *priceList;

@end

@implementation PIOPriceListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.isFromFAQs) {
        // Hide Back button
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem=nil;
        self.backButtonHide = YES;
    }
   
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Pricing" onViewController:self];
    
    self.headerTitles = [NSMutableArray arrayWithObjects: @"Men’s Apparel", @"Woman’s Apparel", @"Bed Linen", @"Other Items", nil];
    self.headerImages = [NSMutableArray arrayWithObjects: @"menz-wears", @"womenz-wears", @"bed-linen", @"others-icon (2)", nil];
    [self pricingListAPICall];
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

#pragma  mark - Private Methods

- (void)pricingListAPICall
{
    if ([[PIOAppController sharedInstance] connectedToNetwork]) {
        [[PIOAppController sharedInstance] showActivityViewWithMessage: @""];
        [PIOOrder pricingListCallback:^(NSError *error, BOOL status, id responseObject) {
            [[PIOAppController sharedInstance] hideActivityView];
            if (status) {
                self.order = (PIOOrder *)responseObject;
                [self.tableView reloadData];
            
            }
            else {
                PIOAPIResponse * APIResponse = (PIOAPIResponse *) responseObject;
                [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: APIResponse.message withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            }
            
        }];
    }
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return  4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = self.order.menApparelList.count+1;
            break;
            
        case 1:
            rows = self.order.womenApparelList.count;
            break;
            
        case 2:
            rows = self.order.bedLinenList.count;
            break;
       
        case 3:
            rows = self.order.otherItems.count;
            break;

            
        default:
            break;
    }
       return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIOPriceListCustomTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Price"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PIOPriceListCustomTableViewCell" owner:self options:nil] objectAtIndex:0];
//        [cell drawCellForMother:self.mother];
    }
    NSInteger row;
    if (indexPath.section == 0) {
        self.priceList = self.order.menApparelList;
        if (indexPath.row==0) {
            return cell;
        }
        row = indexPath.row-1;
    }
    else if (indexPath.section ==1)
    {
        self.priceList = self.order.womenApparelList;
        row = indexPath.row;
    }
    else if (indexPath.section ==2) {
        self.priceList = self.order.bedLinenList;
        row = indexPath.row;
    }
    else if (indexPath.section ==3) {
        self.priceList = self.order.otherItems;
        row = indexPath.row;
    }
    
    PIOPricingList *pricingListObj = [self.priceList objectAtIndex: row];
    [cell.itemLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    [cell.dryCleanLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    [cell.laundryLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    
    cell.cellBackgroundView.backgroundColor = [UIColor clearColor];
    [cell.itemLabel setText: pricingListObj.name];
    [cell.dryCleanLabel setText: pricingListObj.priceDryclean];
    [cell. laundryLabel setText: pricingListObj.priceLaundry];
    
    return cell;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 48)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(16, 8, 37, 37)];
    imageView.image = [UIImage imageNamed: [self.headerImages objectAtIndex: section]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(58, 18, 300, 20)];
    [titleLabel setText: [self.headerTitles objectAtIndex: section]];
    [titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 16.0f]];
    
    [headerView addSubview: imageView];
    [headerView addSubview: titleLabel];
    return  headerView;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 3) {
        UIView *headerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 30)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(58, 6, 300, 20)];
        [titleLabel setText: @"All prices are exclusive of any applicable taxes"];
        [titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 15.0f]];
        titleLabel.textColor = [UIColor redColor];
        [headerView addSubview: titleLabel];
        return  headerView;
    }
    
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}



@end
