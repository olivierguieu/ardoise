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
}

@property (nonatomic, assign) int nbFirstTouches;
@property (nonatomic, assign) int nbCurrentTouches;



- (void) resetTouches;
- (void) currentBecomeFirst;
- (void) addOnePoint;

- (void) addWithOneTouch: (UITouch *) touch andView: (UIView *) view andIsFirstTouch: (BOOL) bFirst;
- (void) addWithSetOfTouches: (NSSet *) allTouches andView: (UIView *) view andIsFirstTouch: (BOOL) bFirst;

- (CGRect) currentRect: (float) strokeSize;
- (void) drawAllLinesInContext: (CGContextRef) context;

@end

CGPoint midPoint(CGPoint p1, CGPoint p2);
