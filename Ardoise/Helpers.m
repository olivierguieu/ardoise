//
//  Helpers.m
//  VerificationNumeroTVA
//
//  Created by olivier guieu on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Helpers.h"

@implementation Helpers

#pragma mark -
#pragma mark user settings

// cf http://www.btjones.com/2010/05/nsuserdefaults-nil-setting-problem/
// The problem is if your application settings are never opened in the Settings app, when using NSUserDefaults to retrieve setting values within your application, they will be nil even if a DefaultValue is set in your settings bundle.

+ (void)setupDefaults 
{   
    [Helpers setupDefaultsForPlist:@"Root~ipad.inApp.plist"];
    [Helpers setupDefaultsForPlist:@"Root~ipad.plist"];
}

+ (void) setupDefaultsForPlist: (NSString*) pList {
    //get the plist location from the settings bundle
    NSString *settingsPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistPath = [settingsPath stringByAppendingPathComponent:pList];
    
    //get the preference specifiers array which contains the settings
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    //use the shared defaults object
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //for each preference item, set its default if there is no value set
    for(NSDictionary *item in preferencesArray) {
        
        //get the item key, if there is no key then we can skip it
        NSString *key = [item objectForKey:@"Key"];
        if (key) {
            
            //check to see if the value and default value are set
            //if a default value exists and the value is not set, use the default
            id value = [defaults objectForKey:key];
            id defaultValue = [item objectForKey:@"DefaultValue"];
            if(defaultValue && !value) {
                [defaults setObject:defaultValue forKey:key];
            }
        }
    }
    
    //write the changes to disk
    [defaults synchronize];
}


#pragma mark -
#pragma mark Formatting date
+ (NSString *) formatDate: (NSDate *) date  {
    //Create the dateformatter object           
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //Set the required date format
    [formatter setDateFormat:@"yy/MM/dd"];  
    NSString* sDate = [formatter stringFromDate:date];
    return sDate;
}
@end
