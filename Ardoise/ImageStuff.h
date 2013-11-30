//
//  ImageStuff.h
//  Ardoise
//
//  Created by Olivier Guieu on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Includes.h"


@interface ImageStuff : NSObject

@property (nonatomic, retain) NSString *    imageFileName;
@property (nonatomic, retain) NSString *    backgroundColor;
@property (nonatomic, retain) NSString *    timeStamp;
@property (nonatomic, assign) BOOL          isFavorite;
@property (nonatomic, retain) NSData   *    imageData;

- (void) saveToFileAndOverWriteDirtyStatus: (BOOL) bOverwriteStatus;
- (id)initWithFileName:(NSString *)fileName andDirectory: (NSString *) directory;
- (void)applyAnotherImageStuff:(ImageStuff *)newImageStuff;

@end
