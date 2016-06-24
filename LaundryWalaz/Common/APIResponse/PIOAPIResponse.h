//
//  PIOAPIResponse.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOAPIResponse : NSObject

@property (nonatomic, assign) NSString *data;
@property (nonatomic, assign) NSString *message;
@property (nonatomic, assign) NSString *status;

- (instancetype)initWithDict:(NSDictionary *)dictionary;

@end
