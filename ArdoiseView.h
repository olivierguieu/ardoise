//
//  ArdoiseView.h
//  TrainingTddCalculator
//
//  Created by Formation 1 Octo on 28/12/11.
//  Copyright (c) 2011 octo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ImageStuff;
@class ArrayOfLines;

@interface ArdoiseView : UIView
{
	BOOL    mouseSwiped;
    UIImage *curImage;
}


@property(nonatomic, retain) ImageStuff * imageStuff;
- (void) applyImageStuff: (ImageStuff*) newImageStuff;

@property (nonatomic, retain) ArrayOfLines * arrayOfLines;

@property (nonatomic, retain) UIColor * currentColor;
@property (nonatomic, assign)   CGFloat red;
@property (nonatomic, assign)   CGFloat green;
@property (nonatomic, assign)   CGFloat blue;
@property (nonatomic, assign)   CGFloat alpha;
- (void) updateColorComponents:(UIColor*) color;

@property(nonatomic, assign) BOOL isRubberMode;
@property(nonatomic, assign) BOOL multiTouchEnabled;
@property(nonatomic, assign) BOOL isDirty;

@property(nonatomic, assign) float strokeSize;

-(float) getStrokeSize;
-(float) getAlpha;

- (UIImage *) getUpdatedImage;
- (void) updateCurrentImageStuffandSaveIt: (BOOL) bSaveIt;

@property (nonatomic, retain) UIImage * image;

@property (nonatomic, assign) BOOL viewNeedsToBeCleared;
@property (nonatomic, assign) BOOL viewNeedsToBeInitWithImage;

- (NSString *) applyDefaultBackground;
- (void) applyBackGroundColor: (NSString*) backgroundColor;



@end
