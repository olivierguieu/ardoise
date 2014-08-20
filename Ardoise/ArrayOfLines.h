//
//  ArrayOfLines.h
//  Ardoise
//
//  Created by Olivier Guieu on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAXTOUCHES 10

@interface ArrayOfLines : NSObject
{
    CGPoint previousTouches1[MAXTOUCHES - 1];
    CGPoint previousTouches2[MAXTOUCHES - 1];
    CGPoint currentTouches[MAXTOUCHES - 1];
    CGPoint allTouches[MAXTOUCHES - 1][100];
    
    
}

@property (nonatomic, assign) int nbFirstTouches;
@property (nonatomic, assign) int nbCurrentTouches;

@property (nonatomic, assign) int nbAllTouches;



- (void) resetTouches;
- (void) currentBecomeFirst;

- (void) addWithSetOfTouches: (NSSet *) allTouches andView: (UIView *) view andIsFirstTouch: (BOOL) bFirst andIsMultiTouchEnabled:(BOOL) bMultiTouch;

- (void) drawAllLinesInContext: (CGContextRef) context;

@end

CGPoint midPoint(CGPoint p1, CGPoint p2);
