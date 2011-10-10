//
//  UIKitRootViewController.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 30..
//  Copyright 2011년 Home. All rights reserved.
//

#import "UIKitRootViewController.h"
#import "TableViewController.h"
#import "MSServerConnector.h"
@implementation UIKitRootViewController
@synthesize navController;
@synthesize simulateFiles = _simulateFiles;
@synthesize sortKey = _sortKey;

static UIKitRootViewController* __pInst = nil;
+ (id)sharedUIKitController
{
    if(__pInst == nil)
    {
        __pInst = [[[UIKitRootViewController alloc] init] autorelease];
        [__pInst retain];
    }
    
    return __pInst;
}

+ (id)RootViewController
{
    return [[[UIKitRootViewController alloc] init] autorelease];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    TableViewController *tabView = (TableViewController*)[navController visibleViewController];
    [tabView ReloadTableData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navController = [[UINavigationController alloc] init];
    TableViewController *tabView = [[[TableViewController alloc] init] autorelease];
//    NSMutableDictionary* temp = (NSMutableDictionary*)[[Util GetInst] readBundlePlistName:@"FileListSample"];
//    [tabView setFileList:[temp objectForKey:@"Root"]];
    [[UIViewControllerChanger sharedUIChanger] refreshFileList:@"." Sort:self.sortKey];
    [tabView setTitle:@"ResourceSimulator"];
    [navController pushViewController:tabView animated:FALSE];
    [self.view addSubview:navController.view];
    
    pickerView = [[[UIPickerView alloc]initWithFrame:CGRectMake(0, [[Util GetInst] GetScreenHeight], [[Util GetInst] GetScreenWidth], 0)] autorelease];  
    //일부러 뷰밖에서 생성한다.
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	[self.view addSubview:pickerView];
    
    _simulateFiles = [[NSMutableArray alloc] initWithArray:nil];
    
}
- (void)dealloc
{
    if([self.simulateFiles count])
        [self.simulateFiles removeAllObjects];
    [self setSimulateFiles:nil];
    
	[navController release];
    [super dealloc];
}

- (void)sizeToFitNav
{
    
    [navController.navigationBar sizeToFit];
    [navController.toolbar sizeToFit];

}

- (void) refreshFileList:(NSMutableDictionary*)data OrderDate:(BOOL)bOderDate
{
    TableViewController *tabView = (TableViewController*)[navController visibleViewController];

    [tabView setFileList:[data objectForKey:@"Root"]];
    
    [tabView.tableView reloadData];
    
    
}

#pragma mark -
#pragma mark BarButtonSelector
- (void) select:(id)sender
{

    if([[navController visibleViewController] respondsToSelector:@selector(select:)])
        [[navController visibleViewController] performSelector:@selector(select:) withObject:self];

    
    NSLog(@"select:");
}
- (void) selectAll:(id)sender
{
    if([[navController visibleViewController] respondsToSelector:@selector(selectAll:)])
        [[navController visibleViewController] performSelector:@selector(selectAll:) withObject:self];
    
    NSLog(@"selectAll:");
}

- (void) showImage:(NSString*)path
{
    //remove select files
    UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
    if([[control simulateFiles] count])
        [[control simulateFiles] removeAllObjects];

    [self.simulateFiles addObject:path];
    [[UIViewControllerChanger sharedUIChanger] simulateFileDownload:self.simulateFiles Type:@"png"];
}

- (void) showTmx:(NSString*)path
{
    
    //remove select files
    UIKitRootViewController* control = [UIKitRootViewController sharedUIKitController];
    if([[control simulateFiles] count])
        [[control simulateFiles] removeAllObjects];
    
    [self.simulateFiles addObject:path];
    
    [[UIViewControllerChanger sharedUIChanger] simulateFileDownload:self.simulateFiles Type:@"tmx"];    
}

- (void) simStart:(id)sender
{
    NSLog(@"simStart:");
    
    //[self.view setHidden:YES];
    if([_simulateFiles count] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please select the file" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        return;
    }else
    {
        BOOL bTMXFileContain = NO;
        for (int i = 0; i < [_simulateFiles count]; i++) {
            NSLog(@"%@",[_simulateFiles objectAtIndex:i]);
            if([[_simulateFiles objectAtIndex:i] rangeOfString:@"tmx"].location!=NSNotFound)
                bTMXFileContain = YES;
        }
        
        if(bTMXFileContain)
            [[UIViewControllerChanger sharedUIChanger] simulateFileDownload:self.simulateFiles Type:@"tmx"];
        else
            [[UIViewControllerChanger sharedUIChanger] simulateFileDownload:self.simulateFiles Type:@"ani"];
        
    }
    
   
}

- (void)sort
{
    
    int y = 215;
    if([[Util GetInst] GetScale] == 2)
        y = 155;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	pickerView.transform = CGAffineTransformMakeTranslation(0, -1*y); //위로 쭈욱하고 올라온다.
	[UIView commitAnimations];
	//[self pickerView:pickerView didSelectRow:0 inComponent:0];//자동으로 처음값을 설정

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return (NSString*)kSort_asc_name;
        case 1:
            return (NSString*)kSort_desc_name;
        case 2:
            return (NSString*)kSort_asc_modify;
        case 3:
            return (NSString*)kSort_desc_modify;
        case 4:
            return (NSString*)kSort_asc_size;
        case 5:
            return (NSString*)kSort_desc_size;
        default:
            break;
    }
    
    return @"";
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6 ;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 320;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    int y = 215;
    if([[Util GetInst] GetScale] == 2)
        y = 155;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	pickerView.transform = CGAffineTransformMakeTranslation(0, y); //그냥 아래로 다시 내려주자
	[UIView commitAnimations];
    
    switch (row) {
        case 0:
            self.sortKey = kSort_asc_name;
            break;
        case 1:
            self.sortKey = kSort_desc_name;
            break;
        case 2:
            self.sortKey = kSort_asc_modify;
            break;
        case 3:
            self.sortKey = kSort_desc_modify;
            break;
        case 4:
            self.sortKey = kSort_asc_size;
            break;
        case 5:
            self.sortKey = kSort_desc_size;
            break;
        default:
            break;
            
            
    }
    TableViewController *tabView = (TableViewController*)[navController visibleViewController];
    if([[tabView title] isEqualToString:@"ResourceSimulator"] == YES)
        [[UIViewControllerChanger sharedUIChanger] refreshFileList:@"." Sort:self.sortKey];
    else
        [[UIViewControllerChanger sharedUIChanger] refreshFileList:[NSString stringWithFormat:@"/%@",[tabView title]] Sort:self.sortKey];
    
    
}
@end
