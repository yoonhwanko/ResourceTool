//
//  TableViewController.m
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

#import "TableViewController.h"
#import "ColorViewController.h"
#import "UIKitRootViewController.h"

@implementation TableViewController

@synthesize fileList = _fileList;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileList count];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    NSString* type = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Type"];
    
    if([type isEqualToString:@"dir"])
        return UITableViewCellAccessoryDisclosureIndicator;
    else
    {
        UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];    
        NSString* path = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Path"];
        NSString* targetFile = nil;
        
        if([[self title] isEqualToString:@"ResourceSimulator"] == YES)    //Root
            targetFile = path;
        else
            targetFile = [self.title stringByAppendingFormat:@"/%@",path];
        
        for (int i = 0; i < [[control simulateFiles] count]; i++) {
            if([[[control simulateFiles] objectAtIndex:i] isEqualToString:targetFile] == YES)
            {
                return UITableViewCellAccessoryCheckmark;
            }
        }
        
        return UITableViewCellAccessoryNone;
    }
}

- (void) selectProcess:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    NSString* path = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Path"];
    NSString* targetFile = nil;
    
    if(bFileSelectMode)
    {
        if([beforePath isEqualToString:@"ResourceSimulator"] == YES)    //Root
            targetFile = path;
        else
            targetFile = [beforePath stringByAppendingFormat:@"/%@",path];
        
    }else
    {
        if([[self title] isEqualToString:@"ResourceSimulator"] == YES)    //Root
            targetFile = path;
        else
            targetFile = [self.title stringByAppendingFormat:@"/%@",path];
        
    }
    
    UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
    
    //select process
    //change for numeric selection index image
    //cell.imageView.image = [UIImage imageNamed:@"file.png"];    //0.png
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        newCell.accessoryType = UITableViewCellAccessoryNone;
    }
    [[control simulateFiles] addObject:targetFile];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    NSString* path = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Path"];
    NSString* type = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Type"];
    
    if(bFileSelectMode)
    {
        if([type isEqualToString:@"png"] || [type isEqualToString:@"tmx"] || [type isEqualToString:@"mp3"] || [type isEqualToString:@"tsx"])
        {
            NSString* targetFile = nil;
            if([beforePath isEqualToString:@"ResourceSimulator"] == YES)    //Root
                targetFile = path;
            else
                targetFile = [beforePath stringByAppendingFormat:@"/%@",path];
            
            UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            BOOL bSelected = false;
            
            //deselect process
            for (int i = 0; i < [[control simulateFiles] count]; i++) {
                if([[[control simulateFiles] objectAtIndex:i] isEqualToString:targetFile] == YES)
                {
                    bSelected = true;
                    [[control simulateFiles] removeObjectAtIndex:i];
                    [self applyImageToCell:cell Type:type];
                    return;
                }
            }
            [self selectProcess:tableView didSelectRowAtIndexPath:indexPath];
        }
        
    }else
    {
        
        
        if([type isEqualToString:@"dir"] == YES)
        {
            [self ReloadTableData];
            //directory test
            TableViewController *tabView = [[TableViewController alloc] init];
            [self.navigationController pushViewController:tabView animated:YES];
             
            if([[self title] isEqualToString:@"ResourceSimulator"] == YES)
                [tabView setTitle: path];
            else
                [tabView setTitle: [self.title stringByAppendingFormat:@"/%@",path]];
            

            //initial
            //[tabView setFileList:[[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Sub"]];
            NSString* tmpPath = [NSString stringWithFormat:@"/%@",[tabView title]];
            [[UIViewControllerChanger sharedUIChanger] refreshFileList:tmpPath Sort:[[UIKitRootViewController sharedUIKitController] sortKey]];
   
            [tabView release];
            
        }else if([type isEqualToString:@"png"] == YES)
        {
            //image test cocos loading
            UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];        
            if([[self title] isEqualToString:@"ResourceSimulator"] == YES)
                [control showImage: path];
            else
                [control showImage: [self.title stringByAppendingFormat:@"/%@",path]];
        }else if([type isEqualToString:@"tmx"] == YES)
        {
            //TMX test cocos loading
            
//            UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];        
//            if([[self title] isEqualToString:@"ResourceSimulator"] == YES)
//                [control showTmx: path];
//            else
//                [control showTmx: [self.title stringByAppendingFormat:@"/%@",path]];
        }else
        {
            //another
            ColorViewController *aController = [[ColorViewController alloc] init];
            [aController setColorFromName:@"Blue"];
            [self.navigationController pushViewController:aController animated:YES];
            [aController release];   
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

- (UITableViewCell*)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTextName = @"Simple_Text_Cell_Style";
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:simpleTextName];
	
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTextName] autorelease];
	}
	
    NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    NSString* path = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Path"];
    NSString* type = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Type"];
    
	cell.textLabel.text = path;
    
    if([[Util GetInst] GetScale] == 2)
    {
        CGRect rt = cell.frame;
        rt.size.width = [[Util GetInst] GetScreenWidth]-80;
        
        UILabel* label = [[UILabel alloc] initWithFrame:rt];
        label.numberOfLines = 1;
        label.text = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Mod"];
        [label setTextAlignment:UITextAlignmentRight];
        [label sizeToFit];
        [label setFrame:CGRectMake(rt.size.width-label.frame.size.width, 0, 0, 0)];
        [label sizeToFit];

        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:rt];
        label.numberOfLines = 1;
        label.text = [[SubFileList objectAtIndex:indexPath.row] objectForKey:@"Size"];
        [label setTextAlignment:UITextAlignmentRight];
        [label sizeToFit];
        [label setFrame:CGRectMake(rt.size.width-label.frame.size.width, 20, 0, 0)];
        [label sizeToFit];
        [cell addSubview:label];
        [label release];

        
    }
    
    [self applyImageToCell:cell Type:type];
    return cell;
}

- (void) applyImageToCell:(UITableViewCell*)cell Type:(NSString*)type
{
    if([type isEqualToString:@"dir"] == YES)
    {
        //directory test
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }else if([type isEqualToString:@"png"] == YES)
    {
        //image test
        cell.imageView.image = [UIImage imageNamed:@"png.png"];
    }else //if([type isEqualToString:@"TMX"] == YES)
    {
        //another
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
    }
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:[UIKitRootViewController sharedUIKitController] action:@selector(select:)];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithTitle:@"Select All Png" style:UIBarButtonItemStyleBordered target:[UIKitRootViewController sharedUIKitController] action:@selector(selectAll:)];
    UIBarButtonItem* item3 = [[UIBarButtonItem alloc] initWithTitle:@"Sim Start" style:UIBarButtonItemStyleBordered target:[UIKitRootViewController sharedUIKitController] action:@selector(simStart:)];
    UIBarButtonItem* item4 = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:[UIKitRootViewController sharedUIKitController] action:@selector(sort)];
    
    NSArray* items = [[NSArray alloc] initWithObjects:item1,flexibleSpace,item2,flexibleSpace,item3,flexibleSpace,item4, nil];
    [item1 release];
    [item2 release];
    [item3 release];
    [flexibleSpace release];
    [self setToolbarItems:items animated:NO];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [items release];
    
    bFileSelectMode = NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self setFileList:nil];
    //remove select files
    UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
    if([[control simulateFiles] count])
        [[control simulateFiles] removeAllObjects];
    
    if(beforePath)
    {
        [beforePath release];
        beforePath = nil;
    }
    [super dealloc];
}


#pragma mark -
#pragma mark FileSelector
- (void) select:(id)sender
{
    
    NSLog(@"Table select:");
    
    if(bFileSelectMode)
    {
        [self ReloadTableData];
        
        //cell refresh
        
        NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    
        for(int i = 0; i < [SubFileList count]; i++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSString* type = [[SubFileList objectAtIndex:i] objectForKey:@"Type"];
            
            [self applyImageToCell:cell Type:type];
        }
        
        [self setTitle:beforePath];
        [beforePath release];
        beforePath = nil;
    }else
    {
        beforePath = [self title];
        [beforePath retain];
        [self setTitle:@"Select Mode"];
    }
    
    bFileSelectMode = !bFileSelectMode;
}
- (void) selectAll:(id)sender
{    
    NSLog(@"Table selectAll:");
    
    [self ReloadTableData];
    
    
    NSMutableArray* SubFileList = (NSMutableArray*)_fileList;
    for(int i = 0; i < [_fileList count]; i++)
    {
        NSString* type = [[SubFileList objectAtIndex:i] objectForKey:@"Type"];
        
        if([type isEqualToString:@"png"] )//|| [type isEqualToString:@"tmx"] || [type isEqualToString:@"mp3"])
        {
            [self selectProcess:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
}

- (void)ReloadTableData
{
    //remove select files
    UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
    //deselect process
    if([[control simulateFiles] count])
    {
        [[control simulateFiles] removeAllObjects];
        [self ReloadTableData];
    }

    [self.tableView reloadData];
}
@end
