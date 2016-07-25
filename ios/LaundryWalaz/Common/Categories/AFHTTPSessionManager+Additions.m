//
//  AFHTTPSessionManager+Additions.m
//  DurexReconnect
//
//  Created by Putitout
//  Copyright (c) 2015 Putitout. All rights reserved.
//

#import "AFHTTPSessionManager+Additions.h"
#import "PIOURLManager.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOConstants.h"

@implementation AFHTTPSessionManager (Additions)

NSString *const PIOAPIAcceptableContentType = @"text/html";

+ (AFHTTPSessionManager *)initAFHTTPSessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:PIOAPIAcceptableContentType];
    sessionManager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:[PIOURLManager headerParamValue] forHTTPHeaderField:[PIOURLManager headerParamName]];
    return sessionManager;
}


@end
