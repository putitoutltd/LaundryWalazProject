//
//  PIOPricingList.h
//  LaundryWalaz
//
//  Created by pito on 7/28/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>

//    category = "Bed Linen";
//    id = 56;
//    name = "Bedsheet/Table cloth";
//    "price_dryclean" = 230;
//    "price_laundry" = 205;
//    "service_categories_id" = 3;

@interface PIOPricingList : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *priceDryclean;
@property (nonatomic, strong) NSString *priceLaundry;

- (instancetype)initWithInitialParameters:(NSString *)category name:(NSString *)name priceDryclean:(NSString *)priceDryclean priceLaundry:(NSString *)priceLaundry;

@end
