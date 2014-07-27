//
//  FavoritesViesController.m
//  Ardoise
//
//  Created by Olivier Guieu on 03/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsNavigationViewController.h"
#import "MCOAppDelegate.h"
#import "Includes.h"



@implementation SettingsNavigationViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // define image
        self.tabBarItem.image = [UIImage imageNamed:@"20-gears.png"];
        self.tabBarItem.tag = 3;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

// Call back appelée sur le Done button... version iPhone/iPod touch...
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender
{
    MCOAppDelegate * tmpAppDelegate = [[UIApplication sharedApplication] delegate];
    [tmpAppDelegate.myArdoiseViewController popoverControllerDidDismissPopover:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
