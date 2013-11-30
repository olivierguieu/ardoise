//
//  RecentImagesController.h
//  Ardoise
//
//  Created by Olivier Guieu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageStuff;
@class ArdoiseViewController;

@interface RecentImagesController : UITableViewController

@property (nonatomic, retain) NSString  * imagesDirectory;
@property (nonatomic, retain) NSMutableArray * arrayOfRecentImagesStuff;
@property (nonatomic, assign) id delegate;

- (void) trashTapped:(id)sender;
- (id)initWithStyle:(UITableViewStyle)style andIsFavorite: (BOOL) bIsFavorite;
@end



@protocol RecentImagesDelegate <NSObject>
- (void)imageSelected:(ImageStuff *)imageStuff;
- (IBAction)displayNewImage:(id)sender;
@end