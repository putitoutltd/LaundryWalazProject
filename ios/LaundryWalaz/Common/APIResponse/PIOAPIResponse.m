//
//  PIOAPIResponse.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

//

#import "PIOAPIResponse.h"
#import "PIOConstants.h"

@implementation PIOAPIResponse

- (instancetype)initWithDict:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        self.data = dictionary[@"data"];
        self.message = dictionary[@"message"];
        self.status = dictionary[@"status"];
    }
    return self;
}

@end
