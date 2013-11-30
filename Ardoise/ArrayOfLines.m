//
//  ArrayOfLines.m
//  Ardoise
//
//  Created by Olivier Guieu on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArrayOfLines.h"

@implementation ArrayOfLines

@synthesize nbFirstTouches, nbCurrentTouches;


#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (id)init
{
    self = [super init];
        if (self) {
            [self resetTouches];
        }
        return self; 
}
- (void) resetTouches
{
    nbFirstTouches = 0;
    nbCurrentTouches = 0;
}

- (void) addWithOneTouch: (UITouch *) touch andView: (UIView *) view  andIsFirstTouch: (BOOL) bFirst
{
    if ( bFirst )
    {
        nbFirstTouches =0;
        previousTouches1[nbFirstTouches]=[touch previousLocationInView:view];
        previousTouches2[nbFirstTouches]=[touch previousLocationInView:view];
        currentTouches[nbFirstTouches] = [touch locationInView:view];
        nbFirstTouches = 1;
        
    }
    else
    {
        nbCurrentTouches = 0;        
        previousTouches2[nbCurrentTouches]  = previousTouches1[nbCurrentTouches];
        previousTouches1[nbCurrentTouches]  = [touch previousLocationInView:view];
        currentTouches[nbCurrentTouches] = [touch locationInView:view];
        nbCurrentTouches = 1;
    }

}


- (void) addWithSetOfTouches: (NSSet *) allTouches andView: (UIView *) view  andIsFirstTouch: (BOOL) bFirst
{
    if ( bFirst )
    {
        nbFirstTouches = 0;
        for (UITouch * touch in allTouches) 
        {
            previousTouches1[nbFirstTouches]=[touch previousLocationInView:view];
            previousTouches2[nbFirstTouches]=[touch previousLocationInView:view];
            currentTouches[nbFirstTouches] = [touch locationInView:view];
       
            nbFirstTouches++;
        }
    }
    else
    {
        nbCurrentTouches = 0;
        for (UITouch * touch in allTouches) 
        {
            previousTouches2[nbCurrentTouches]  = previousTouches1[nbCurrentTouches];
            previousTouches1[nbCurrentTouches]  = [touch previousLocationInView:view];
            currentTouches[nbCurrentTouches] = [touch locationInView:view];
            
            nbCurrentTouches++;

        }
    }
}

- (CGRect) getRect: (int) i  andStrokeSize : (float) strokeSize
{
    // calculate mid point
    CGPoint mid1    = midPoint(previousTouches1[i], previousTouches2[i]); 
    CGPoint mid2    = midPoint(currentTouches[i], previousTouches1[i]);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousTouches1[i].x, previousTouches1[i].y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= strokeSize * 2;
    drawBox.origin.y        -= strokeSize * 2;
    drawBox.size.width      += strokeSize * 4;
    drawBox.size.height     += strokeSize * 4;
    
    return drawBox;
}

- (void) addOnePoint
{
    if (nbFirstTouches == 1)
    {
        nbCurrentTouches=1;
        currentTouches[0] = previousTouches1[0];
    }
}


- (void) currentBecomeFirst
{
    nbFirstTouches = nbCurrentTouches;
    nbCurrentTouches = 0;
            
}

- (CGRect)currentRect: (float) strokeSize {
    
    if (nbCurrentTouches == 0 && nbFirstTouches == 0)
        return CGRectMake(0, 0, 0, 0);
    
    CGRect rect = [self getRect:0 andStrokeSize:strokeSize];
    
    int i = 1;
    while ( (i < nbCurrentTouches) && (i < nbFirstTouches) && ( i < (MAXTOUCHES - 1 )  ) )
    {
        rect = CGRectUnion(rect, [self getRect:i andStrokeSize:strokeSize]);
        i++;
    }
    return rect;
}

- (void) drawAllLinesInContext: (CGContextRef) context
{
    if ( nbCurrentTouches == nbFirstTouches )
    {
        int i = 0;
        while ( (i <  nbCurrentTouches) && ( i < nbFirstTouches) && ( i < (MAXTOUCHES - 1 ) ) )
        {
            CGPoint mid1 = midPoint(previousTouches1[i], previousTouches2[i]); 
            CGPoint mid2 = midPoint(currentTouches[i], previousTouches1[i]);

            CGContextMoveToPoint(context, mid1.x, mid1.y);
            // Use QuadCurve is the key
            CGContextAddQuadCurveToPoint(context, previousTouches1[i].x, previousTouches1[i].y, mid2.x, mid2.y); 

            CGContextStrokePath(context);
 
            i++;
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}
@end
