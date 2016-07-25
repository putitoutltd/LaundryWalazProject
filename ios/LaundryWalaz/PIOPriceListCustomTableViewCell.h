//
//  PIOPriceListCustomTableViewCell.h
//  LaundryWalaz
//
//  Created by pito on 7/20/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIOPriceListCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *dryCleanLabel;
@property (weak, nonatomic) IBOutlet UILabel *laundryLabel;

@end
