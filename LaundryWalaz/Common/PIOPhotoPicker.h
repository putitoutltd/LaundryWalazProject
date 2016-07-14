//
//  PIOPhotoPicker.h
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIImagePickerController;

@protocol PIOPhotoPickerDelegate <NSObject>

@optional

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end


@interface PIOPhotoPicker : NSObject

@property (nonatomic, strong, readonly) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, assign, getter=isProfilePhoto) BOOL profilePhoto;
@property (nonatomic, weak) id<PIOPhotoPickerDelegate> delegate;

- (void)saveImageToCameraRoll:(UIImage *)image responseBlock:(void (^)(NSString *path,UIImage *image))block;
//- (void)convertAssetURLToUploadImagePath:(NSURL *)URL responseBlock:(void (^)(NSString *path))block;
- (void)selectPhotoFromViewController;
- (UIImage *)normalResolutionImage:(UIImage *)image;
- (void)openGallery;
- (void)openCamera;

- (void)saveImageToDocumentDirectory:(UIImage *)image ALAssetClass:asset responseBlock:(void (^)(NSString *path,UIImage *image))block;
//- (void)getImagePath:(UIImage *)image responseBlock:(void (^)(NSString *path,UIImage *image))block;
+ (void)removeImage:(NSString *)imagePath;
@end

