//
//  RecentImagesController.m
//  Ardoise
//
//  Created by Olivier Guieu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentImagesController.h"
#import "Includes.h"
#import "MCOAppDelegate.h"
#import "RecentImagesTableViewCell.h"
#import "CustomCell.h"

@implementation RecentImagesController

@synthesize arrayOfRecentImagesStuff;
@synthesize delegate;
@synthesize imagesDirectory;


NSString * const REUSE_ID_CELL = @"CustomCell";

- (void) registerNIBs
{
    NSBundle *classBundle = [NSBundle bundleForClass:[CustomCell class]];

    UINib *cellNib = [UINib nibWithNibName:REUSE_ID_CELL bundle:classBundle];
    [[self tableView] registerNib:cellNib forCellReuseIdentifier:REUSE_ID_CELL];
    
}

- (id)initWithStyle:(UITableViewStyle)style andIsFavorite: (BOOL) bIsFavorite
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if ( bIsFavorite )
        {
            self.title = NSLocalizedString(@"Favorites", nil);
 
            self.imagesDirectory = kFavoritesDirectory;
            self.tabBarItem.image = [UIImage imageNamed:@"SmallStarButtonBar.png"];
            self.tabBarItem.tag = 2;
            
        }
        else
        {
            self.title = NSLocalizedString(@"Last Images", nil);
            
            self.imagesDirectory = kImagesDirectory;
            self.tabBarItem.image = [UIImage imageNamed:@"06-magnify.png"];
            self.tabBarItem.tag = 1;            
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [arrayOfRecentImagesStuff release];
    [imagesDirectory release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashTapped:)] autorelease];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissTabBar:)] autorelease];
        
    }
    
    self.tableView.rowHeight = 160;
    
    [self registerNIBs];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray * tmpListOfImagesStuffIndirectory = [FileOperations getArrayOfImagesStuffInDirectory:self.imagesDirectory];
    self.arrayOfRecentImagesStuff = [tmpListOfImagesStuffIndirectory retain];        
    [tmpListOfImagesStuffIndirectory release];

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) dismissTabBar:(id) sender
{
    MCOAppDelegate * tmpAppDelegate = [[UIApplication sharedApplication] delegate];
    [tmpAppDelegate.myArdoiseViewController setUpArdoiseView];
    
    [self dismissModalViewControllerAnimated:YES]; 
}

- (void) trashTapped:(id)sender
{
    for (ImageStuff *tmpStuff  in arrayOfRecentImagesStuff) 
    {
        [FileOperations deleteFile:tmpStuff.imageFileName andDirectory: self.imagesDirectory];
    }

    // Remove from Array...
    [self.arrayOfRecentImagesStuff removeAllObjects];     
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfRecentImagesStuff count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:REUSE_ID_CELL];
    
    // Configure the cell...
    ImageStuff *tmpStuff = [arrayOfRecentImagesStuff objectAtIndex:indexPath.row];

    [[cell imageView] setImage:[[UIImage alloc] initWithData:tmpStuff.imageData]];
    [[cell label] setText:[tmpStuff.timeStamp stringByReplacingOccurrencesOfString:@"_" withString:@" " ]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // DLog(@"%d", [arrayOfRecentImagesStuff count]);
        
        // Delete File
        ImageStuff *tmpStuff = [arrayOfRecentImagesStuff objectAtIndex:indexPath.row];
        [FileOperations deleteFile:tmpStuff.imageFileName andDirectory:self.imagesDirectory];
        
        // on verifie si c'est l'image courante       
        ArdoiseViewController * myArdoiseViewController= (ArdoiseViewController *) self.delegate;
        
        if ( [myArdoiseViewController.imageStuff.imageFileName isEqualToString:tmpStuff.imageFileName] )
        {
            // on force l image a zero
            [self.delegate displayNewImage:nil];
        }
        
        // Remove from Array...
        [self.arrayOfRecentImagesStuff removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    [self.delegate imageSelected:[self.arrayOfRecentImagesStuff objectAtIndex:indexPath.row]];
    
    // fermer la vu modale en mode iphone
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self dismissTabBar:nil];
    }
        
}

@end
