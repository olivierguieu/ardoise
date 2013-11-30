//
//  CustomCell.m
//  Ardoise
//
//  Created by olivier guieu on 11/3/12.
//
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize imageView, textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [imageView release];
    [textLabel release];
    
    [super dealloc];
}

@end
