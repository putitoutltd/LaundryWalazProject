//
//  PIOURLManager.m
//  LaundryWalaz
//
//  Created by pito on 6/23/16.
//  Copyright (c) 2015 Put IT Out. All rights reserved.
//

#import "PIOURLManager.h"


NSString *const PIOBaseURL = @"http://kidlr.lotiv.com";
NSString *const PIOGoogleAppURL = @"https://itunes.apple.com/en/app/google+/id447119634?mt=8";
NSString *const PIOGoogleUserInfoURL = @"https://www.googleapis.com/auth/userinfo.email";
NSString *const PIOFacebookImageURL = @"https://graph.facebook.com/%@/picture?type=large";
//NSString *const PIOAddBabyURL = @"http://kidlr.lotiv.com/api/user/baby/add";

@implementation PIOURLManager

+ (NSString *)requestURLWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", PIOBaseURL, path];
}

+ (NSString *)loginServiceURL
{
    return [NSString stringWithFormat:@"%@%@", PIOBaseURL, @"login"];
}

+ (NSString *)userLoginURL
{
    return [self requestURLWithPath:@"/api/user/login"];
}

+ (NSString *)userRegisterURL
{
    return [self requestURLWithPath:@"/api/user/register"];
}

+ (NSString *)userDetail
{
    return [self requestURLWithPath:@"/api/user/getuser"];
}

+ (NSString *)userUploadImageURL
{
    return [self requestURLWithPath:@"/api/image/upload"];
}

+ (NSString *)headerParamName
{
    return @"auth-token";
}

+ (NSString *)headerParamValue
{
    return @"{sPjZze9s@4hyBAieLdWJFz2juAdgnnRhsTVC>Wih))J9WT(kr";
}

+ (NSString *)addBabyURL
{
    return [self requestURLWithPath:@"/api/user/baby/add"];
}

+ (NSString *)sendInviteURL
{
    return [self requestURLWithPath:@"/api/user/invite"];
}

+ (NSString *)socialLoginURL
{
    return [self requestURLWithPath:@"/api/user/social-login"];
}

+ (NSString *)BabiesListURL
{
    return [self requestURLWithPath:@"/api/user/baby/list"];
}

+ (NSString *)userDownloadImageURL
{
    return [self requestURLWithPath:@"/api/image/show"];
}

+ (NSString *)editableFriendList
{
    return [self requestURLWithPath:@"/api/user/friends/all"];
}

+ (NSString *)userUpdate
{
    return [self requestURLWithPath:@"/api/user/update"];
}

+ (NSString *)createPost
{
    return [self requestURLWithPath:@"/api/post/create-with-image"];
}

+ (NSString *)suggestedFriendsURL
{
    return [self requestURLWithPath:@"/api/user/friends/suggested"];
}

+ (NSString *)searchFriendsURL
{
    return [self requestURLWithPath:@"/api/user/friends/search"];
}

+ (NSString *)userProfileURL
{
    return [self requestURLWithPath:@"/api/user/profile"];
}

+ (NSString *)deleteBaby
{
    return [self requestURLWithPath:@"/api/user/baby/delete"];
}

+ (NSString *)SendFriendRequestURL
{
    return [self requestURLWithPath:@"/api/user/friends/request/send"];
}

+ (NSString *)updatingBabyProfile
{
    return [self requestURLWithPath:@"/api/user/baby/update"];
}

+ (NSString *)updatingRelationOfFriends
{
    return [self requestURLWithPath:@"/api/user/friends/relation/update"];
}

+ (NSString *)allFriendsURL
{
    return [self requestURLWithPath:@"/api/user/friends/all"];
}

+ (NSString *)friendsRequestURL
{
    return [self requestURLWithPath:@"/api/user/friends/requests"];
}

+ (NSString *)acceptFriendsRequestURL
{
    return [self requestURLWithPath:@"/api/user/friends/request/update"];
}

+ (NSString *)deleteFriendURL
{
    return [self requestURLWithPath:@"/api/user/friends/request/delete"];
}

+ (NSString *)cancelFriendRequestURL
{
    return [self requestURLWithPath:@"/api/user/friends/request/cancel"];
}

+ (NSString *)friendsKidlrRequestURL
{
    return [self requestURLWithPath:@"/api/user/friends/children"];
}

+ (NSString *)createAlbumURL
{
    return [self requestURLWithPath:@"/api/album/create"];
}

+ (NSString *)updateAlbumURL
{
    return [self requestURLWithPath:@"/api/album/update"];
}

+ (NSString *)deleteAlbumURL
{
    return [self requestURLWithPath:@"/api/album/delete"];
}


+ (NSString *)getSingleAlbumData
{
    return [self requestURLWithPath:@"/api/album/show"];
}

+ (NSString *)listAllAlbumURL
{
    return [self requestURLWithPath:@"/api/album/list"];
}

+ (NSString *)uploadGalleryImageURL
{
    return [self requestURLWithPath:@"/api/album/media/upload"];
}

+ (NSString *)listMedia
{
    return [self requestURLWithPath:@"/api/album/media/list"];
}

+ (NSString *)showMedia
{
    return [self requestURLWithPath:@"/api/album/media/show"];
}

+ (NSString *)deleteMedia
{
    return [self requestURLWithPath:@"/api/album/media/remove"];
}

+ (NSString *)listCommentsAndSmilesURL
{
    return [self requestURLWithPath:@"/api/album/media/socials"];
}

+ (NSString *)commentURL
{
    return [self requestURLWithPath:@"/api/comment/create"];
}

+ (NSString *)listSmilesURL
{
    return [self requestURLWithPath:@"/api/smile/list"];
}

+ (NSString *)smileURL
{
    return [self requestURLWithPath:@"/api/smile/create"];
}

+ (NSString *)editCommentURL
{
    return [self requestURLWithPath:@"/api/comment/update"];
}

+ (NSString *)deleteCommentURL
{
    return [self requestURLWithPath:@"/api/comment/delete"];
}

+ (NSString *)createMedicalURL
{
    return [self requestURLWithPath:@"/api/medical/create"];
}

+ (NSString *)medicalReportList
{
    return [self requestURLWithPath:@"/api/medical/list"];
}

+ (NSString *)deleteMedicalReportURL
{
    return [self requestURLWithPath:@"/api/medical/delete"];
}

+ (NSString *)updateMedicalURL
{
    return [self requestURLWithPath:@"/api/medical/update"];
}

+ (NSString *)userUploadVideoURL
{
    return [self requestURLWithPath:@"/api/video/upload"];
}

+ (NSString *)listAllVideosURL
{
    return [self requestURLWithPath:@"/api/video/list"];
}

+ (NSString *)deleteVideoURL
{
    return [self requestURLWithPath:@"/api/video/delete"];
}

+ (NSString *)videoURL
{
    return [self requestURLWithPath:@"/api/video/get"];
}

+ (NSString *)updateVideoURL
{
    return [self requestURLWithPath:@"/api/video/update"];
}

+ (NSString *)userTimelineURL
{
    return [self requestURLWithPath:@"/api/user/timeline"];
}

+ (NSString *)createUserPost
{
    return [self requestURLWithPath:@"/api/post/create"];
}

+ (NSString *)deleteUserPost
{
    return [self requestURLWithPath:@"/api/post/delete"];
}

+ (NSString *)updateUserPost
{
    return [self requestURLWithPath:@"/api/post/update"];
}

+ (NSString *)resetPassword
{
    return [self requestURLWithPath:@"/api/user/reset-password"];
}

+ (NSString *)vaccinationsURL
{
    return [self requestURLWithPath:@"/api/user/baby/vaccination/get"];
}

+ (NSString *)activityURL
{
    return [self requestURLWithPath:@"/api/user/activities/list"];
}

+ (NSString *)updateActivityURL
{
    return [self requestURLWithPath:@"/api/user/activities/update"];
}

+ (NSString *)listAllMilestones
{
    return [self requestURLWithPath:@"/api/user/milestones/list"];
}

+ (NSString *)registerDeviceTokenURL
{
    return [self requestURLWithPath:@"/api/user/device"];
}

+ (NSString *)removeDeviceTokenURL
{
    return [self requestURLWithPath:@"/api/user/device/remove"];
}

+ (NSString *)logoutURL
{
    return [self requestURLWithPath:@"/api/user/logout"];
}

+ (NSString *)forgotPasswordURL
{
    return [self requestURLWithPath:@"/api/user/forget-password"];
}

+ (NSString *)updatingRelationOfFriendsRequest
{
    return [self requestURLWithPath:@"/api/user/friends/relation/update_request"];
}

+ (NSString *)showAlbumDetailURL
{
    return [self requestURLWithPath:@"/api/album/show"];
}

+ (NSString *)showUserPostURL
{
    return [self requestURLWithPath:@"/api/post/show"];
}

+ (NSString *)verifyEmailURL
{
    return [self requestURLWithPath:@"/api/user/verify-email"];
}

+ (NSString *)verifyEmailWithTokenURL
{
    return [self requestURLWithPath:@"/api/user/verify-token"];
}

+ (NSString *)listAllVaccinations
{
    return [self requestURLWithPath:@"/api/user/baby/vaccination/get"];
}

+ (NSString *)updateVaccinationStatus
{
    return [self requestURLWithPath:@"/api/user/baby/vaccination/update"];
}

+ (NSString *)verifyEmailTokenURL
{
    return [self requestURLWithPath:@"/api/user/resend-verify-token"];
}

+ (NSString *)scheduleVaccinationURL
{
    return [self requestURLWithPath:@"/api/user/vaccination/email"];
}

+ (NSString *)singleVaccinationDetailURL
{
     return [self requestURLWithPath:@"/api/user/baby/vaccination/get/single"];
}

+ (NSString *)deleteImageURL
{
    return [self requestURLWithPath:@"/api/image/remove"];
}

@end
