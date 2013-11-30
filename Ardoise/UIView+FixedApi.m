//
//  UIView+FixedApi.m
//  Ardoise
//
//  Created by Olivier Guieu on 07/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+FixedApi.h"

@implementation UIView (FixedApi)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
