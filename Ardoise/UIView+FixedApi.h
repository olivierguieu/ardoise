//
//  UIView+FixedApi.h
//  Ardoise
//
//  Created by Olivier Guieu on 07/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FixedApi)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end
