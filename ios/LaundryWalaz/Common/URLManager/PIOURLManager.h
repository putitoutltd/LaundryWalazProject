//
//  PIOURLManager.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright (c) 2015 Put IT Out. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOURLManager : NSObject

extern NSString *const PIOBaseURL;

+ (NSString *)headerParamName;
+ (NSString *)headerParamValue;
+ (NSString *)userRegisterURL;
+ (NSString *)userLoginURL;



@end
