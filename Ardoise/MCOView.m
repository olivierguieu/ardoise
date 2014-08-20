//
//  FinalAlgView.m
//  VariableStrokeWidthTut
//
//  Created by A Khan on 18/03/2013.
//  Copyright (c) 2013 AK. All rights reserved.
//



#import "MCOView.h"
#import "UIView+FindUIViewController.h"
#import "ArdoiseViewController.h"
#import "Includes.h"



@implementation MCOView
{
    uint ctr;
    dispatch_queue_t drawingQueue;
    ArdoiseViewController *myController;
}

@synthesize  isDirty;
@synthesize arrayOfLines;
@synthesize incrementalImage;

- (void) initializer
{
    [self setMultipleTouchEnabled:NO];
    
    drawingQueue = dispatch_queue_create("drawingQueue", NULL);
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eraseDrawingOnEvent:)];
//    tap.numberOfTapsRequired = 2; // Tap twice to clear drawing!
//    [self addGestureRecognizer:tap];
    
    [self getUIViewControler];
}

- (ArdoiseViewController *) getUIViewControler
{
    if (! myController)
        myController = (ArdoiseViewController *) [self firstAvailableUIViewController];
    return myController;
}

#pragma mark - init ... 

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initializer];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

#pragma mark - erasing stuff... 

- (void)eraseDrawing
{
    self.arrayOfLines.nbAllTouches=0;
    incrementalImage = nil;
    [self setNeedsDisplay];
}

- (void)eraseDrawingOnEvent:(UITapGestureRecognizer *)t
{
    [self eraseDrawing];
}

#pragma mark - drawing stuff

- (void) drawStuff
{
    dispatch_async(drawingQueue, ^{
        
        @autoreleasepool {
            CGRect bounds = self.bounds;
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
            
            // une alternative
            //CGRect myRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            //[incrementalImage drawInRect:myRect];
            [incrementalImage drawAtPoint:CGPointZero];
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, [[self getUIViewControler] strokeSize] );
            CGContextSetRGBStrokeColor(context, [[self getUIViewControler] red ],[[self getUIViewControler] green   ],[[self getUIViewControler] blue], [[self getUIViewControler] getAlpha]);
            
            
            if ([[self getUIViewControler] isRubberMode])
            {
                CGContextSetBlendMode(context, kCGBlendModeClear);
            }
            else
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
            }
            
            [self.arrayOfLines drawAllLinesInContext:context];
            
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrayOfLines.nbAllTouches=0;
            // encore utile ?
            [self.arrayOfLines currentBecomeFirst];
            
            [self setNeedsDisplay];
        });
    });
}



- (void)drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect];
}


#pragma mark - handling touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"BEGAN");
    
    self.isDirty = TRUE;
    mouseSwiped = NO;
	
    ctr = 0;
    DLog(@"reset ctr");

    NSSet *allTouches = [event allTouches];
    [arrayOfLines addWithSetOfTouches:allTouches andView:self andIsFirstTouch:TRUE andIsMultiTouchEnabled:[[self getUIViewControler] multiTouchEnabled]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"MOVED");

    mouseSwiped = YES;
    
    NSSet *allTouches = [event allTouches];
    [arrayOfLines addWithSetOfTouches:allTouches andView:self andIsFirstTouch:TRUE andIsMultiTouchEnabled:[[self getUIViewControler] multiTouchEnabled]];

    
    ctr++;
    DLog(@"ctr: %d, %d", ctr, self.arrayOfLines.nbAllTouches);
    
    
    if ( ctr % 2 == 0 )
        return;
    
    [self drawStuff];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"ENDED");
    
    NSSet *allTouches = [event allTouches];
    [arrayOfLines addWithSetOfTouches:allTouches andView:self andIsFirstTouch:TRUE andIsMultiTouchEnabled:[[self getUIViewControler] multiTouchEnabled]];
    
    [self drawStuff];
    
    // Stockage pour undo.... rq: la mise à jour du UI needs to be done in mainthread...
    //if ( self.incrementalImage )
    //    [[self getUIViewControler]  pushImage:self.incrementalImage];
    dispatch_async(drawingQueue, ^{
        @autoreleasepool {
            [[self getUIViewControler] pushImage:[[self getUIViewControler ]getUpdatedImage]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ArdoiseViewController * p = [self getUIViewControler];
                p.undoButton.enabled = [p canUndo];
            });
        }
    } );
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog(@"CANCELLED");

    [self touchesEnded:touches withEvent:event];
}





@end
