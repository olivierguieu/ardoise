//
//  FinalAlgView.h
//  VariableStrokeWidthTut
//
//  Created by A Khan on 18/03/2013.
//  Copyright (c) 2013 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArrayOfLines;

@interface MCOView : UIView
{
        BOOL    mouseSwiped;
}

@property (nonatomic, retain) UIImage *incrementalImage;
@property(nonatomic, assign) BOOL isDirty;


// Multitouch handling
@property (nonatomic, retain) ArrayOfLines * arrayOfLines;

- (void)eraseDrawing;

@end
