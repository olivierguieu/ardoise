//
//  Includes.h
//  Ardoise
//
//  Created by olivierguieu on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Ardoise_Includes_h
#define Ardoise_Includes_h

#import "FileOperations.h"
#import "ArdoiseView.h"
#import "ArdoiseViewController.h"
#import "FileOperations.h"
#import "RecentImagesController.h"
#import "ImageStuff.h"
#import "UIView+FixedApi.h"
#import "PresetColorPicker.h"
#import "ArrayOfLines.h"
#import "Helpers.h"

// 
#import "SettingsNavigationViewController.h"

#define kImagesDirectory    @"IMAGES"
#define kFavoritesDirectory @"FAVIMAGES"


/*
 *  System Versioning Preprocessor Macros
 */ 



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define NSLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

/*
 * Debugging stuff
 */

#define myDebugEnabled  TRUE

#define DLog(fmt, ...) if (myDebugEnabled) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define ULog(fmt, ...) if (myDebugEnabled) { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }

#endif
