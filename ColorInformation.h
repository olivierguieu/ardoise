//
//  ColorInformation.h
//  Ardoise
//
//  Created by Olivier Guieu on 23/05/2014.
//
//

#import <Foundation/Foundation.h>

@interface ColorInformation : NSObject

@property (retain, readwrite) NSString *colorName;
@property (retain, readwrite) NSNumber *colorHex;

- (instancetype)initWithName : (NSString *) pColorName andHex: (NSNumber *) pColorHex;

@end
