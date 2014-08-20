//
//  PresetColorPicker.m
//  Created by http://github.com/iosdeveloper
//

#import "PresetColorPickerController.h"
#import "ColorInformation.h"


@implementation PresetColorPickerController

@synthesize delegate;


static const char *colorNameDB = "black#0x000000,darkgray#0xa9a9a9,lightgray#0xd3d3d3,gray#0x808080,white#0xffffff,red#0xff0000,green#0x008000,blue#0x0000ff,cyan#0x00ffff,yellow#0xffff00,magenta#0xff00ff,orange#0xffa500,purple#0x800080,brown#0xa52a2a";


static NSMutableArray *arrayOfColorInformation = nil;

+ (id)getArrayOfColorInformation
{
    if (arrayOfColorInformation == nil)
    {
        arrayOfColorInformation = [[NSMutableArray alloc] initWithCapacity:150];
        const char *ptr = colorNameDB;
        char field [ 32 ];
        int n;

        while ( sscanf(ptr, "%31[^,]%n", field, &n) == 1 )
        {
            NSString * tmpString = [[NSString alloc] initWithUTF8String:field];
            NSArray *lines = [tmpString componentsSeparatedByString:@"#"];
            
            int hex;
            sscanf([[lines objectAtIndex:1] UTF8String], "%x", &hex);
            
            ColorInformation *colorInformation = [[ColorInformation alloc] initWithName:[[lines objectAtIndex:0] capitalizedString] andHex:[NSNumber numberWithInt:hex]];
            [arrayOfColorInformation addObject:colorInformation];
            
            
            [tmpString release];
            
            
            ptr += n; /* advance the pointer by the number of characters read */
            if ( *ptr != ',' )
            {
                break; /* didn't find an expected delimiter, done? */
            }
            ++ptr; /* skip the delimiter */
        }
    }
    return arrayOfColorInformation;
}

+ (UInt32)colorWithRGBHexFromName:(NSString *)colorName
{
    arrayOfColorInformation = [PresetColorPickerController getArrayOfColorInformation];
    
    __block long int index = -1;
    __block long int blackIndex = -1;
    
    [arrayOfColorInformation enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        // do something with object
        NSString *currentColorName =[((ColorInformation *) object) colorName];
        
        if ( [currentColorName caseInsensitiveCompare:colorName] == NSOrderedSame)
            index = idx;
        
        if ( [currentColorName caseInsensitiveCompare:@"black"] == NSOrderedSame)
            blackIndex = idx;
    }];

    
    if ( index == -1 )
    {
        index = blackIndex;
    }
    
    NSAssert(index > -1, @"Color Not Found !");
    
    ColorInformation *colorInformation = [arrayOfColorInformation objectAtIndex:index];
    return [ colorInformation.colorHex intValue];
}

+ (UIColor *)colorFromName:(NSString *)colorName
{
    if ( [colorName caseInsensitiveCompare:@"clearcolor"] == 0 )
    {
        return [UIColor clearColor];
    }
    else
    {
        return [self colorWithRGBHex:[self colorWithRGBHexFromName:colorName]];
    }
}


+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHexString:(NSString *)hexString
{
    int hex;
    sscanf([hexString UTF8String], "%x", &hex);
    
    return [self colorWithRGBHex:hex];
}



- (id)init
{
    if (self = [super init])
    {
        // init array of colors...
        [PresetColorPickerController getArrayOfColorInformation];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[PresetColorPickerController getArrayOfColorInformation] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ColorInformation *colorInformation = [[PresetColorPickerController getArrayOfColorInformation] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[colorInformation.colorName capitalizedString]];
	
	CGRect rect = CGRectMake(0.0, 0.0, 88.0, [tableView rowHeight]);
	
    // ajout OGU - cf http://stackoverflow.com/questions/19167732/coregraphics-drawing-causes-memory-warnings-crash-on-ios-7
    @autoreleasepool
    {
        UIGraphicsBeginImageContext(rect.size);
	
        CGContextRef context = UIGraphicsGetCurrentContext();
	
        CGContextSetFillColorWithColor(context, [[PresetColorPickerController colorWithRGBHex:[colorInformation.colorHex integerValue]] CGColor]);
	
        CGContextFillRect(context, rect);
	
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
        UIGraphicsEndImageContext();
   
	
        [[cell imageView] setImage:image];
    }
    
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorInformation *colorInformation = [[PresetColorPickerController getArrayOfColorInformation] objectAtIndex:[indexPath row]];
    
	[delegate colorNameSelected:[colorInformation colorName]];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end