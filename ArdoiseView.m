//
//  ArdoiseView.m
//  TrainingTddCalculator
//
//  Created by Formation 1 Octo on 28/12/11.
//  Copyright (c) 2011 octo. All rights reserved.
//

#import "ArdoiseView.h"
#import "MCOAppDelegate.h"
#import "Includes.h"


@implementation ArdoiseView

@synthesize imageStuff, currentColor;
@synthesize arrayOfLines;
@synthesize red , green, blue, alpha;
@synthesize isRubberMode, isDirty;
@synthesize multiTouchEnabled;
@synthesize strokeSize;

@synthesize image;

@synthesize viewNeedsToBeCleared,viewNeedsToBeInitWithImage;



- (void)dealloc
{
    [arrayOfLines release];    
    [imageStuff release];
    
    [image release];
    [currentColor release];
    
    [super dealloc];
}


#pragma mark - colorPicker
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void) updateColorComponents:(UIColor*) color
{    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];

    self.red = components[0];
    self.green = components[1];
    self.blue = components[2];
    self.alpha = [self getAlpha];
}


#pragma mark - Alpha

-(float) getAlpha
{
    if (self.isRubberMode )
    {
        return 1.0;
    }
    else
        return .5;
}

#pragma mark - StrokeSize

-(float) getStrokeSize
{
    if (self.isRubberMode )
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *selectedOption = [defaults objectForKey:@"RUBBER_SIZE"];
      
        return [ selectedOption intValue ] * self.strokeSize;
    }
    else
        return self.strokeSize;
}

#pragma mark - background color 

- (NSString *) applyDefaultBackground
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *option = [defaults stringForKey:@"BackgroundColor"];
    
    if ( option  == nil)
    {
        [self applyBackGroundColor:@"blackColor"];
    }
    else
    {
        [self applyBackGroundColor:option];
        
    }    
    return option;
}

- (void) applyBackGroundColor: (NSString*) backgroundColor
{
    self.imageStuff.backgroundColor = backgroundColor;
    
    SEL blackSel = NSSelectorFromString(backgroundColor);
    UIColor* tColor = nil;
    if ([UIColor respondsToSelector: blackSel])
        tColor  = [UIColor performSelector:blackSel];
    
    self.layer.backgroundColor = [tColor CGColor];
}


#pragma mark - applying new stuff/image 

- (void) applyImageStuff: (ImageStuff*) newImageStuff
{
    self.isDirty = FALSE;
    
    [self.imageStuff applyAnotherImageStuff:newImageStuff];
    
    if ( self.imageStuff.imageFileName == nil)
    {
        self.viewNeedsToBeCleared = TRUE;
        self.image = nil; 

    }
    else
    {
        self.viewNeedsToBeInitWithImage = TRUE; 
        
        UIImage *tmpImage = [[UIImage alloc] initWithData:self.imageStuff.imageData];
        self.image = tmpImage;
        [tmpImage release];        
    }

    [self applyBackGroundColor:self.imageStuff.backgroundColor];

    [self setNeedsDisplay]; 
}


#pragma mark - updating and saving

- (UIImage *) getUpdatedImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return viewImage;
}

- (void) updateCurrentImageStuffandSaveIt: (BOOL) bSaveIt
{
    self.imageStuff.imageData = [NSData dataWithData:UIImagePNGRepresentation([self getUpdatedImage])];   
    if ( bSaveIt )  [self.imageStuff  saveToFileAndOverWriteDirtyStatus:YES];
}

#pragma mark - drawing Methods

- (void)drawRect:(CGRect)rect
{
    
    if ( self.viewNeedsToBeCleared)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, self.bounds);
        
        self.viewNeedsToBeCleared=FALSE;
        return;
    }
    
    if ( self.viewNeedsToBeInitWithImage)
    {
        UIImage * tmpImage = [[UIImage alloc] initWithData:self.imageStuff.imageData];
        [tmpImage drawInRect:rect];
        [tmpImage release];
        
        self.viewNeedsToBeInitWithImage=FALSE;
        return;
    }
    
    [curImage drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    if (self.isRubberMode)
    {
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    else
    {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
    
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineWidth(context,[self getStrokeSize]);
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue,1);
    
    // self.layer.opacity = 0.5;
    
    [arrayOfLines drawAllLinesInContext:context];
    
    UIGraphicsEndImageContext();
    
    [super drawRect:rect];
    
    [curImage release];
    curImage =nil;
    
    
    [arrayOfLines currentBecomeFirst];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    mouseSwiped = NO;
	
    NSSet *allTouches = [event allTouches];
    
    if (([allTouches count] > 1 ) && ( self.multiTouchEnabled == TRUE ) ) 
    {
        [arrayOfLines addWithSetOfTouches:allTouches andView:self andIsFirstTouch:TRUE];
    }
    else
    {
        UITouch *touch = [touches anyObject];

        [arrayOfLines addWithOneTouch:touch  andView:self andIsFirstTouch:TRUE];
    }
    self.isDirty = TRUE;
}


- (void)updateCurImageAndForceDisplayInRect {
    CGRect rect = [arrayOfLines currentRect:[self getStrokeSize]];
    
    if (   ( self.viewNeedsToBeCleared == FALSE ) && ( self.viewNeedsToBeInitWithImage == FALSE )) 
    {
        UIGraphicsBeginImageContext(rect.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        curImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        [curImage retain];
        UIGraphicsEndImageContext();
    }
    
    [self setNeedsDisplayInRect:rect];
}


- (void)updateTmpDrawImage
{
    UIApplication *myApplication = [UIApplication sharedApplication];
    MCOAppDelegate *myDelegate = myApplication.delegate;
    ArdoiseViewController *myController = myDelegate.myArdoiseViewController;
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [myController.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:[self getAlpha]];
    
    
    myController.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.image = nil;
    UIGraphicsEndImageContext();
    

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
	mouseSwiped = YES;

    NSSet *allTouches = [event allTouches];
    
    if (([allTouches count] > 1) && (self.multiTouchEnabled == TRUE) ) 
    {
        [arrayOfLines addWithSetOfTouches:allTouches andView:self andIsFirstTouch:FALSE];
    }
    else
    {
        UITouch *touch = [touches anyObject];
        [arrayOfLines addWithOneTouch:touch  andView:self andIsFirstTouch:FALSE];
    }

    [self updateCurImageAndForceDisplayInRect];
        
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] == 1 )
    {
        // cas du point unique !
        if ( !mouseSwiped ) 
        {
            [arrayOfLines addOnePoint];
            
            [self updateCurImageAndForceDisplayInRect];
        }
    }
    
 //   [self updateTmpDrawImage];
    
}
@end
