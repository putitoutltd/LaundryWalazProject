//
//  PIOUser.h
//  LaundryWalaz
//
//  Created by pito on 7/25/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOUser : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *locationID;

- (instancetype)initWithParametersFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password phone:(NSString *)phone address:(NSString *)address locationID:(NSString *)locationID;

// User Registration API Call
+ (void)userRegistration:(PIOUser *)user callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

// User Login API Call
+ (void)userLogin:(PIOUser *)user callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

// Forgot Password API Call
+ (void)forgotPassword:(NSString *)email callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;
@end
