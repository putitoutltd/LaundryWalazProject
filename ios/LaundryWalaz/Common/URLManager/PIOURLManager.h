//
//  PIOURLManager.h
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright (c) 2015 Put IT Out. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOURLManager : NSObject

extern NSString *const PIOBaseURL;


+ (NSString *)loginServiceURL;

+ (NSString *)userLoginURL;
+ (NSString *)userRegisterURL;
+ (NSString *)userDetail;
+ (NSString *)userUploadImageURL;

+ (NSString *)headerParamName;
+ (NSString *)headerParamValue;

+ (NSString *)addBabyURL;

+ (NSString *)sendInviteURL;

+ (NSString *)socialLoginURL;

+ (NSString *)BabiesListURL;

+ (NSString *)userDownloadImageURL;


+ (NSString *)editableFriendList;

+ (NSString *)userUpdate;

+ (NSString *)createPost;

+ (NSString *)suggestedFriendsURL;

+ (NSString *)searchFriendsURL;

+ (NSString *)userProfileURL;

+ (NSString *)deleteBaby;

+ (NSString *)SendFriendRequestURL;

+ (NSString *)updatingBabyProfile;

+ (NSString *)updatingRelationOfFriends;

+ (NSString *)allFriendsURL;

+ (NSString *)friendsRequestURL;

+ (NSString *)acceptFriendsRequestURL;

+ (NSString *)deleteFriendURL;

+ (NSString *)cancelFriendRequestURL;

+ (NSString *)friendsKidlrRequestURL;

+ (NSString *)createAlbumURL;

+ (NSString *)getSingleAlbumData;

+ (NSString *)updateAlbumURL;

+ (NSString *)deleteAlbumURL;

+ (NSString *)uploadGalleryImageURL;

+ (NSString *)listAllAlbumURL;

+ (NSString *)listMedia;

+ (NSString *)showMedia;

+ (NSString *)deleteMedia;

+ (NSString *)listCommentsAndSmilesURL;

+ (NSString *)commentURL;

+ (NSString *)listSmilesURL;

+ (NSString *)smileURL;

+ (NSString *)editCommentURL;

+ (NSString *)deleteCommentURL;

+ (NSString *)createMedicalURL;

+ (NSString *)medicalReportList;

+ (NSString *)deleteMedicalReportURL;

+ (NSString *)updateMedicalURL;

+ (NSString *)userUploadVideoURL;

+ (NSString *)listAllVideosURL;

+ (NSString *)deleteVideoURL;

+ (NSString *)videoURL;

+ (NSString *)updateVideoURL;

+ (NSString *)userTimelineURL;

+ (NSString *)createUserPost;

+ (NSString *)deleteUserPost;

+ (NSString *)updateUserPost;

+ (NSString *)resetPassword;

+ (NSString *)vaccinationsURL;

+ (NSString *)activityURL;

+ (NSString *)updateActivityURL;

+ (NSString *)listAllMilestones;

+ (NSString *)registerDeviceTokenURL;

+ (NSString *)removeDeviceTokenURL;

+ (NSString *)logoutURL;

+ (NSString *)forgotPasswordURL;

+ (NSString *)updatingRelationOfFriendsRequest;

+ (NSString *)showAlbumDetailURL;

+ (NSString *)showUserPostURL;

+ (NSString *)verifyEmailURL;

+ (NSString *)verifyEmailWithTokenURL;

+ (NSString *)listAllVaccinations;

+ (NSString *)updateVaccinationStatus;

+ (NSString *)verifyEmailTokenURL;

+ (NSString *)scheduleVaccinationURL;

+ (NSString *)singleVaccinationDetailURL;

+ (NSString *)deleteImageURL;

@end
