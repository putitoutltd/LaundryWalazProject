//
//  PIORegisterViewController.m
//  LaundryWalaz
//
//  Created by pito on 7/14/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIORegisterViewController.h"
#import "UIImage+DeviceSpecificMedia.h"
#import "PIOAppController.h"
#import "PIOPhotoPicker.h"

@interface PIORegisterViewController () <PIOPhotoPickerDelegate>


@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UIImageView *profileCoverImageView;
@property (nonatomic, strong) PIOPhotoPicker *photoPicker;
@property (nonatomic, strong) NSString *imagePath;
@end

@implementation PIORegisterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applyFonts];
    
    // hide Menu button from right side of the navigation bar.
     self.menuButtonNeedToHide = YES;
    
    // profile image cover according to screen
    [self.profileCoverImageView setImage: [UIImage imageForDeviceWithName:@"register-icon"]];
    
    // Set Screen Title
    [[PIOAppController sharedInstance] titleFroNavigationBar: @"Register" onViewController:self];
    
    self.photoPicker = [[PIOPhotoPicker alloc] init];
    self.photoPicker.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)registerButtonPressed:(id)sender
{
    
    if (self.firstNameTextField.text.length == 0 || self.lastNameTextField.text.length == 0 || self.phoneTextField.text.length == 0 || self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0 ) {
       
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please fill empty fields." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else if (![[PIOAppController sharedInstance] isValidEmailAddress:self.emailTextField.text]) {
        
        [[PIOAppController sharedInstance] showAlertInCurrentViewWithTitle: @"" message: @"Please enter a valid email address." withNotificationPosition: TSMessageNotificationPositionTop type: TSMessageNotificationTypeWarning];
    }
    else {
    }
}

- (IBAction)pickProfileImageButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    self.photoPicker.fromViewController = self;
    self.photoPicker.profilePhoto = YES;
    [self.photoPicker  selectPhotoFromViewController];
}

#pragma mark - Private Methods

- (void)applyFonts
{
    [self.firstNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.lastNameTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.phoneTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.emailTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.passwordTextField setFont: [UIFont PIOMyriadProLightWithSize: 13.5f]];
    [self.registerButton.titleLabel setFont: [UIFont PIOMyriadProLightWithSize: 14.75f]];
    
}

#pragma mark - Image Picker Delegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.photoPicker.imagePickerController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
//        self.imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
//        NSData *data  = [[PIOAppController sharedInstance] reduceImageSize: image];
//        image = [UIImage imageWithData:data];
        
        self.profileImageView.image = image;
        self.profileImageView =  [[PIOAppController sharedInstance] roundedRectImageView: self.profileImageView];
        if(image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.photoPicker saveImageToCameraRoll:image responseBlock:^(NSString *path, UIImage *image) {
                    self.imagePath = path;
                    
                }];
            });
            
        }
    }];
}

@end
