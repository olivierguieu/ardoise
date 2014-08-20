//
//  ImageStuff.m
//  Ardoise
//
//  Created by Olivier Guieu on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageStuff.h"

@implementation ImageStuff

@synthesize imageFileName, imageData, backgroundColor, timeStamp;
@synthesize isFavorite;

- (void) dealloc
{
    [imageData release];
    [imageFileName release];
    [backgroundColor release];
    [timeStamp release];
    
    
    [super dealloc];
}


- (id)initWithFileName:(NSString *)fileName andDirectory: (NSString *) directory
{
    if (self = [super init])
    {
        self.imageFileName = fileName;
        
        NSArray *chunks = [self.imageFileName componentsSeparatedByString: @"-"];
        self.backgroundColor = [chunks objectAtIndex:0];

        self.timeStamp = [chunks objectAtIndex:1];
        
        self.isFavorite = ( [directory isEqualToString:kImagesDirectory]) ? FALSE : TRUE;
        
        if ( fileName != nil )
        {   
            self.imageData=[FileOperations LoadFileWithDirectory:directory andFileName:(NSString *) fileName];
        }
    }
    return self;
}


- (void)forceBackgroundColorIfEmpty
{
    if ( self.backgroundColor == nil  )
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults stringForKey:@"BackgroundColor"] == nil)
        {
            self.backgroundColor = @"black" ;
        }
        else 
        {
            self.backgroundColor = [defaults stringForKey:@"BackgroundColor"];
        }
        
        if ( self.backgroundColor == nil  )
        {
            DLog(@"self.backgroundColor IS NIL :-(");
        }
        else
        {
            DLog(@"%@", self.backgroundColor);
        }
    }
}

- (void)applyAnotherImageStuff:(ImageStuff *)newImageStuff
{    
    if ( newImageStuff !=  nil)
    {
        self.imageFileName = newImageStuff.imageFileName;
        self.isFavorite = newImageStuff.isFavorite;
        self.imageData=newImageStuff.imageData; 
        self.backgroundColor = newImageStuff.backgroundColor;
        self.timeStamp = newImageStuff.timeStamp;
    }
    else {
        self.imageFileName =nil;
        self.isFavorite = FALSE;
        self.imageData=nil; 
        self.backgroundColor = nil;
        self.timeStamp = nil;
    }
    
    [self forceBackgroundColorIfEmpty];
}


- (void) saveToFileAndOverWriteDirtyStatus: (BOOL) bOverwriteStatus
{
    if (  bOverwriteStatus == TRUE)
    {
        [self forceBackgroundColorIfEmpty];
        
        // si fileName vide ... on en genere un
        if ( self.imageFileName == nil )
        {
            // tip cf http://www.flexicoder.com/blog/index.php/2013/10/ios-24-hour-date-format/
            
            NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            
            [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
            [rfc3339DateFormatter setDateFormat:@"yyyyMMdd_HH:mm:ss"];
            [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            NSString *result = [self.backgroundColor stringByAppendingString:@"-"];
            result = [result stringByAppendingString:[rfc3339DateFormatter stringFromDate:[NSDate date]]];
            self.imageFileName = result;
            [rfc3339DateFormatter release];
        }
        
        NSString *tmpDirectory;
        if ( self.isFavorite )
        {
            tmpDirectory = [[NSString alloc] initWithString:kFavoritesDirectory];
        }
        else
        {
            tmpDirectory = [[NSString alloc] initWithString:kImagesDirectory];
            
        }
        
        [FileOperations CreateDirectory:tmpDirectory];
        [FileOperations deleteFile:self.imageFileName andDirectory:tmpDirectory];
        [FileOperations saveFileWithData:self.imageData andDirectory:tmpDirectory andFileName:self.imageFileName];
        
        [tmpDirectory release];
        
    }
}

@end
