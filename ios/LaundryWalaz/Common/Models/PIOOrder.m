//
//  PIOOrder.m
//  LaundryWalaz
//
//  Created by pito on 7/26/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOOrder.h"
#import "PIOURLManager.h"
#import "PIORequestHandler.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"

@implementation PIOOrder

- (instancetype)initWithInitialParameters:(NSString *)address location:(NSString *)location
{
    if ((self = [super init])) {
        self.location = location;
        self.address = address;
    }
    return  self;
}

+ (NSDictionary *)convertUserObjectToDictionary:(PIOOrder *)order
{
    NSDictionary * userDictionary ;
    
    userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      order.customer.firstName, @"first_name",
                      order.customer.lastName, @"last_name",
                      order.customer.email, @"email",
                      order.customer.phone, @"phone",
                      order.location, @"location_id",
                      order.address, @"address",
                      [PIOAppController sharedInstance].accessToken, @"access_token",
                      order.pickupTime, @"pickup_time",
                      order.deliveronTime, @"dropoff_time",
                      order.specialInstructions, @"special_instructions",
                      nil];
    
    
    
    return userDictionary;
}

// Create Order API Call
+ (void)createOrder:(PIOOrder *)order callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager createorderURL];
    NSDictionary *parameters =  [self convertUserObjectToDictionary: order];
    
    [PIORequestHandler postRequest: requestURL parameters: parameters callback:^(NSError *error, BOOL status, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        if (error == nil && !status) {
            if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
                PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
                
                callback(nil,NO, APIResponse);
            }
        }
        else if (status) {
            
            if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
               
                NSString *orderID = dictionary[@"data"][@"order_id"];
                callback(error, YES, orderID);
                
            }
            else {
                callback(error, NO, nil);
            }
        }
        
    }];
}

// Order Status API Call
+ (void)orderStatusCallback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager orderStatusURL];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys: [PIOAppController sharedInstance].accessToken, @"access_token", nil];
    
    [PIORequestHandler postRequest: requestURL parameters: parameters callback:^(NSError *error, BOOL status, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        if (error == nil && !status) {
            if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
                PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
                
                callback(nil,NO, APIResponse);
            }
        }
        else if (status) {
            
            if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
                NSString *status = dictionary[@"data"][@"order"][@"status"];
                
                [PIOAppController sharedInstance].LoggedinUser.pickupTime = dictionary[@"data"][@"order"][@"pickup_time"];
                [PIOAppController sharedInstance].LoggedinUser.deliveronTime = dictionary[@"data"][@"order"][@"dropoff_time"];
                
                callback(error, YES, status);
            }
            else {
                callback(error, NO, nil);
            }
        }
        
    }];
}

@end
