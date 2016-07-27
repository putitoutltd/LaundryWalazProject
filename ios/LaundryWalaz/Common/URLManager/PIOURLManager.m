//
//  PIOURLManager.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright (c) 2015 Put IT Out. All rights reserved.
//

#import "PIOURLManager.h"


NSString *const PIOBaseURL = @"http://backend-staging.laundrywalaz.com";

@implementation PIOURLManager

+ (NSString *)requestURLWithPath:(NSString *)path
{
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

@end
