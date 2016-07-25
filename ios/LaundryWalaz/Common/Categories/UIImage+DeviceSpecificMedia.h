//
//  UIImage+DeviceSpecificMedia.h
//  LaundryWalaz
//
//  Created by pito on 6/30/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, thisDeviceClass) {
    
    thisDeviceClass_iPhone,
    thisDeviceClass_iPhoneRetina,
    thisDeviceClass_iPhone5,
    thisDeviceClass_iPhone6,
    thisDeviceClass_iPhone6plus,
    
    // we can add new devices when we become aware of them
    
    thisDeviceClass_iPad,
    thisDeviceClass_iPadRetina,
    
    
    thisDeviceClass_unknown
};

thisDeviceClass currentDeviceClass();

@interface UIImage (DeviceSpecificMedia)

+ (instancetype )imageForDeviceWithName:(NSString *)fileName;

@end
