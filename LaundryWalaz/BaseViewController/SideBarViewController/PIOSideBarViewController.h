//
//  PIOSideBarViewController.h
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIOSideBarViewController : UIViewController <UIActionSheetDelegate>

typedef NS_ENUM(NSUInteger, PIODashboardRowType) {
    PIODashboardRowTypeOrder,
    PIODashboardRowTypeMyOrder,
    PIODashboardRowTypePricing,
    PIODashboardRowTypeHowItWorks,
    PIODashboardRowTypeFeedback,
    PIODashboardRowTypeLogout,
    PIODashboardRowTypeFAQs,
    PIODashboardRowTypeTerms,
    
};

@end
