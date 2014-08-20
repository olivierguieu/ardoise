//
//  FileOperations.h
//  Ardoise
//
//  Created by Olivier Guieu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperations : NSObject

+ (void) CreateDirectory:(NSString *) directory;
+ (void) LogFilesWithDirectory:(NSString *) directory;

+ (NSArray *) getArrayOfFilesInDirectory:(NSString *) directory;
+ (NSMutableArray *) getArrayOfImagesStuffInDirectory:(NSString *) directory;

+ (NSData *) LoadFileWithDirectory: (NSString*) directory andFileName:(NSString *) fileName;

+ (BOOL) saveFileWithData: (NSData *) file andDirectory:(NSString *) directory andFileName: (NSString *) fileName;
+ (BOOL) deleteFile:(NSString *) fileName andDirectory:(NSString *) directory;

@end
