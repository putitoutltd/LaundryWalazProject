//
//  PIOUserPref.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOUserPref.h"

NSString *const PIOAccessTokenKey = @"PIOAccessToken";
NSString *const PIOInfoSavedForFutureKey = @"PIOInfoSavedForFuture";
NSString *const PIOUserIDKey = @"PIOUserID";
NSString *const PIOFirstNameKey = @"PIOFirstName";
NSString *const PIOLastName = @"PIOLastName";
NSString *const PIOEmailAddressKey = @"PIOEmailAddress";
NSString *const PIOPhoneKey = @"PIOPhone";

@implementation PIOUserPref


+ (void)setAccessToken:(NSString *)accessToken
{
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:PIOAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestAccessToken
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:PIOAccessTokenKey];
}

+ (void)setInforSavedForFuture:(BOOL)infoSavedForFuture;
{
    [[NSUserDefaults standardUserDefaults] setBool: infoSavedForFuture forKey: PIOInfoSavedForFutureKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isInforSavedForFuture;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: PIOInfoSavedForFutureKey];
}

+ (void)setUserID:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject: ID forKey: PIOUserIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestUserID
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey: PIOUserIDKey];
}


+ (void)setFirstName:(NSString *)firstName
{
    [[NSUserDefaults standardUserDefaults] setObject: firstName forKey: PIOFirstNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestFirstName
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey: PIOFirstNameKey];
}

+ (void)setLastName:(NSString *)lastName
{
    [[NSUserDefaults standardUserDefaults] setObject: lastName forKey: PIOLastName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestLastName
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey: PIOLastName];
}

+ (void)setEmailAddress:(NSString *)emailAddress
{
    [[NSUserDefaults standardUserDefaults] setObject: emailAddress forKey: PIOEmailAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestEmailAddress
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey: PIOEmailAddressKey];
}

+ (void)setPhoneNumber:(NSString *)phoneNumer
{
    [[NSUserDefaults standardUserDefaults] setObject: phoneNumer forKey: PIOPhoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)requestPhoneNumber
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey: PIOPhoneKey];
}

@end
