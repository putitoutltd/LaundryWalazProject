//
//  PIOUser.m
//  LaundryWalaz
//
//  Created by pito on 7/25/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOUser.h"
#import "PIOURLManager.h"
#import "PIORequestHandler.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"


@implementation PIOUser

- (instancetype)initWithParametersFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password phone:(NSString *)phone address:(NSString *)address locationID:(NSString *)locationID
{
    if ((self = [super init])) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email  = email;
        self.password = password;
        self.phone = phone;
    }
    return  self;
}

+ (NSDictionary *)convertUserObjectToDictionary:(PIOUser *)user
{
    NSDictionary * userDictionary ;
    
        userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          user.firstName, @"first_name",
                          user.lastName, @"last_name",
                          user.email, @"email",
                          user.password, @"password",
                          user.phone, @"phone",
                          nil];
    
    
    
    return userDictionary;
}

+ (void)userRegistration:(PIOUser *)user callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager userRegisterURL];
    NSDictionary *parameters =  [self convertUserObjectToDictionary:user];
    
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
                
                
                PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
                callback(nil,YES, APIResponse);
                
            } else {
                callback(error, NO, nil);
            }
        }
        
    }];
}

@end
