//
//  PIOAppController.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "AFHTTPSessionManager+Additions.h"
#import "TSMessage.h"
#import "UIFont+Additions.h"
#import "PIOConstants.h"
#import "PIOUserPref.h"
#import "AppDelegate.h"
#import "PIOUser.h"
#import "PIOOrder.h"

//#define NSLog //

typedef NS_ENUM(NSInteger, PIODeviceName){
    PIODeviceNameiPhone4,
    PIODeviceNameiPhone5,
    PIODeviceNameiPhone6,
    PIODeviceNameiPhone6Plus
};

typedef NS_ENUM(NSInteger, PIODeviceHeight){
    iPhone4Height = 480,
    iPhone5Height = 568,
    iPhone6Height = 667,
    iPhone6PlusHeight = 736
};

@interface PIOAppController : NSObject <UINavigationControllerDelegate>
{
    // Reachability
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, assign, getter=isInternetActive) BOOL internetActive;
@property (nonatomic, assign) PIODeviceName currentDeviceName;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) PIOUser *LoggedinUser;
@property (nonatomic, assign, getter=isRemeberMe) BOOL remeberMe;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) PIOOrder *order;

+ (PIOAppController *)sharedInstance;

#pragma mark - Lifecycle methods

- (void)appDidBecomeActive:(UIApplication *)application;
- (void)appDidEnterBackground:(UIApplication *)application;
- (void)appWillResignActive:(UIApplication *)application;
- (void)appWillTerminate: (UIApplication *)application;
- (void)appWillEnterForeground: (UIApplication *)application;
- (BOOL)app:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

#pragma mark - Public Methods
- (BOOL)isValidEmailAddress:(NSString *)checkString;
- (BOOL)isValidPhoneNumber:(NSString *)checkString;
- (BOOL)connectedToNetwork;
- (BOOL)validateAPIResponse:(NSDictionary *)dictionary;

- (NSInteger)currentIOSVersion;

- (void)showActivityViewWithMessage:(NSString *)message;
- (void)hideActivityView;
- (void)showAlertInCurrentViewWithTitle:(NSString *)title message:(NSString *)message withNotificationPosition:(unsigned int)position type:(TSMessageNotificationType)type;
- (void)showInternetNotAvailableAletr;
- (void)titleFroNavigationBar:(NSString *)title onViewController:(UIViewController *)viewController;

#pragma mark - Log Firebase Events

- (void)fireBaseEventWithEventName:(NSString *)event eventParameterValue:(NSString *)value forKey:(NSString *)key;

@end
