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

- (instancetype)initWithParametersID:(NSString *)ID firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password phone:(NSString *)phone address:(NSString *)address locationID:(NSString *)locationID
{
    if ((self = [super init])) {
        self.ID = ID;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email  = email;
        self.password = password;
        self.phone = phone;
        self.locationID = locationID;
    }
    return  self;
}

- (instancetype)initWithDict:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        self.ID = dictionary[@"id"];
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.email  = dictionary[@"email"];
        self.password = dictionary[@""];
        self.phone = dictionary[@"phone"];
        self.locationID = dictionary[@"locations_id"];
        self.address = dictionary[@"address"];
    }
    return self;
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
                      user.locationID, @"location_id",
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
               
                // User Registered Successfully with given Email Address
                if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusSuccess]) {
                    
                    callback(nil,YES, @"You have been registered successfully.");
                }
            } else {
                callback(error, NO, nil);
            }
        }
        
    }];
}


+ (void)userLogin:(PIOUser *)user callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager userLoginURL];
    NSDictionary *parameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
    user.email, @"email",
    user.password, @"password", nil];
    
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
               
                // If Remember Me check is enabled Access Token will be saved
                if ([PIOAppController sharedInstance].isRemeberMe) {
                    [PIOUserPref setAccessToken:dictionary[@"data"][@"access_token"]];
                }
                else {
                      [PIOUser saveInfoForFuture: NO user: nil];
                }
                
                // Save Access Token temporary. If required in any API
                [PIOAppController sharedInstance].accessToken = dictionary[@"data"][@"access_token"];
                
                PIOUser *user = [[PIOUser alloc]initWithDict: dictionary[@"data"][@"details"]];
                [PIOAppController sharedInstance].LoggedinUser = user;
                // If Remember Me check is enabled. Save user info for future
                if ([PIOAppController sharedInstance].isRemeberMe) {
                    [PIOUser saveInfoForFuture: YES user: user];
                }
                
                callback(nil, YES, user);
            } else {
                callback(error, NO, nil);
            }
        }
        
    }];
}



+ (void)forgotPassword:(NSString *)email callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager forgotPasswordURL];
    NSDictionary *parameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                 email, @"email", nil];
    
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
                
                callback(nil, YES, nil);
            } else {
                callback(error, NO, nil);
            }
        }
        
    }];
}

+ (void)userFeedback:(NSString *)feedbackAbout customerName:(NSString *)cName orderID:(NSString *)orderID feedbackDetail:(NSString *)feedbackText callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    NSString *requestURL = [PIOURLManager feedbackURL];
    NSDictionary *parameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                 feedbackAbout, @"about",
                                 feedbackText, @"feedback",
                                 cName, @"customerName",
                                 orderID, @"orderId",
                                 nil];
    
    [PIORequestHandler getRequest: requestURL parameters: parameters callback:^(NSError *error, BOOL status, id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
        
        if (error == nil && !status) {
            if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
                PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
                callback(nil,NO, APIResponse);
            }
        }
        else if (status) {
            
            if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
                
                callback(nil, YES, nil);
            } else {
                callback(error, NO, nil);
            }
        }
        
    }];
}


+ (void)saveInfoForFuture:(BOOL)isSaved user:(PIOUser *)user
{
    if (isSaved) {
         [PIOUserPref setUserID: user.ID];
        [PIOUserPref setFirstName: user.firstName];
        [PIOUserPref setLastName: user.lastName];
        [PIOUserPref setEmailAddress: user.email];
        [PIOUserPref setPhoneNumber: user.phone];
    }
    else {
        [PIOUserPref setFirstName: @""];
        [PIOUserPref setLastName: @""];
        [PIOUserPref setEmailAddress: @""];
        [PIOUserPref setPhoneNumber: @""];
    }
    
}

@end
