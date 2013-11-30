//
//  FavoritesViesController.h
//  Ardoise
//
//  Created by Olivier Guieu on 03/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@interface SettingsNavigationViewController : UINavigationController <IASKSettingsDelegate>

@property (nonatomic, assign) id delegate;

// Call back appelée sur le Done button... version iPhone/iPod touch...
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender;

@end
