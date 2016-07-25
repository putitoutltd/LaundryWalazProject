//
//  PIOChangePositionOfTextFields.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOChangePositionOfTextFields.h"

@implementation PIOChangePositionOfTextFields
const NSInteger PIOXDistanceForText = 15;
const NSInteger PIOTagForResetFields = 100;

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds = CGRectMake(bounds.origin.x-PIOXDistanceForText, bounds.origin.y, bounds.size.width, bounds.size.height);
    return CGRectInset( bounds ,26, (26 - self.font.pointSize - 4)/2);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds = CGRectMake(bounds.origin.x-PIOXDistanceForText, bounds.origin.y, bounds.size.width, bounds.size.height);
    return CGRectInset( bounds , 26, (26 - self.font.pointSize - 4)/2);
}

@end
