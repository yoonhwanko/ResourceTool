//
//  UIKitRootViewController.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 30..
//  Copyright 2011년 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIKitRootViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{
    
	UINavigationController *navController;
    
    NSMutableArray* _simulateFiles;
    
    UIPickerView* pickerView;
    NSString* _sortKey;
    
    int toolBarY;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray* simulateFiles;
@property (nonatomic, retain) NSString* sortKey;
+ (id)sharedUIKitController;
+ (id)RootViewController;

- (void)sizeToFitNav;

- (void) refreshFileList:(NSMutableDictionary*)data OrderDate:(BOOL)bOderDate;
#pragma mark -
#pragma mark BarButtonSelector
- (void) select:(id)sender;
- (void) selectAll:(id)sender;
- (void) showImage:(NSString*)path;
- (void) simStart:(id)sender;
- (void)sort;

- (void) showTmx:(NSString*)path;
@end
