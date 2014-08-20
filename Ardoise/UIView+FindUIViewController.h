//
//  UIView+FindUIViewController.h
//  Ardoise
//
//  Created by olivier guieu on 07/08/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end
