//
//  UIFont+Additions.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)PIOSystemWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"System" size:0.0];
}

+ (UIFont *)PIOMyriadProRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}


@end
