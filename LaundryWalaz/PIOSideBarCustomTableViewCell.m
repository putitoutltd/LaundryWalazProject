//
//  PIOSideBarCustomTableViewCell.m
//  Kidlr
//
//  Created by pito on 8/21/15.
//  Copyright (c) 2015 Putitout. All rights reserved.
//

#import "PIOSideBarCustomTableViewCell.h"

@implementation PIOSideBarCustomTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
 //   self.titleLabel.textColor = [UIColor blackColor];
//    self.titleLabel.font = [UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
