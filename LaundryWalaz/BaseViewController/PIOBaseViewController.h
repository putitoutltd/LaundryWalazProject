//
//  PIOBaseViewController.h
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIOBaseViewController : UIViewController
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, assign, getter= isMenuButtonNeedToHide) BOOL menuButtonNeedToHide;
@property (nonatomic, assign, getter= isBackButtonHide) BOOL backButtonHide;

@end
