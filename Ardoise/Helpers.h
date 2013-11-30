//
//  Helpers.h
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



@interface Helpers : NSObject


// cf http://www.btjones.com/2010/05/nsuserdefaults-nil-setting-problem/
// The problem is if your application settings are never opened in the Settings app, when using NSUserDefaults to retrieve setting values within your application, they will be nil even if a DefaultValue is set in your settings bundle.
+ (void)setupDefaults;
+ (void) setupDefaultsForPlist: (NSString *) pList;

+ (NSString *) formatDate: (NSDate *) date ;
@end
