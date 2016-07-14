//
//  FileManager.h
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//
#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)buildRelativeFilePathWithName:(NSString *)fileName;
+ (NSString *)cvPDFFilePath;
+ (NSString *)createFolderInDocumentDirectoryWithName:(NSString*)folderName;
+ (void)saveImageWithPath:(UIImage*)image path:(NSString*)path;
+ (NSString *)directoryName:(NSString *)directoryName;
+ (void)deleteAllFiles;

@end
