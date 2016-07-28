//
//  PIOPricingList.m
//  LaundryWalaz
//
//  Created by pito on 7/28/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOPricingList.h"

@implementation PIOPricingList

- (instancetype)initWithInitialParameters:(NSString *)category name:(NSString *)name priceDryclean:(NSString *)priceDryclean priceLaundry:(NSString *)priceLaundry
{
    if ((self = [super init])) {
        self.category = category;
        self.name = name;
        self.priceDryclean = priceDryclean;
        self.priceLaundry = priceLaundry;
    }
    return  self;
}

@end
