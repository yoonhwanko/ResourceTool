//
//  TableViewController.h
//  TableViewController_09
//
//  Created by Nicholas Vellios on 4/18/10.
//  Copyright 2010 Nick Vellios. All rights reserved.
//
//	http://www.Vellios.com
//	nick@vellios.com
//
//	This code is released under the "Take a kid fishing or hunting license"
//	In order to use any code in your project you must take a kid fishing or
//	hunting and give some sort of credit to the author of the code either
//	on your product's website, about box, or legal agreement.
//

#import <UIKit/UIKit.h>
#import "Util.h"

@interface TableViewController : UITableViewController {
    
    NSMutableDictionary* _fileList;
    
    UIToolbar*  _commandToolBar;
    
    BOOL bFileSelectMode;
    NSString* beforePath;

}

@property (nonatomic, retain) NSMutableDictionary* fileList;

- (void) selectProcess:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) applyImageToCell:(UITableViewCell*)cell Type:(NSString*)type;
- (void)ReloadTableData;
#pragma mark -
#pragma mark FileSelector
- (void) select:(id)sender;
- (void) selectAll:(id)sender;

@end
