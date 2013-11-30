//
//  MCOAppDelegate.h
//  Ardoise
//
//  Created by Olivier Guieu on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ArdoiseViewController;

@interface MCOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet ArdoiseViewController  *myArdoiseViewController;

@end
