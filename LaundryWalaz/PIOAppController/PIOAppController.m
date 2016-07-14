//
//  PIOAppController.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "MBProgressHUD.h"

#import "PIOAppController.h"
#import "PIOConstants.h"
#import "PIOUserPref.h"
#import "AppDelegate.h"

#import "PIOHowToUseViewController.h"
#import "PIOLoginViewController.h"
#import "Flurry.h"

static PIOAppController *sharedInstance = nil;
static bool isFirstAccess = YES;
static NSInteger PIORequestTimeOutIntervals = 20;


@interface PIOAppController()  <MBProgressHUDDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) MBProgressHUD * HUD;
@property (nonatomic, readwrite) UINavigationController *navigationController;


@end

@implementation PIOAppController



#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[PIOAppController alloc] init];
}

- (id)mutableCopy
{
    return [[PIOAppController alloc] init];
}

- (id) init
{
    if(sharedInstance){
        return sharedInstance;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    
    self = [super init];
    self.sessionManager = [AFHTTPSessionManager initAFHTTPSessionManager];
    self.sessionManager.requestSerializer.timeoutInterval = PIORequestTimeOutIntervals;
    [self setupInitialViewAndNavigation];
    
    self.internetActive = YES;
    return self;
}

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    
    return sharedInstance;
}

- (PIODeviceName)currentDeviceName
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (screenHeight < screenWidth) {
        screenHeight = screenWidth;
    }
    if (screenHeight == iPhone4Height) {
        _currentDeviceName = PIODeviceNameiPhone4;
    } else if (screenHeight == iPhone5Height) {
        _currentDeviceName = PIODeviceNameiPhone5;
    } else if (screenHeight == iPhone6Height) {
        _currentDeviceName = PIODeviceNameiPhone6;
    } else if ([UIScreen mainScreen].scale > 2.9) {
        _currentDeviceName = PIODeviceNameiPhone6Plus;
    }
    return _currentDeviceName;
}

- (NSInteger)currentIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}


- (void)setupInitialViewAndNavigation
{
    // Set up the VC's as this is a non storyboard app
    UIViewController *initialViewController =  [self initialViewController];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    // To overcome pop View controller on Left to roght swipe.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (UIViewController *)initialViewController
{
    PIOLoginViewController * howToUseViewController = [PIOLoginViewController new];
    return howToUseViewController;
    
}

- (BOOL)isValidEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidPhoneNumber:(NSString *)checkString
{
    NSString *mobileNumberPattern = @"[789][0-9]{9}";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    BOOL matched = [mobileNumberPred evaluateWithObject:checkString];
    return  matched;
}

- (void)showActivityViewWithMessage:(NSString *)message
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.dimBackground = YES;
    self.HUD.labelText = message;
    self.HUD.delegate = self;
    [self.HUD show: YES];
}

- (void)hideActivityView
{
    [self.HUD removeFromSuperview];
    //[self.HUD hide: YES];
}

- (BOOL)connectedToNetwork
{
    if (!self.isInternetActive) {
        [self showInternetNotAvailableAletr];
    }
    return  self.isInternetActive;
}

- (BOOL)validateAPIResponse:(NSDictionary *)dictionary
{
    if ([self isObjectEmpty:dictionary]) {
        return false;
    } else {
        return true;
    }
}

- (void)showAlertInCurrentViewWithTitle:(NSString *)title message:(NSString *)message withNotificationPosition:(unsigned int)position type:(TSMessageNotificationType)type
{
    [TSMessage showNotificationInViewController: self.navigationController
                                          title: title
                                       subtitle: message
                                          image:nil
                                           type: type
                                       duration: 5
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition: position
                           canBeDismissedByUser: YES];
    
}

- (NSString *)daySuffixForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

- (UIImageView *)roundedRectImageView:(UIImageView*)imageView
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    return imageView;
}


#pragma mark - Lifecycle methods

- (void)appDidBecomeActive:(UIApplication *)application
{
    
}

- (void)appDidEnterBackground:(UIApplication *)application
{
    
}

- (void)appWillResignActive:(UIApplication *)application
{
    
}

- (void)appWillTerminate: (UIApplication *)application
{
    
}

- (void)appWillEnterForeground: (UIApplication *)application
{
    
}

- (BOOL)app:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

#pragma mark - Private Methods

- (BOOL)isObjectEmpty:(id)objectToCheck
{
    return objectToCheck == nil
    || [objectToCheck isKindOfClass:[NSNull class]]
    || ([objectToCheck respondsToSelector:@selector(length)]
        && [(NSData *)objectToCheck length] == 0)
    || ([objectToCheck respondsToSelector:@selector(count)]
        && [(NSArray *)objectToCheck count] == 0);
}

- (void)showInternetNotAvailableAletr
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self hideActivityView];
        [TSMessage showNotificationInViewController:self.navigationController title:@"Network error" subtitle:@"Couldn't connect to the server. Check your network connection." type:TSMessageNotificationTypeError duration:TSMessageNotificationDurationAutomatic canBeDismissedByUser: YES];
    });
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
}

#pragma mark - Set NavigationBar Title

- (void)titleFroNavigationBar:(NSString *)title onViewController:(UIViewController *)viewController
{
    UILabel * topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
    [topTitleLabel setFont: [UIFont PIOMyriadProLightWithSize:26.6]];
    topTitleLabel.text = title;
    [topTitleLabel sizeToFit];
    [topTitleLabel setBackgroundColor:[UIColor clearColor]];
    [topTitleLabel setTextColor:[UIColor colorWithRed:54.0/255.0 green:57.0/255.0 blue:112.0/255.0 alpha:1.0]];
    viewController.navigationItem.titleView =topTitleLabel;
}

- (void)logFlurryEvent:(NSString *)event eventParameterValue:(NSString *)value forKey:(NSString *)key
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject: value forKey: key];
    [self logFlurryEvent: event parameters: parameters];
}

#pragma mark - Flurry Methods
- (void)logFlurryEvent:(NSString *)event parameters:(NSMutableDictionary *)parameters
{
    [Flurry logEvent:event withParameters:parameters];
}

@end