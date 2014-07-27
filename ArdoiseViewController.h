//
//  ArdoiseViewController.h
//  Ardoise
//
//  Created by Olivier Guieu on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


// Envoi de Mail
#import <MessageUI/MessageUI.h>
#import "PresetColorPickerController.h"
#import "RecentImagesController.h"
#import "SettingsNavigationViewController.h"
#import "IASKAppSettingsViewController.h"



@class ArdoiseView;
@class PresetColorPickerController;
@class RecentImagesController;
@class ImageStuff;
@class ArrayOfLines;


@interface ArdoiseViewController : UIViewController <PresetColorPickerDelegate,RecentImagesDelegate,UIPopoverControllerDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,  UIAlertViewDelegate, UIGestureRecognizerDelegate>
{
    CGPoint lastPoint;
    BOOL mouseSwiped;
}

// undo data
@property (nonatomic, retain) NSMutableArray * undoArrayOfImages;

// Color Handling
@property (nonatomic, retain) UIColor *currentColor;
@property (nonatomic, retain) NSString *currentColorName;



@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;
- (void) updateColorComponentsWithName:(NSString*) colorName;



-(float) getStrokeSize;
-(float) getAlpha;

@property(nonatomic, assign) float strokeSize;
@property(nonatomic, assign) float rubberSize;
@property(nonatomic, assign) float opacity;
@property(nonatomic, assign) BOOL isRubberMode;
@property(nonatomic, assign) BOOL multiTouchEnabled;
@property(nonatomic, assign) BOOL isDirty;


// undoManagement
- (void) pushImage: (UIImage *) image;
- (UIImage *) popImage;
- (BOOL) canUndo;

// Multitouch handling
@property (nonatomic, retain) ArrayOfLines * arrayOfLines;

- (UIImage *) getUpdatedImage;

@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UIImageView *tempDrawImage;

@property (nonatomic, retain) IBOutlet UIView           *insideView;
@property (nonatomic, retain) IBOutlet UIToolbar        *ardoiseToolbar;

// RecentImagesPicker
@property (nonatomic, retain) UIPopoverController       *recentImagesPopover;
@property (nonatomic, retain) RecentImagesController    *recentImages;

@property (nonatomic, retain) UITabBarController *myTabBarControllerinModalViewController;

@property(nonatomic, retain) IBOutlet UIButton          * rubberButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem          * rubberBarButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem   * shareButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem   * favoritesButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem   * undoButton;

@property(nonatomic, retain)UILongPressGestureRecognizer *longRecognizer;

// ImageStuff
@property(nonatomic, retain) ImageStuff * imageStuff;
- (void) applyImageStuff: (ImageStuff*) newImageStuff;




// user actions
////////////////
- (IBAction) toggleRubberMode:(id)sender;
- (IBAction) shareButtonTapped:(id) sender;
- (IBAction) undoButtonTapped:(id) sender;
- (IBAction) displayHistoryandSettings:(id) sender;
- (IBAction) displayNewImage:(id)sender;
- (IBAction) addToFavorites:(id)sender;

// Trash image
//////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction) confirmCleanup:(id)sender;


// Color Management
/////////////////////
@property (nonatomic, retain) UIPopoverController *colorPickerPopover;
@property (nonatomic, retain) PresetColorPickerController *colorPicker;

- (void)colorNameSelected:(NSString *)colorName;


- (void) enableAllOtherPopups:(Boolean) enable;
- (void) setUpArdoiseView;
- (void) saveCurrentImageStuff;


@end
