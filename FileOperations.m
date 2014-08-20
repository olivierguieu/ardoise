//
//  FileOperations.m
//  Ardoise
//
//  Created by Olivier Guieu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Includes.h"

@implementation FileOperations

#pragma mark - FileOperations

// cf http://www.ios-developer.net/iphone-ipad-programmer/development/file-saving-and-loading/using-the-document-directory-to-store-files

+ (void) CreateDirectory:(NSString *) directory
{
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:path
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	}
}


+ (void) LogFilesWithDirectory:(NSString *) directory
{
    //----- LIST ALL FILES -----
    // NSLog(@"LISTING ALL FILES FOUND");
    
    int Count;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
    }
}

+ (NSArray *) getArrayOfFilesInDirectory:(NSString *) directory
{
    //----- LIST ALL FILES -----
    // NSLog(@"LISTING ALL FILES FOUND");
    
    NSMutableArray *res =[[[NSMutableArray alloc ] initWithCapacity:10] autorelease];
    
    int Count;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        // NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
        [res addObject:[directoryContent objectAtIndex:Count]];
    }
    return [[NSArray alloc] initWithArray:res];
}

+ (NSMutableArray *) getArrayOfImagesStuffInDirectory:(NSString *) directory
{
    //----- LIST ALL FILES -----
    // NSLog(@"LISTING ALL FILES FOUND");
    
    NSMutableArray *res =[[[NSMutableArray alloc ] initWithCapacity:10] autorelease];
    
    int Count;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        // NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
        
        ImageStuff *stuff = [[ImageStuff alloc] initWithFileName:[directoryContent objectAtIndex:Count]  andDirectory:directory];

        [res addObject:stuff];
    }
    
    // sort it based on timestamp...
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [[res sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

+ (NSData *) LoadFileWithDirectory: (NSString*) directory andFileName:(NSString *) fileName
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    path = [path stringByAppendingPathComponent:fileName];
    
    NSData *file1 = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        //File exists
        file1 = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    }
    else
    {
        NSLog(@"File does not exist");
    }
    return file1;
}

+ (BOOL) saveFileWithData: (NSData *) file andDirectory:(NSString *) directory andFileName: (NSString *) fileName;
{
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
	path = [path stringByAppendingPathComponent:fileName];
    
    return[[NSFileManager defaultManager] createFileAtPath:path
                                                  contents:file
                                                attributes:nil];
    
}

+ (BOOL) deleteFile:(NSString *) fileName andDirectory:(NSString *) directory
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    path = [path stringByAppendingPathComponent:fileName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])		//Does file exist?
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error])	//Delete it
        {
            NSLog(@"Delete file error: %@", error);
        }
    }
    return TRUE;
    
}

//
//Move File
//
//[[NSFileManager defaultManager] moveItemAtPath:MySourcePath toPath:MyDestPath error:n
//

@end
