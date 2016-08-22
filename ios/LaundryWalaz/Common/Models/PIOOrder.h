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

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) PIOUser *customer;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *pickupTime;
@property (nonatomic, strong) NSString *deliveronTime;
@property (nonatomic, strong) NSString *specialInstructions;
@property (nonatomic, strong) NSMutableArray *bedLinenList;
@property (nonatomic, strong) NSMutableArray *womenApparelList;
@property (nonatomic, strong) NSMutableArray *menApparelList;
@property (nonatomic, strong) NSMutableArray *otherItems;


- (instancetype)initWithInitialParameters:(NSString *)address location:(NSString *)location;

// Create Order API Call
+ (void)createOrder:(PIOOrder *)order callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

// Order Status API Call
+ (void)orderStatusCallback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

// Prcing List API Call
+ (void)pricingListCallback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

@end
