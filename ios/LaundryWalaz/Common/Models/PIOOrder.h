//
//  PIOOrder.h
//  LaundryWalaz
//
//  Created by pito on 7/26/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIOUser.h"

@interface PIOOrder : NSObject

@property (nonatomic, strong) PIOUser *customer;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *pickupTime;
@property (nonatomic, strong) NSString *deliveronTime;
@property (nonatomic, strong) NSString *specialInstructions;

- (instancetype)initWithInitialParameters:(NSString *)address location:(NSString *)location;
@end
