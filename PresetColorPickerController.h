//
//  PresetColorPicker.h
//  Created by http://github.com/iosdeveloper
//

#import <UIKit/UIKit.h>

@protocol PresetColorPickerDelegate;

@interface PresetColorPickerController : UITableViewController
{
	NSMutableArray *presetColors;
	id <PresetColorPickerDelegate> delegate;
}

@property (nonatomic, assign) id delegate;


+ (UIColor *)colorFromName:(NSString *)colorName;
+ (UInt32)colorWithRGBHexFromName:(NSString *)colorName;

@end

@protocol PresetColorPickerDelegate <NSObject>
- (void)colorNameSelected:(NSString *)colorName;
@end