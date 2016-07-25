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

@interface PIOPriceListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation PIOPriceListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Hide Back button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.backButtonHide = YES;
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Pricing" onViewController:self];
    
    self.headerTitles = [NSMutableArray arrayWithObjects: @"MEN’S WEAR CLOTHING", @"WOMEN’S WEAR CLOTHING", @"BED LINEN", nil];
    self.headerImages = [NSMutableArray arrayWithObjects: @"menz-wears", @"womenz-wears", @"bed-linen", nil];
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


#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return  3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 20+1;
            break;
            
        case 1:
            rows = 20;
            break;
            
        case 2:
            rows = 20;
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
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return cell;
        }
    }
    else if (indexPath.row ==1)
    {
        
    }
    else {
        
    }
    
    [cell.itemLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    [cell.dryCleanLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    [cell.laundryLabel setFont: [UIFont PIOMyriadProLightWithSize: 8.38]];
    
    
    cell.cellBackgroundView.backgroundColor = [UIColor clearColor];
    [cell.itemLabel setText: @"Suit 2PC Linen"];
    [cell.dryCleanLabel setText: @"280"];
    [cell. laundryLabel setText: @"280"];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}



@end
