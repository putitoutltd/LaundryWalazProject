//
//  FileManager.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//
#import "FileManager.h"


#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>


@implementation FileManager

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *)buildRelativeFilePathWithName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],fileName];
    return filePath;
}

+ (NSString *)cvPDFFilePath {
    return [[self class] buildRelativeFilePathWithName:@"CV.pdf"];
}

+ (NSString *)createFolderInDocumentDirectoryWithName:(NSString*)folderName
{
    NSString *basePath = [FileManager applicationDocumentsDirectory];
    NSString *dataPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",folderName]];
    NSError*    error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }else {
        NSLog(@"folder exists");
    }
    return dataPath;
    
}

+ (NSString *)directoryName:(NSString *)directoryName
{
    NSString *documentsPath = [self applicationDocumentsDirectory];
    NSString *directoryPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",directoryName]];
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    if ([directoryContents containsObject:directoryName]) {
        return directoryPath;
        
    }
    return nil;
}

+ (void)saveImageWithPath:(UIImage*)image path:(NSString*)path
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@/%@",[FileManager applicationDocumentsDirectory],@"laundryWalaz",path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:fullPath atomically:YES];
    }
    
    
    // Write out the contents of home directory to console
    
}

+ (void)deleteAllFiles
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [self directoryName:@"laundryWalaz"];
    NSArray *fileArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *filename in fileArray) {
        [fileManger removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}




@end
