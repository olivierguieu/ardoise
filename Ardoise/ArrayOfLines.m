//
//  ArrayOfLines.m
//  Ardoise
//
//  Created by Olivier Guieu on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArrayOfLines.h"
#import "Includes.h"

@implementation ArrayOfLines

@synthesize nbFirstTouches, nbCurrentTouches, nbAllTouches;


#pragma mark - Private Helper function

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

#pragma mark - Handling touches

- (void) resetTouches
{
    nbFirstTouches = 0;
    nbCurrentTouches = 0;
    
    nbAllTouches = 0;
    
    
}

- (void) addWithSetOfTouches: (NSSet *) setAllTouches andView: (UIView *) view  andIsFirstTouch: (BOOL) bFirst andIsMultiTouchEnabled:(BOOL) bMultiTouch
{
    if ( bFirst )
    {
        nbFirstTouches =0;
        for (UITouch * touch in setAllTouches)
        {
            
            previousTouches1[nbFirstTouches]=[touch previousLocationInView:view];
            previousTouches2[nbFirstTouches]=[touch previousLocationInView:view];
            currentTouches[nbFirstTouches] = [touch locationInView:view];
            
            allTouches[nbFirstTouches][(nbAllTouches+1)-1] =[touch previousLocationInView:view];
            allTouches[nbFirstTouches][(nbAllTouches+2)-1] =[touch previousLocationInView:view];
            allTouches[nbFirstTouches][(nbAllTouches+3)-1] =[touch locationInView:view];
            
            nbFirstTouches++;
            
            if ( ! bMultiTouch )
                break;
        }
    }
    else
    {
        CGPoint backup =previousTouches1[nbCurrentTouches];
        nbCurrentTouches = 0;
        for (UITouch * touch in setAllTouches)
        {
            previousTouches2[nbCurrentTouches]  = previousTouches1[nbCurrentTouches];
            previousTouches1[nbCurrentTouches]  = [touch previousLocationInView:view];
            currentTouches[nbCurrentTouches] = [touch locationInView:view];
            
#if 0
            
            allTouches[nbCurrentTouches][nbAllTouches] = allTouches[nbCurrentTouches][nbAllTouches-1];
            nbAllTouches++;
            allTouches[nbCurrentTouches][nbAllTouches++] =[touch previousLocationInView:view];
            allTouches[nbCurrentTouches][nbAllTouches++] = [touch locationInView:view];
#endif
            //if ( nbAllTouches >=  3 )
            {
                if ( nbAllTouches >=  3 )
                {
                    allTouches[nbCurrentTouches][(nbAllTouches+1)-1] = allTouches[nbCurrentTouches][nbAllTouches-1]; // nouveau 1 vaut ancien 3 - aka last location in View
                    
                }
                else
                {
                    //allTouches[nbCurrentTouches][(nbAllTouches+1)-1] =[touch previousLocationInView:view]; // nouveau 1
                    allTouches[nbCurrentTouches][(nbAllTouches+1)-1] = backup;
                }
                
                allTouches[nbCurrentTouches][(nbAllTouches+2)-1] =[touch previousLocationInView:view]; // nouveau 1
                allTouches[nbCurrentTouches][(nbAllTouches+3)-1] = [touch locationInView:view]; // currentTouches - ie nouveau 3
                
                
                DLog(@"allTouches[nbCurrentTouches][(nbAllTouches+1)-1] %f,%f ", allTouches[nbCurrentTouches][(nbAllTouches+1)-1].x, allTouches[nbCurrentTouches][(nbAllTouches+1)-1].y);
                DLog(@"allTouches[nbCurrentTouches][(nbAllTouches+2)-1] %f,%f ", allTouches[nbCurrentTouches][(nbAllTouches+2)-1].x, allTouches[nbCurrentTouches][(nbAllTouches+2)-1].y);
                DLog(@"allTouches[nbCurrentTouches][(nbAllTouches+3)-1] %f,%f ", allTouches[nbCurrentTouches][(nbAllTouches+3)-1].x, allTouches[nbCurrentTouches][(nbAllTouches+3)-1].y);
                
                nbCurrentTouches ++;
            }
            if ( ! bMultiTouch )
                break;
        }
    }
    nbCurrentTouches = [setAllTouches count];
    nbAllTouches += 3;
}

#if 0
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
    
    // test OGU
    @autoreleasepool {
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
}
#endif


- (void) currentBecomeFirst
{
    nbFirstTouches = nbCurrentTouches;
    nbCurrentTouches = 0;
            
}

- (void) drawAllLinesInContext: (CGContextRef) context
{
    if ( nbAllTouches == 0 )
        return;
    
    if ( nbCurrentTouches == nbFirstTouches )
    {
        int i = 0;
        while ( (i <  nbCurrentTouches) && ( i < nbFirstTouches) && ( i < (MAXTOUCHES - 1 ) ) )
        {
#if 0
            CGPoint mid1 = midPoint(previousTouches1[i], previousTouches2[i]);
            CGPoint mid2 = midPoint(currentTouches[i], previousTouches1[i]);

            CGContextMoveToPoint(context, mid1.x, mid1.y);
            // Use QuadCurve is the key
            CGContextAddQuadCurveToPoint(context, previousTouches1[i].x, previousTouches1[i].y, mid2.x, mid2.y); 

            CGContextStrokePath(context);
#endif
            int j=0;
            while ( j< nbAllTouches)
            {
                CGPoint mid1 = midPoint(allTouches[i][j], allTouches[i][j+1]);
                CGPoint mid2 = midPoint(allTouches[i][j+2], allTouches[i][j]);
                
                // on ne le fait qu'au debut ...
                //if ( j==0 )
                    CGContextMoveToPoint(context, allTouches[i][j].x, allTouches[i][j].y);
//                // TEST
//                CGContextMoveToPoint(context, mid1.x, mid1.y);
//                CGContextAddQuadCurveToPoint(context, previousTouches1[i].x, previousTouches1[i].y, mid2.x, mid2.y);
                
               // Use QuadCurve is the key
                // TODO CGContextAddQuadCurveToPoint(context, allTouches[i][j].x, allTouches[i][j].y, mid2.x, mid2.y);
                CGContextAddQuadCurveToPoint(context, mid1.x, mid1.y, allTouches[i][j+2].x, allTouches[i][j+2].y);
                
                DLog(@"Drawing from %f,%f to %f,%f",mid1.x, mid1.y, allTouches[i][j+2].x, allTouches[i][j+2].y);
                
                CGContextStrokePath(context);
                
                j+=3;
            }
            
            i++;
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}
@end
