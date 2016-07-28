//
//  PIOUserPref.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOUserPref : NSObject

+ (void)setAccessToken:(NSString *)accessToken;
+ (NSString *)requestAccessToken;

+ (void)setInforSavedForFuture:(BOOL)infoSavedForFuture;
+ (BOOL)isInforSavedForFuture;

+ (void)setUserID:(NSString *)ID;
+ (NSString *)requestUserID;

+ (void)setFirstName:(NSString *)firstName;
+ (NSString *)requestFirstName;

+ (void)setLastName:(NSString *)lastName;
+ (NSString *)requestLastName;

+ (void)setEmailAddress:(NSString *)emailAddress;
+ (NSString *)requestEmailAddress;

+ (void)setPhoneNumber:(NSString *)phoneNumer;
+ (NSString *)requestPhoneNumber;

@end
