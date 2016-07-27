//
//  PIOOrder.m
//  LaundryWalaz
//
//  Created by pito on 7/26/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrder.h"

@implementation PIOOrder

- (instancetype)initWithInitialParameters:(NSString *)address location:(NSString *)location
{
    if ((self = [super init])) {
        self.location = location;
        self.address = address;
    }
    return  self;
}

@end
