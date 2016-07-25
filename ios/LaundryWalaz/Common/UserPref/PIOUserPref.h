//
//  PIOUserPref.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOUserPref : NSObject

+ (void)setInforSavedForFuture:(BOOL)infoSavedForFuture;
+ (BOOL)isInforSavedForFuture;

+ (void)setFirstName:(NSString *)firstName;
+ (NSString *)requestFirstName;

+ (void)setLastName:(NSString *)lastName;
+ (NSString *)requestLastName;

+ (void)setEmailAddress:(NSString *)emailAddress;
+ (NSString *)requestEmailAddress;

+ (void)setPhoneNumber:(NSString *)phoneNumer;
+ (NSString *)requestPhoneNumber;

@end
