//
//  PresetColorPicker.m
//  Created by http://github.com/iosdeveloper
//

#import "PresetColorPicker.h"

@implementation PresetColorPicker

@synthesize presetColors;
@synthesize delegate;

static const char *colorNameDB = 
"alice blue#0xf0f8ff,antique white#0xfaebd7,aqua#0x00ffff,aqua marine#0x7fffd4,azure#0xf0ffff,"
"beige#0xf5f5dc,bisque#0xffe4c4,black#0x000000,blanched almond#0xffebcd,blue#0x0000ff,"
"blue violet#0x8a2be2,brown#0xa52a2a,burlywood#0xdeb887,cadet blue#0x5f9ea0,chartreuse#0x7fff00,"
"chocolate#0xd2691e,coral#0xff7f50,cornflower blue#0x6495ed,corn silk#0xfff8dc,crimson#0xdc143c,"
"cyan#0x00ffff,dark blue#0x00008b,dark cyan#0x008b8b,dark golden rod#0xb8860b,dark gray#0xa9a9a9,"
"dark green#0x006400,dark grey#0xa9a9a9,dark khaki#0xbdb76b,dark magenta#0x8b008b,"
"dark olive green#0x556b2f,dark orange#0xff8c00,dark orchid#0x9932cc,dark red#0x8b0000,"
"dark salmon#0xe9967a,dark sea green#0x8fbc8f,dark slate blue#0x483d8b,dark slate gray#0x2f4f4f,"
"dark slate grey#0x2f4f4f,dark turquoise#0x00ced1,dark violet#0x9400d3,deep pink#0xff1493,"
"deep sky blue#0x00bfff,dim gray#0x696969,dim grey#0x696969,dodger blue#0x1e90ff,"
"firebrick#0xb22222,floral white#0xfffaf0,forest green#0x228b22,fuchsia#0xff00ff,"
"gainsboro#0xdcdcdc,ghost white#0xf8f8ff,gold#0xffd700,golden rod#0xdaa520,gray#0x808080,"
"green#0x008000,green yellow#0xadff2f,grey#0x808080,honey dew#0xf0fff0,hot pink#0xff69b4,"
"indian red#0xcd5c5c,indigo#0x4b0082,ivory#0xfffff0,khaki#0xf0e68c,lavender#0xe6e6fa,"
"lavender blush#0xfff0f5,lawn green#0x7cfc00,lemon chiffon#0xfffacd,light blue#0xadd8e6,"
"light coral#0xf08080,light cyan#0xe0ffff,light golden rodyellow#0xfafad2,light gray#0xd3d3d3,"
"light green#0x90ee90,light grey#0xd3d3d3,light pink#0xffb6c1,light salmon#0xffa07a,"
"light sea green#0x20b2aa,light sky blue#0x87cefa,light slate gray#0x778899,"
"light slate grey#0x778899,light steel blue#0xb0c4de,light yellow#0xffffe0,lime#0x00ff00,"
"lime green#0x32cd32,linen#0xfaf0e6,magenta#0xff00ff,maroon#0x800000,medium aquamarine#0x66cdaa,"
"medium blue#0x0000cd,medium orchid#0xba55d3,medium purple#0x9370db,medium seagreen#0x3cb371,"
"medium slateblue#0x7b68ee,medium spring green#0x00fa9a,medium turquoise#0x48d1cc,"
"medium violetred#0xc71585,midnight blue#0x191970,mint cream#0xf5fffa,misty rose#0xffe4e1,"
"moccasin#0xffe4b5,navajo white#0xffdead,navy#0x000080,old lace#0xfdf5e6,olive#0x808000,"
"olived rab#0x6b8e23,orange#0xffa500,orangered#0xff4500,orchid#0xda70d6,pale golden rod#0xeee8aa,"
"pale green#0x98fb98,pale turquoise#0xafeeee,pale violetred#0xdb7093,papaya whip#0xffefd5,"
"peachpuff#0xffdab9,peru#0xcd853f,pink#0xffc0cb,plum#0xdda0dd,powder blue#0xb0e0e6,"
"purple#0x800080,red#0xff0000,rosy brown#0xbc8f8f,royal blue#0x4169e1,saddle brown#0x8b4513,"
"salmon#0xfa8072,sandy brown#0xf4a460,sea green#0x2e8b57,seashell#0xfff5ee,sienna#0xa0522d,"
"silver#0xc0c0c0,sky blue#0x87ceeb,slate blue#0x6a5acd,slate grey#0x708090,"
"snow#0xfffafa,spring green#0x00ff7f,steel blue#0x4682b4,tan#0xd2b48c,teal#0x008080,"
"thistle#0xd8bfd8,tomato#0xff6347,turquoise#0x40e0d0,violet#0xee82ee,wheat#0xf5deb3,"
"white#0xffffff,white smoke#0xf5f5f5,yellow#0xffff00,yellow green#0x9acd32";

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (UIColor *)colorWithRGBHexString:(NSString *)hexString 
{
    int hex;
    sscanf([hexString UTF8String], "%x", &hex);
    
    return [self colorWithRGBHex:hex];
}



- (id)init
{
    if (self = [super init])
    {
        
// if necessary
        
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[[self tableView] setBackgroundColor:[UIColor blackColor]];
    
    if (_refreshHeaderView == nil) {
        
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] 
                                           initWithFrame:CGRectMake(0.0f, 
                                                                    0.0f - self.tableView.bounds.size.height, 
                                                                    self.view.frame.size.width, 
                                                                    self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
        
	}
 
}

- (void)switchColorsArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];       
    BOOL selectedOption = [defaults boolForKey:@"LARGE_CHOICE_OF_COLORS"];
    
    if ( selectedOption == TRUE )
    {
        NSMutableArray *arrayOfColorName = [[NSMutableArray alloc] initWithCapacity:150];
        NSMutableArray *arrayOfUIColor = [[NSMutableArray alloc] initWithCapacity:150];
        
        const char *ptr = colorNameDB;
        char field [ 32 ];
        int n;
        while ( sscanf(ptr, "%31[^,]%n", field, &n) == 1 )
        {
            NSString * tmpString = [[NSString alloc] initWithUTF8String:field];
            NSArray *lines = [tmpString componentsSeparatedByString:@"#"];
            
            //NSLog(@"%@",[lines objectAtIndex:0] );
            //NSLog(@"%@",[lines objectAtIndex:1] );
            
            [arrayOfColorName addObject:[[lines objectAtIndex:0] capitalizedString]];
            [arrayOfUIColor addObject:[self colorWithRGBHexString:[lines objectAtIndex:1]]];
            
            [tmpString release];
            
            // printf("field = \"%s\"\n", field);
            
            ptr += n; /* advance the pointer by the number of characters read */
            if ( *ptr != ',' )
            {
                break; /* didn't find an expected delimiter, done? */
            }
            ++ptr; /* skip the delimiter */
        }
        
        [arrayOfColorName addObjectsFromArray:arrayOfUIColor];
        presetColors = [[NSMutableArray alloc] initWithArray:arrayOfColorName];
        
        [arrayOfColorName release];
        [arrayOfUIColor release];
        
    }
    else
    {
        self.presetColors = [NSArray arrayWithObjects:
                             NSLocalizedString(@"Black", nil),
                             NSLocalizedString(@"Dark Grey", nil),
                             NSLocalizedString(@"Light Grey", nil),
                             NSLocalizedString(@"Grey", nil),
                             NSLocalizedString(@"White", nil),
                             NSLocalizedString(@"Red", nil),
                             NSLocalizedString(@"Green", nil),
                             NSLocalizedString(@"Blue", nil),
                             NSLocalizedString(@"Cyan", nil),
                             NSLocalizedString(@"Yellow", nil),
                             NSLocalizedString(@"Magenta", nil),
                             NSLocalizedString(@"Orange", nil),
                             NSLocalizedString(@"Purple", nil),
                             NSLocalizedString(@"Chocolate", nil),
                             [UIColor blackColor],
                             [UIColor darkGrayColor],
                             [UIColor lightGrayColor],
                             [UIColor grayColor],
                             [UIColor whiteColor],
                             [UIColor redColor],
                             [UIColor greenColor],
                             [UIColor blueColor],
                             [UIColor cyanColor],
                             [UIColor yellowColor],
                             [UIColor magentaColor],
                             [UIColor orangeColor],
                             [UIColor purpleColor],
                             [UIColor brownColor],
                             nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self switchColorsArray];  
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
    return [[self presetColors] count] / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [[cell textLabel] setText:[[self presetColors] objectAtIndex:[indexPath row]]];
	[[cell textLabel] setTextColor:[UIColor whiteColor]];
	
	CGRect rect = CGRectMake(0.0, 0.0, 88.0, [tableView rowHeight]);
	
	UIGraphicsBeginImageContext(rect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [[[self presetColors] objectAtIndex:[[self presetColors] count] / 2 + [indexPath row]] CGColor]);
	
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	[[cell imageView] setImage:image];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [delegate colorSelected:[[self presetColors] objectAtIndex:[[self presetColors] count] / 2 + [indexPath row]]];
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    [self switchColorsArray];

    
    [[self tableView] reloadData];
    
    [self doneLoadingTableViewData];
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];       
    BOOL selectedOption = [defaults boolForKey:@"LARGE_CHOICE_OF_COLORS"];
    [defaults setBool:!selectedOption forKey:@"LARGE_CHOICE_OF_COLORS"];
    
    
	[self performSelectorOnMainThread:@selector(reloadTableViewDataSource) withObject:nil waitUntilDone:NO];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
    
}


@end