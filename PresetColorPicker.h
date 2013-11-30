//
//  PresetColorPicker.h
//  Created by http://github.com/iosdeveloper
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol PresetColorPickerDelegate;

@interface PresetColorPicker : UITableViewController <EGORefreshTableHeaderDelegate> {
	NSMutableArray *presetColors;

    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
	
	id <PresetColorPickerDelegate> delegate;
}

@property (retain, readwrite) NSMutableArray *presetColors;
@property (nonatomic, assign) id delegate;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end

@protocol PresetColorPickerDelegate <NSObject>
- (void)colorSelected:(UIColor *)color;
@end