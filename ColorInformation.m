//
//  ColorInformation.m
//  Ardoise
//
//  Created by Olivier Guieu on 23/05/2014.
//
//

#import "ColorInformation.h"

@implementation ColorInformation

@synthesize colorHex;
@synthesize colorName;


- (instancetype)initWithName : (NSString *) pColorName andHex: (NSNumber *) pColorHex
{
    self = [super init];
    if (self) {
        self.colorHex = pColorHex;
        self.colorName = pColorName;
    }
    return self;
}
@end
