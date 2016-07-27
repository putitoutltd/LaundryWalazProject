//
//  PIOOrderViewController.h
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIOBaseViewController.h"
#import "PIOOrder.h"

typedef NS_ENUM(NSInteger, PIOTimeSlot) {
    PIOTimeSlotMorning,
    PIOTimeSlotAfternoon,
    PIOTimeSlotEvening,
};


typedef NS_ENUM(NSInteger, PIOOrderDay) {
    PIOOrderDayTodayPickUp,
    PIOOrderDayTomorrowPickUp,
    PIOOrderDayOtherDayPickUp,
    PIOOrderDayTodayDeliverOn,
    PIOOrderDayTomorrowDeliverOn,
    PIOOrderDayOtherDayDeliverOn,
};



@interface PIOOrderViewController : PIOBaseViewController

@property (nonatomic, strong) PIOOrder *order;

@end
