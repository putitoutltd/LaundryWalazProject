//
//  PIORequestHandler.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIORequestHandler : NSObject

+ (void)postRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

+ (void)putRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

+ (void)deleRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;

+ (void)getRequest:(NSString *)requestURL parameters:(NSDictionary *)parameters callback:(void (^)(NSError *error,BOOL status, id responseObject))callback;
@end
