//
//  PIORequestHandler.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIORequestHandler.h"
#import "PIOAppController.h"
#import "PIOAPIResponse.h"
#import "PIOConstants.h"

@implementation PIORequestHandler

// POST request method.

+ (void)postRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    [[PIOAppController sharedInstance].sessionManager POST:requestURL parameters:parameters progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
            callback(nil,NO, dictionary);
        } else {
            if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
                
                callback(error, YES, dictionary);
            } else {
                callback(error, NO, nil);
            }
        }
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(error, NO, nil);
    }];
}

// GET request method.

+ (void)getRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    [[PIOAppController sharedInstance].sessionManager GET:requestURL parameters:parameters progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
            callback(nil,NO, dictionary);
        } else {
            if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
                
                callback(error, YES, dictionary);
            } else {
                callback(error, NO, nil);
            }
        }
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(error, NO, nil);
    }];
}


// PUT request method

+ (void)putRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    [[PIOAppController sharedInstance].sessionManager
     PUT:requestURL parameters:parameters
     success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSError *error;
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
         if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
             PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
             callback(nil,NO, APIResponse);
         } else {
             if ([[PIOAppController sharedInstance] validateAPIResponse:dictionary]) {
                 
                 callback(error, YES, dictionary);
             } else {
                 callback(error, NO, nil);
             }
         }
     }
     failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         callback(error, NO, nil);
     }];
}

// DELETE request method
+ (void)deleRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback
{
    [[PIOAppController sharedInstance].sessionManager
     DELETE:requestURL parameters:parameters
     success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSError *error;
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
         if ([dictionary[PIOResponseStatus] isEqualToString:PIOResponseStatusFailure]) {
             PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
             callback(nil,NO, APIResponse);
         } else {
             PIOAPIResponse * APIResponse = [[PIOAPIResponse alloc] initWithDict:dictionary];
             callback(nil,YES, APIResponse);
         }
     }
     failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         callback(error, NO, nil);
     }];
}


@end
