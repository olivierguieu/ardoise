//
//  ArdoiseViewController.m
//  Ardoise
//
//  Created by Olivier Guieu on 01/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArdoiseViewController.h"
#import "Includes.h"
#import "IASKAppSettingsViewController.h"
#import <Twitter/Twitter.h>
//#import <UIColor.h>

#define SHARE_ALERTVIEW_TAG             8


@implementation ArdoiseViewController

@synthesize ardoiseToolbar;
@synthesize rubberButton, colorButton, shareButton, favoritesButton, undoButton;

@synthesize colorPicker, colorPickerPopover;
@synthesize recentImages, recentImagesPopover;

@synthesize myTabBarControllerinModalViewController;
@synthesize tempDrawImage, mainImage;

@synthesize insideView;
@synthesize red,green,blue,alpha;
@synthesize isRubberMode, isDirty;
@synthesize multiTouchEnabled;
@synthesize strokeSize, rubberSize, opacity;

@synthesize arrayOfLines;
@synthesize imageStuff;
@synthesize undoArrayOfImages;

- (void)dealloc
{
    [insideView release];
    
    [ardoiseToolbar release];
    
    [rubberButton release];
    [colorButton release];
    [shareButton release];
    [favoritesButton release];
    [undoButton release];
    
    [colorPicker release];
    [colorPickerPopover release];
    
    [recentImages release];
    [recentImagesPopover release];
    
    [myTabBarControllerinModalViewController release];
    
    [tempDrawImage release];
    [mainImage release];
    
    [arrayOfLines release];
    
    [imageStuff release];
    
    [undoArrayOfImages release];
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
    // TODO release array of undo images
    DLog(@"Releasing undo data");
    [self resetUndo];
    self.undoButton.enabled = [self canUndo];
}



#pragma mark - View lifecycle

- (void)setUpArdoiseView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *selectedOption;
    
    selectedOption= [defaults objectForKey:@"CHALK_SIZE"];
    self.strokeSize = [selectedOption floatValue];
    
    selectedOption= [defaults objectForKey:@"OPACITY"];
    self.opacity = [selectedOption floatValue];
    
    selectedOption = [defaults objectForKey:@"RUBBER_SIZE"];
    self.rubberSize = [selectedOption floatValue];
    
    self.multiTouchEnabled = [defaults boolForKey:@"MULTI_TOUCH_ENABLED"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.colorButton.title = NSLocalizedString(@"Colors !",nil);  
    }
    else 
    {
        self.colorButton.title = NSLocalizedString(@" ",nil);  
    }
    
    [self colorSelected:[UIColor whiteColor]];
    
    self.isDirty = FALSE;    
    self.imageStuff = [[ImageStuff alloc] init];
    self.arrayOfLines = [[ArrayOfLines alloc] init];
    
    self.undoArrayOfImages = [[NSMutableArray alloc] initWithCapacity:10];
    self.undoButton.enabled = [self canUndo];
    
    [self applyDefaultBackground];
    
    [self setUpArdoiseView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // ok depuis le passage par les 2 UIImageView
    return YES;
}

// added for IOS 6...
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSInteger)supportedInterfaceOrientations{
    NSInteger mask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        mask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return mask;
}



#pragma mark - undoManagement
- (void) pushImage: (UIImage *) image
{
    if ( ! self.undoArrayOfImages)
        self.undoArrayOfImages = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self.undoArrayOfImages addObject:image];
}

- (UIImage *) popImage 
{
  // todo ... NSAssert(<#condition#>, <#desc, ...#>)
    UIImage *res;
    res = [self.undoArrayOfImages objectAtIndex:([self.undoArrayOfImages count]-1)];
    [res retain];
    [self.undoArrayOfImages removeLastObject];
    return res;
}

- (BOOL) canUndo
{
    BOOL res = FALSE;
    
    if ( self.undoArrayOfImages && [ self.undoArrayOfImages count] )
        res = TRUE;
    return res;
}

- (void) resetUndo
{
    if ([self canUndo])
     [self.undoArrayOfImages removeAllObjects];
    
    [self.undoArrayOfImages release];
    self.undoArrayOfImages = nil;
}


#pragma mark - background color

- (NSString *) applyDefaultBackground
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *option = [defaults stringForKey:@"BackgroundColor"];
    
    if ( option  == nil)
    {
        [self applyBackGroundColor:@"blackColor"];
    }
    else
    {
        [self applyBackGroundColor:option];
    }
    return option;
}

- ( UIColor * ) getUIColorFromString : (NSString *) nameOfColor
{
    SEL blackSel = NSSelectorFromString(nameOfColor);
    UIColor* tColor = nil;
    if ([UIColor respondsToSelector: blackSel])
        tColor  = [UIColor performSelector:blackSel];
    return tColor;
}

- (void) applyBackGroundColor: (NSString*) backgroundColor
{
    self.imageStuff.backgroundColor = backgroundColor;
    self.mainImage.backgroundColor = [self getUIColorFromString: backgroundColor];
}


#pragma mark - applying new stuff/image

- (void) applyImageStuff: (ImageStuff*) newImageStuff
{
    [self resetUndo];
    
    self.isDirty = FALSE;
    
    [self.imageStuff applyAnotherImageStuff:newImageStuff];
    
    if ( self.imageStuff.imageFileName == nil)
    {
        self.mainImage.image = nil;        
    }
    else
    {
        UIImage *tmpImage = [[UIImage alloc] initWithData:self.imageStuff.imageData];
        self.mainImage.image = tmpImage;
        [tmpImage release];
    }
    
    [self applyBackGroundColor:self.imageStuff.backgroundColor];
}

#pragma mark - colorPicker
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void) updateColorComponents:(UIColor*) color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    
    self.red = components[0];
    self.green = components[1];
    self.blue = components[2];
    self.alpha = 1.0;
}

#pragma mark - Alpha

-(float) getAlpha
{
    return ( ( self.isRubberMode) ? 1.0: opacity);
}

#pragma mark - StrokeSize

-(float) getStrokeSize
{
    return ((self.isRubberMode ) ? self.rubberSize : 1 ) * self.strokeSize;
}

- (UIImage *) getUpdatedImage
{
    UIGraphicsBeginImageContext(self.insideView.frame.size);
   [self.insideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
    
    
    // le code ci dessous ne retourne pas le background !!! ...
    //return self.mainImage.image;
}

#pragma mark Handling touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDirty = TRUE;
    mouseSwiped = NO;
	
    NSSet *allTouches = [event allTouches];
    if (([allTouches count] > 1 ) && ( self.multiTouchEnabled == TRUE ) )
    {
        [arrayOfLines addWithSetOfTouches:allTouches andView:self.insideView andIsFirstTouch:TRUE];
    }
    else
    {
        UITouch *touch = [touches anyObject];
        [arrayOfLines addWithOneTouch:touch  andView:self.insideView andIsFirstTouch:TRUE];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;    
    NSSet *allTouches = [event allTouches];
    if (([allTouches count] > 1) && (self.multiTouchEnabled == TRUE) )
    {
        [arrayOfLines addWithSetOfTouches:allTouches andView:self.insideView andIsFirstTouch:FALSE];
    }
    else
    {
        UITouch *touch = [touches anyObject];
        [arrayOfLines addWithOneTouch:touch  andView:self.insideView andIsFirstTouch:FALSE];
    }
    
    UIGraphicsBeginImageContext(self.insideView.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.insideView.frame.size.width, self.insideView.frame.size.height)];

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self.arrayOfLines drawAllLinesInContext:context];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, [self getStrokeSize] );
    CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, 1.0);
    

    CGContextSetBlendMode(context, kCGBlendModeNormal);

    [self.arrayOfLines drawAllLinesInContext:context];

    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:[self getAlpha]];
    UIGraphicsEndImageContext();
    
    [self.arrayOfLines currentBecomeFirst];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    
    
    if ([allTouches count] == 1 )
    {
        // lors le bouton undo est disabled, les clicks dessus sont transmis à la feneêtre du dessus...
        // on les ignore
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        if (! CGRectContainsPoint(self.insideView.frame, touchLocation)) {
            NSLog(@"Tapped not in image view");
            return;
        }
    }
    
    
    if ([allTouches count] == 1 )
    {
        // cas du point unique !
        if ( !mouseSwiped )
        {
            [arrayOfLines addOnePoint];
        }
    }


    if(!mouseSwiped)
    {
        UIGraphicsBeginImageContext(self.insideView.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.insideView.frame.size.width, self.insideView.frame.size.height)];
  
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, [self getStrokeSize] );

        if (self.isRubberMode)
        {
            CGContextSetBlendMode(context, kCGBlendModeClear);
        }
        else
        {
            CGContextSetBlendMode(context, kCGBlendModeNormal);
        }

        CGContextSetRGBStrokeColor(context, self.red, self.green, self.blue, [self getAlpha]);
        
        [self.arrayOfLines drawAllLinesInContext:context];
        
        CGContextFlush(context);
        
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.insideView.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.insideView.frame.size.width, self.insideView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.insideView.frame.size.width, self.insideView.frame.size.height) blendMode:kCGBlendModeNormal alpha:[self getAlpha]];

    
    
    // Stockage pour undo....
    if ( self.mainImage.image )
        [self pushImage:self.mainImage.image];
    else
    {
        UIImage *tmpImage = [[UIImage alloc] init];
        [self pushImage:tmpImage];
    }
    
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    self.undoButton.enabled = [self canUndo];
}


                                                                                                                                            

                                                                                                                                           

#pragma mark - undoButton...

- (IBAction)undoButtonTapped:(id)sender
{
    DLog("init");
    self.mainImage.image = [self popImage];
    self.undoButton.enabled = [self canUndo];
}



#pragma mark - RubberMode

- (IBAction)toggleRubberMode:(id)sender
{
    self.isRubberMode = !self.isRubberMode;
    self.rubberButton.selected = self.isRubberMode;
    self.colorButton.enabled = !self.isRubberMode;
    
    if ( isRubberMode)
    {
        if ( self.imageStuff!= nil && self.imageStuff.backgroundColor != nil )
        // MAJ des red/green...
            [self updateColorComponents:[self getUIColorFromString:self.imageStuff.backgroundColor]];
        else
            [self updateColorComponents:[UIColor whiteColor]];
    }
    else
    {
        // MAJ des red/green...
        [self updateColorComponents:self.currentColor];
    }
}


#pragma mark - preventing simultaneous popups... HandleOtherPopupsDelegate... 
- (void) enableAllOtherPopups:(Boolean) enable
{
    self.colorButton.enabled = enable;
    self.favoritesButton.enabled = enable;
}

- (void) closeAllPopover
{    
    // on les 2 popover si besoin
    if ( [self.recentImagesPopover isPopoverVisible] )
    {
        [self.recentImagesPopover dismissPopoverAnimated:YES];    
        return;
    }
    
    // on cache l'autre popover si besoin
    if ( [self.colorPickerPopover isPopoverVisible])
    {
        [self.colorPickerPopover dismissPopoverAnimated:YES];             
    }
}


#pragma mark - shareButton
- (IBAction)shareButtonTapped:(id) sender
{
    [self closeAllPopover];
    UIActionSheet *popupQuery;
    
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] )
    {
        /// iOS6 is installed
        popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share...",nil) delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Mail it",nil) , NSLocalizedString(@"Tweet it",nil) , NSLocalizedString(@"on Facebook",nil) , NSLocalizedString(@"Save to Camera Roll",nil),nil];
        
    }
    else if ( 5 == [[versionCompatibility objectAtIndex:0] intValue] )
    {
        popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share...",nil) delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Mail it",nil) , NSLocalizedString(@"Tweet it",nil) , NSLocalizedString(@"Save to Camera Roll", nil),nil];
    }
    else
    {
        popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share...",nil) delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Mail it",nil), NSLocalizedString(@"Save to Camera Roll", nil), nil];
        
    }
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    popupQuery.tag = SHARE_ALERTVIEW_TAG;
    
    
	[popupQuery showInView:self.view];
	[popupQuery release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet.tag == SHARE_ALERTVIEW_TAG)
    {
        NSLog(@"buttonIndex<%d>", buttonIndex);
        
        NSString *strTitle = NSLocalizedString(@"Look at this picture!",nil);
        
        NSString *strButtonPressed= [actionSheet buttonTitleAtIndex:buttonIndex];
        NSLog(@"title buttonIndex<%@>", strButtonPressed);
      
        if ( ![strButtonPressed compare:NSLocalizedString(@"Mail it",nil)] && [MFMailComposeViewController canSendMail]) {
            //Mail it clicked
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:strTitle];
            
            
            //            // Set up recipients
            //            NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
            //            NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
            //            NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
            //
            //            [picker setToRecipients:toRecipients];
            //            [picker setCcRecipients:ccRecipients];
            //            [picker setBccRecipients:bccRecipients];
            
            
            [self updateCurrentImageStuffandSaveIt: FALSE];
            [picker addAttachmentData:self.imageStuff.imageData mimeType:@"image/png" fileName:(self.imageStuff.imageFileName == nil ) ? @"none.png" : self.imageStuff.imageFileName];
            
            // Fill out the email body text
            [picker setMessageBody:strTitle isHTML:YES];
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
        }
        if (![strButtonPressed compare:NSLocalizedString(@"Tweet it",nil)] )
        {
            //Tweet it clicked
            if ([TWTweetComposeViewController canSendTweet])
            {
                TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
                [tweetSheet setInitialText:strTitle];
                
                [tweetSheet addImage:[self getUpdatedImage]];
                
                [self presentModalViewController:tweetSheet animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry",nil)
                                                                    message:NSLocalizedString(@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" , nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }

        if (![strButtonPressed compare:NSLocalizedString(@"Save to Camera Roll",nil)] )
        {
            UIImageWriteToSavedPhotosAlbum([self getUpdatedImage], self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        if (![strButtonPressed compare:NSLocalizedString(@"on Facebook",nil)] )
        {
            NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
            
            if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] )
            {
                //Facebook  it clicked
                
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    
                    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    [controller setInitialText:strTitle];
                    [controller addImage:[self getUpdatedImage]];
                    
                    [self presentViewController:controller animated:YES completion:Nil];
                    
                    
                    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                        NSString *output= nil;
                        switch (result) {
                            case SLComposeViewControllerResultCancelled:
                                output= NSLocalizedString(@"Action Cancelled", nil);
                                NSLog (@"cancelled");
                                break;
                            case SLComposeViewControllerResultDone:
                                output= NSLocalizedString(@"Post Successful", nil);
                                NSLog (@"success");
                                break;
                            default:
                                break;
                        }
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        [controller dismissViewControllerAnimated:YES completion:Nil];
                    };
                    controller.completionHandler =myBlock;
                }
            }
        }
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    // Was there an error?
    if (error != NULL)
    {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry",nil) message:NSLocalizedString(@"Image could not be saved.Please try again",nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil) message:NSLocalizedString(@"Image was successfully saved in photoalbum", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    }
    [alert show];
    [alert release];
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}




#pragma mark - Images management

- (void) saveCurrentImageStuff
{
    [self updateCurrentImageStuffandSaveIt: TRUE];
}

- (void) updateCurrentImageStuffandSaveIt: (BOOL) bSaveIt
{
    self.imageStuff.imageData = [NSData dataWithData:UIImagePNGRepresentation([self getUpdatedImage])];
    if ( bSaveIt )  [self.imageStuff  saveToFileAndOverWriteDirtyStatus:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setUpArdoiseView];
    
    // si l'image n'a pas éte modifiee on change la couleur du  fonds...
    if ( self.isDirty == FALSE )
    {
        [self applyDefaultBackground];
    }
}


#pragma mark - PreviousDrawings

- (IBAction) displayHistoryandSettings:(id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self closeAllPopover];
        
        if ( self.recentImagesPopover == nil )
        {
            // Les Favoris
            ///////////////
            
            RecentImagesController *myImagesViewController2 = [[RecentImagesController alloc] initWithStyle:UITableViewStylePlain andIsFavorite:TRUE] ;
            myImagesViewController2.delegate = self;
            
            UINavigationController *myFavoritesNavigationController = [[[UINavigationController alloc] init] autorelease];
            [myFavoritesNavigationController pushViewController:myImagesViewController2 animated:FALSE];
            
            
            // Les Settings
            /////////////////
            
            SettingsNavigationViewController *mySettingsNavigationViewController = [[SettingsNavigationViewController alloc] init] ;
            mySettingsNavigationViewController.delegate = self;
            
            IASKAppSettingsViewController * mySecondViewController  = [[[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil] autorelease];
            mySecondViewController.showDoneButton = NO;
            mySecondViewController.title= NSLocalizedString(@"Settings", nil);
            mySecondViewController.delegate = self; // ATTENTION different ds iPod...
            
            
            [mySettingsNavigationViewController pushViewController:mySecondViewController animated:FALSE];
            
            
            // La Toolbar
            ///////////////
            
            UITabBarController *myTabBarController = [[[UITabBarController alloc] init] autorelease];
            myTabBarController.viewControllers = [NSArray arrayWithObjects:myFavoritesNavigationController, mySettingsNavigationViewController, nil];
            
            
            // CleanUp
            [myImagesViewController2 release];
            [mySettingsNavigationViewController release];
            
            
            // On peut désormais affecter & afficher le Popover
            /////////////////////////////////////////////////////
            
            self.recentImagesPopover = [[UIPopoverController alloc] initWithContentViewController:myTabBarController];
            self.recentImagesPopover.delegate = self;
        }
        
        
        [self.recentImagesPopover  presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        self.recentImagesPopover = nil;
        
        // Les Settings
        /////////////////
        
        SettingsNavigationViewController *mySettingsNavigationViewController = [[SettingsNavigationViewController alloc] init] ;
        mySettingsNavigationViewController.delegate = self;
        
        IASKAppSettingsViewController * mySecondViewController  = [[[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil] autorelease];
        mySecondViewController.showDoneButton = YES;
        mySecondViewController.title= NSLocalizedString(@"Settings",nil);
        mySecondViewController.delegate = mySettingsNavigationViewController;
        
        
        [mySettingsNavigationViewController pushViewController:mySecondViewController animated:FALSE];

        // Les Favoris
        ///////////////
        
        RecentImagesController *myImagesViewController2 = [[RecentImagesController alloc] initWithStyle:UITableViewStylePlain andIsFavorite:TRUE] ;
        myImagesViewController2.delegate = self;
        
        
        UINavigationController *myFavoritesNavigationController = [[[UINavigationController alloc] init] autorelease];
        [myFavoritesNavigationController pushViewController:myImagesViewController2 animated:FALSE];

        
        // La Toolbar
        ///////////////
        if ( self.myTabBarControllerinModalViewController != nil )
        {
            [self.myTabBarControllerinModalViewController release];
        }
        
        self.myTabBarControllerinModalViewController = [[UITabBarController alloc] init] ;        
        self.myTabBarControllerinModalViewController.viewControllers = [NSArray arrayWithObjects:mySettingsNavigationViewController, myFavoritesNavigationController,  nil];
        
        
        // CleanUp
        [myImagesViewController2 release];
        [mySettingsNavigationViewController release];
        
        [self presentModalViewController:myTabBarControllerinModalViewController animated:YES];
    }
}



- (void)imageSelected:(ImageStuff *)newImageStuff
{
    if ( [self.recentImagesPopover isPopoverVisible] )
    {
        [self.recentImagesPopover dismissPopoverAnimated:YES];
    }
    
    [self applyImageStuff:newImageStuff];
            
    // reactive le crayon
    self.isRubberMode=FALSE;
      
    self.rubberButton.selected=FALSE;
    self.colorButton.enabled = TRUE;
}



- (IBAction) displayNewImage:(id)sender
{
     [self imageSelected:nil];
}

- (IBAction) confirmCleanup:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hello!",nil)
                                                      message:NSLocalizedString(@"Confirm deletion ?", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                            otherButtonTitles:NSLocalizedString(@"Cancel",nil), nil];
    
    [message show];    
    [message release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:NSLocalizedString(@"OK",nil)])
    {
        [self displayNewImage:nil];
    }
}


#pragma mark - favorites 
- (IBAction) addToFavorites:(id)sender
{
    self.imageStuff.isFavorite=TRUE;
    self.imageStuff.imageFileName=nil; // on force la sauvegarde d'un nouveau fichier
    [self saveCurrentImageStuff];
}

#pragma mark - colorPicker
- (IBAction)setColorButtonTapped:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self closeAllPopover];

        // iPad View
        if (self.colorPicker == nil)
        {
            PresetColorPicker *tmpColorPicker = [[PresetColorPicker alloc] init];
            self.colorPicker = tmpColorPicker;
            
            [tmpColorPicker release];
            
            self.colorPicker.delegate = self;
            self.colorPickerPopover = [[[UIPopoverController alloc] initWithContentViewController:colorPicker] autorelease];
        }
        
        [self.colorPickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        // other views
        if (self.colorPicker == nil)
        {
            PresetColorPicker *tmpColorPicker = [[PresetColorPicker alloc] init];
            self.colorPicker = tmpColorPicker;
            
            [tmpColorPicker release];
            
            self.colorPicker.delegate = self;
            self.colorPickerPopover=nil;
        }
        [self presentModalViewController:self.colorPicker animated:YES];
    }
}


- (void)colorSelected:(UIColor *)color
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
        // change color of button
        [self.colorButton setTintColor:color];
    }
    
    // MAJ des red/green...
    [self updateColorComponents:color];
    self.currentColor = color;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ( [self.colorPickerPopover isPopoverVisible])
        {
            [self.colorPickerPopover dismissPopoverAnimated:YES];
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:FALSE];
        //done in viewWillDisappear ... self.navigationController.navigationBar.hidden=TRUE;
    }
}


@end
