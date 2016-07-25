//
//  PIOPhotoPicker.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOPhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileManager.h"
#import "PIOConstants.h"
#import "PIOAppController.h"

/*
typedef NS_ENUM(NSInteger, PIOPictureSourceType){
    PIOPictureSourceTypeCamera,
    PIOPictureSourceTypeLibrary
};
*/

@interface PIOPhotoPicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong, readwrite) UIImagePickerController *imagePickerController;

@end

@implementation PIOPhotoPicker

- (id)init
{
    if (self = [super init]) {
        
        if(_imagePickerController ==  nil) {
            _imagePickerController = [[UIImagePickerController alloc] init];
        }
        _imagePickerController.navigationBar.tintColor = [UIColor blackColor];
        _imagePickerController.delegate = self;
        self.profilePhoto = NO;
        _imagePickerController.allowsEditing = NO;
        
    }
    return self;
}

- (void)selectPhotoFromViewController
{
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusRestricted:
        {
            //Tell user access to the photos are restricted
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please give this app permission to access your photo library in your settings app!" withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];

            
        }
            
            break;
        case ALAuthorizationStatusDenied:
        {
            // Tell user access has previously been denied
            [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please give this app permission to access your photo library in your settings app!" withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
            
        }
            
            break;
            
        case ALAuthorizationStatusNotDetermined:
        case ALAuthorizationStatusAuthorized:
        {
            // Try to show image picker
            [self showActionSheet];
            
            break;
        }
            
            
        default:
            break;
    }
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Please select picture source"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Library", nil];
    [actionSheet showInView:self.fromViewController.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case PIOPictureSourceTypeCamera:
            [self openCamera];
            break;
        case PIOPictureSourceTypeLibrary:
            [self openGallery];
            break;
        default:
            [self.fromViewController dismissViewControllerAnimated:YES completion:NULL];
            break;
    }
    
    
}

- (void)openGallery
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.imagePickerController setAllowsEditing: YES];
    [self.fromViewController presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (void)openCamera
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (self.isProfilePhoto) {
        [self.imagePickerController setAllowsEditing: YES];
    }
    [self.fromViewController presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [self.delegate imagePickerController:picker didFinishPickingMediaWithInfo:info];
}


//- (void)convertAssetURLToUploadImagePath:(NSURL *)URL responseBlock:(void (^)(NSString *path))block
//{
//
//        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
//        {
//            ALAssetRepresentation *representation = [myasset defaultRepresentation];
//            UIImage *copyOfOriginalImage=  [UIImage imageWithCGImage:representation.fullScreenImage scale:[representation scale]orientation:(UIImageOrientation)[representation orientation]];
//            NSString *Fname = [FileManager createFolderInDocumentDirectoryWithName:@"laundryWalaz"];
//            NSString *completePath = [NSString stringWithFormat:@"%@/%@",Fname, [representation filename]];
////            NSData *data = UIImageJPEGRepresentation(copyOfOriginalImage, 1.0);
//            [[self reduceImageSize: copyOfOriginalImage] writeToFile:completePath atomically:YES];
//
//            NSString *path = @"file://";
//            
//            NSString *imagePath =[NSString stringWithFormat:@"%@/%@",[FileManager directoryName:@"LaundryWalaz"],[representation filename]];
//            NSString *finalPath = [NSString stringWithFormat:@"%@%@",path,imagePath];
//            block (finalPath);
//            
//        };
//        
//        
//        ALAssetsLibrary *library ;
//        if (library == nil) {
//            library = [[ALAssetsLibrary alloc] init];
//        }
//        
//        [library assetForURL:URL
//                 resultBlock:resultblock
//                failureBlock:nil];
//    
//}

- (UIImage *)normalResolutionImage:(UIImage *)image
{
    // Determine output size
    CGFloat maxSize = 512.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImagePNGRepresentation(newImage);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return processedImage;
}

- (void)saveImageToCameraRoll:(UIImage *)image responseBlock:(void (^)(NSString *path,UIImage *image))block
{
    ALAssetsLibraryWriteImageCompletionBlock completeBlock = ^(NSURL *assetURL, NSError *error){
        if (!error) {
#pragma mark get image url from camera capture.
            
            NSString *assetPath = [NSString stringWithFormat:@"%@",assetURL];
            NSURL* aURL = [NSURL URLWithString:assetPath];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:aURL resultBlock:^(ALAsset *asset)
             {
                 ALAssetRepresentation *representation = [asset defaultRepresentation];
                 UIImage *copyOfOriginalImage=  [UIImage imageWithCGImage:representation.fullScreenImage scale:[representation scale]orientation:(UIImageOrientation)[representation orientation]];
                 NSString *Fname = [FileManager createFolderInDocumentDirectoryWithName:@"laundryWalaz"];
                 NSString *completePath = [NSString stringWithFormat:@"%@/%@",Fname, [representation filename]];
                 //NSData *data = UIImageJPEGRepresentation(copyOfOriginalImage, 1.0);
                 [[self reduceImageSize: copyOfOriginalImage] writeToFile:completePath atomically:YES];
                 NSString *path = @"file://";
                 
                 NSString *imagePath =[NSString stringWithFormat:@"%@/%@",[FileManager directoryName:@"LaundryWalaz"],[representation filename]];
                 NSString *finalPath = [NSString stringWithFormat:@"%@%@",path, imagePath];
                 NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:finalPath]];
                 UIImage *image = [UIImage imageWithData:imageData];
                 block(finalPath,image);
                 
             }
                    failureBlock:^(NSError *error)
             {
                 // error handling
                 NSLog(@"failure-----");
             }];
            
        }
    };
    
    ALAssetsLibrary *library ;
    if (library == nil) {
        library = [[ALAssetsLibrary alloc] init];
    }
    
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:(ALAssetOrientation)[image imageOrientation]
                          completionBlock:completeBlock];
    
    
}
- (void)saveImageToDocumentDirectory:(UIImage *)image ALAssetClass:asset responseBlock:(void (^)(NSString *path,UIImage *image))block
{
   // image = [PIOPhotoPicker imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *copyOfOriginalImage=  [UIImage imageWithCGImage:representation.fullScreenImage scale:[representation scale]orientation:(UIImageOrientation)[representation orientation]];
    NSString *Fname = [FileManager createFolderInDocumentDirectoryWithName:@"LaundryWalaz"];
    NSString *completePath = [NSString stringWithFormat:@"%@/%@",Fname, [representation filename]];
   // NSData *data = UIImageJPEGRepresentation(copyOfOriginalImage, 0.5);
    [[self reduceImageSize: copyOfOriginalImage] writeToFile:completePath atomically:YES]; //Write the file
    completePath = [NSString stringWithFormat:@"%@%@",@"file://",completePath];
    UIImage *img = [UIImage imageWithContentsOfFile:completePath];
    block(completePath,img);

}

- (NSData *)reduceImageSize:(UIImage *)yourImage
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(yourImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(yourImage, compression);
    }
    return imageData;
}

+ (void)removeImage:(NSString *)imagePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSString *filePath = imagePath;
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Image Removed");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end


