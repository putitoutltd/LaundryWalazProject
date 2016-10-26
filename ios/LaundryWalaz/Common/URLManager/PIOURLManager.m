//
//  PIOURLManager.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright (c) 2015 Put IT Out. All rights reserved.
//

#import "PIOURLManager.h"

#ifdef DEBUG

// Staging URL
NSString *const PIOBaseURL = @"http://backend-staging.laundrywalaz.com";
#else

// Live URL
NSString *const PIOBaseURL = @"http://backend.laundrywalaz.com";
#endif

//NSString *const PIOBaseURL = @"http://backend-staging.laundrywalaz.com";
//NSString *const PIOBaseURL = @"http://backend.laundrywalaz.com";

@implementation PIOURLManager

+ (NSString *)requestURLWithPath:(NSString *)path
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", PIOBaseURL, path]);
    return [NSString stringWithFormat:@"%@%@", PIOBaseURL, path];
}

+ (NSString *)headerParamValue
{
    return @"{sPjadfadf@4hyBASYdfsLdWJFz2juAdAOI(MkjAnRhsTVC>Wih))J9WT(kr";
}

+ (NSString *)headerParamName
{
    return @"auth-token";
}

+ (NSString *)loginServiceURL
{
    return [NSString stringWithFormat:@"%@%@", PIOBaseURL, @"login"];
}

+ (NSString *)userLoginURL
{
    return [self requestURLWithPath:@"/api/user/login"];
}

+ (NSString *)userRegisterURL
{
    return [self requestURLWithPath:@"/api/user/register"];
}

+ (NSString *)forgotPasswordURL
{
    return [self requestURLWithPath:@"/api/user/forget-password"];
}

+ (NSString *)createorderURL
{
    return [self requestURLWithPath:@"/api/order/create"];
}

+ (NSString *)orderStatusURL
{
    return [self requestURLWithPath:@"/api/order/status"];
}

+ (NSString *)pricingListURL
{
    return [self requestURLWithPath:@"/api/services/list"];
}

+ (NSString *)feedbackURL
{
    return [self requestURLWithPath:@"/api/user/send_feedback"];
}

@end
