//
//  UIViewControllerChanger.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 30..
//  Copyright 2011년 Home. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "SimulateMainScene.h"


#import "UIViewControllerChanger.h"
#import "AppDelegate.h"
#import "UIKitRootViewController.h"
#import "RootViewController.h"

#import "MSServerConnector.h"
#import "base64.h"

@implementation UIViewControllerChanger

@synthesize cocosController;
@synthesize serverConnector = _serverConnector;
@synthesize indicator = _indicator;

static UIControlID currentControlID = UIViewControllerNone;
static UIViewControllerChanger* __pInstChanger = nil;


+(id) sharedUIChanger
{
    if(__pInstChanger == nil)
    {
        __pInstChanger = [[[UIViewControllerChanger alloc] init] autorelease];

        [__pInstChanger retain];
    }
    
    return __pInstChanger;
}

- (void)changeToViewController:(UIControlID)controlID
{
    if(controlID != currentControlID)
    {
        UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
        
        [[window viewWithTag:currentControlID] removeFromSuperview];
        [window addSubview:[[UIViewControllerChanger getViewController:controlID] view]];
        
        currentControlID = controlID;
        
        
        if(currentControlID == UIViewControllerUIKitRoot)
            [[UIViewControllerChanger getViewController:controlID] sizeToFitNav];
    }
    
    
    
}

+(id)getViewController:(UIControlID)controlID
{
    UIViewController* viewController = nil;
    switch (controlID) {
        case UIViewControllerCocos2d:
        {
            if([[UIViewControllerChanger sharedUIChanger] cocosController] == nil)
            {
                // Try to use CADisplayLink director
                // if it fails (SDK < 3.1) use the default director
                if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
                    [CCDirector setDirectorType:kCCDirectorTypeDefault];
                            
                CCDirector *director = [CCDirector sharedDirector];
                            
                // Init the View Controller
                [[UIViewControllerChanger sharedUIChanger] setCocosController:[[RootViewController alloc] initWithNibName:nil bundle:nil]];
                [[UIViewControllerChanger sharedUIChanger] cocosController].wantsFullScreenLayout = YES;
                
                //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
                //	if( ! [director enableRetinaDisplay:YES] )
                //		CCLOG(@"Retina Display Not supported");
                
                //
                // VERY IMPORTANT:
                // If the rotation is going to be controlled by a UIViewController
                // then the device orientation should be "Portrait".
                //
                // IMPORTANT:
                // By default, this template only supports Landscape orientations.
                // Edit the RootViewController.m file to edit the supported orientations.
                //
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
                [director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
                [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
                
                [director setAnimationInterval:1.0/60];
                [director setDisplayFPS:YES];
                
                // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
                // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
                // You can change anytime.
                [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
                
                //
                // Create the EAGLView manually
                //  1. Create a RGB565 format. Alternative: RGBA8
                //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
                //
                //
                EAGLView *glView = [EAGLView viewWithFrame:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] bounds]
                                               pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                               depthFormat:0						// GL_DEPTH_COMPONENT16_OES
                                    ];
                
                // make the OpenGLView a child of the view controller
                //[[[UIViewControllerChanger sharedUIChanger] cocosController] setView:glView];
                [[[UIViewControllerChanger sharedUIChanger] cocosController].view addSubview:glView];
                
                // attach the openglView to the director
                [director setOpenGLView:glView];
                

            }
            
            viewController = [[UIViewControllerChanger sharedUIChanger] cocosController];
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
            
        }
            break;
        case UIViewControllerUIKitRoot:
            [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
            
            viewController = [UIKitRootViewController sharedUIKitController];
            [(UIKitRootViewController*)viewController setSortKey:kSort_asc_name];
            viewController.wantsFullScreenLayout = YES;
            [viewController.view sizeToFit];
            
            [[Util GetInst] clearTemporary];
            
            break;
        default:
            break;
    }

    [viewController.view setTag:controlID];
    return viewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
#if defined (_MULTI_THREAD_SUPPORT)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFileListMultiThreadCB:) name:@"RefreshFileList" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(simulateFileDownloadMultiThreadCB:) name:@"SimulateFileDownload" object:nil];
#endif
    }
    
    return self;
}

- (void)startCocos2d
{
    // Run the intro Scene
    //[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
    [[CCDirector sharedDirector] runWithScene: [SimulateMainScene node]];
}

- (void)startSimulateTmx:(NSString*)file
{
    
    SimulateMainScene* scene = (SimulateMainScene*)[[CCDirector sharedDirector] runningScene];
    if(scene == nil)
    {
        scene = [SimulateMainScene node];
        [[CCDirector sharedDirector] runWithScene: scene];
    }
    else 
        [[CCDirector sharedDirector] resume];
    
    [scene startSimulateTmx:file];//[data objectAtIndex:0]];
}
- (void)startSimulatePng:(NSMutableArray *)data
{
    SimulateMainScene* scene = (SimulateMainScene*)[[CCDirector sharedDirector] runningScene];
    if(scene == nil)
    {
        scene = [SimulateMainScene node];
        [[CCDirector sharedDirector] runWithScene: scene];
    }
    else 
        [[CCDirector sharedDirector] resume];
    
    
    NSString* imgFile = [data objectAtIndex:0];
    
    [scene startSimulatePng:imgFile];
}
- (void)startSimulatePngAnimation:(NSMutableArray*)data
{
    SimulateMainScene* scene = (SimulateMainScene*)[[CCDirector sharedDirector] runningScene];
    if(scene == nil)
    {
        scene = [SimulateMainScene node];
        [[CCDirector sharedDirector] runWithScene: scene];
    }
    else 
        [[CCDirector sharedDirector] resume];
    
    [scene startSimulatePngAnimation:data];
    
}

- (void) simulateFileDownload:(NSMutableArray*)data Type:(NSString*)type
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects:self,data,type, nil];
    
#if defined (_MULTI_THREAD_SUPPORT)
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:@"SimulateFileDownload" object:array]                                               
                                               postingStyle:NSPostWhenIdle];
#else
    [self simulateFileDownloadMultiThreadCB:array];
#endif
    [array release];
    
}

- (void) refreshFileList:(NSString*)path Sort:(NSString*)sort
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects:self,path,sort, nil];
    
#if defined (_MULTI_THREAD_SUPPORT)
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:@"RefreshFileList" object:array]                                               
                                               postingStyle:NSPostWhenIdle];
#else
    [self refreshFileListMultiThreadCB:array];
#endif
    
    [array release];
    
}

- (void) simulateFileDownloadMultiThreadCB:(id)sender
{
    UIViewControllerChanger* obj = nil;
    NSMutableArray* data;
    NSString* type;
    if (sender) {
        if ([sender isKindOfClass:[NSNotification class]]) 
        {
            NSNotification* noti = sender;
            obj = [[noti object] objectAtIndex:0];
            data = [[noti object] objectAtIndex:1];
            type = [[noti object] objectAtIndex:2];
        }
    }else{
        
        NSMutableArray* array = sender;
        obj = [array objectAtIndex:0];
        data = [array objectAtIndex:1]; 
        type = [array objectAtIndex:2];
    }
    
    [obj startIndicator];
    
    SEL sel = nil;
    if([type isEqualToString:@"ani"])
        sel = @selector(ReciveSimulationFiles:);
    else if([type isEqualToString:@"png"])
        sel = @selector(ReciveSimulationPNG:);
    else if([type isEqualToString:@"tmx"])
        sel = @selector(ReciveSimulationTMX:);

    obj.serverConnector = [[[MSServerConnector alloc] initWithAppID:kAppID Delegate:obj okSelector:sel failSelector:@selector(ReciveFail:)] autorelease];
    [obj.serverConnector getSimulateDataFiles:data];
}
- (void) refreshFileListMultiThreadCB:(id)sender
{
    UIViewControllerChanger* obj = nil;
    NSString* path;
    NSString* sort;
    if (sender) {
        if ([sender isKindOfClass:[NSNotification class]]) 
        {
            NSNotification* noti = sender;
            obj = [[noti object] objectAtIndex:0];
            path = [[noti object] objectAtIndex:1];
            sort = [[noti object] objectAtIndex:2];
        }
    }else{
        
        NSMutableArray* array = sender;
        obj = [array objectAtIndex:0];
        path = [array objectAtIndex:1];
        sort = [array objectAtIndex:2];        
    }

    [obj startIndicator];
    obj.serverConnector = [[[MSServerConnector alloc] initWithAppID:kAppID Delegate:obj okSelector:@selector(ReciveFileList:) failSelector:@selector(ReciveFail:)] autorelease];
    [obj.serverConnector getFileList:path Sort:sort];
}
- (void)ReciveSimulationFiles:(id)obj
{
    NSMutableDictionary* dict = [self parseReciveDateToDict:obj];
    
        
    // 들어온 패스 리스트를 기준으로 전부 서버에서 받아온 후 이미지 데이터로 변환 후 코코스로 보냄.
    NSMutableArray* data = [dict objectForKey:@"data"];
      
    NSMutableArray* fileList = [[NSMutableArray alloc] initWithObjects: nil];    
    for (int i = 0; i < [data count]; i++) {
        NSMutableDictionary* dict = [data objectAtIndex:i];
        
        NSString* name = [dict objectForKey:@"path"];
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        name = [name stringByReplacingOccurrencesOfString:[name stringByDeletingLastPathComponent] withString:@""];

        NSString* imgString = [dict objectForKey:@"data"];
        NSData* dat = decodeBase64WithString(imgString);
        
        NSString* path = [[Util GetInst] writeToTemporary:dat atName:name];
        [fileList addObject:path];

    }
    [self changeToViewController:UIViewControllerCocos2d];
    [self startSimulatePngAnimation:fileList];

    [self setServerConnector:nil];
    [self finishIndicator];
}

- (void)ReciveSimulationPNG:(id)obj
{
    NSMutableDictionary* dict = [self parseReciveDateToDict:obj];
    
    
    // 들어온 패스 리스트를 기준으로 전부 서버에서 받아온 후 이미지 데이터로 변환 후 코코스로 보냄.
    NSMutableArray* data = [dict objectForKey:@"data"];
    
    NSMutableArray* fileList = [[NSMutableArray alloc] initWithObjects: nil];    
    for (int i = 0; i < [data count]; i++) {
        NSMutableDictionary* dict = [data objectAtIndex:i];
        
        NSString* name = [dict objectForKey:@"path"];
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        name = [name stringByReplacingOccurrencesOfString:[name stringByDeletingLastPathComponent] withString:@""];
        
        NSString* imgString = [dict objectForKey:@"data"];
        NSData* dat = decodeBase64WithString(imgString);
        
        NSString* path = [[Util GetInst] writeToTemporary:dat atName:name];
        [fileList addObject:path];
        
    }
    
    [self changeToViewController:UIViewControllerCocos2d];

    [self startSimulatePng:fileList];
    
    [self setServerConnector:nil];
    [self finishIndicator];
}

- (void)ReciveSimulationTMX:(id)obj
{
    NSMutableDictionary* dict = [self parseReciveDateToDict:obj];
    
    
    // 들어온 패스 리스트를 기준으로 전부 서버에서 받아온 후 이미지 데이터로 변환 후 코코스로 보냄.
    NSMutableArray* data = [dict objectForKey:@"data"];
    
    [self changeToViewController:UIViewControllerCocos2d];
    
    NSString* tmxFileName = nil;
    for (int i = 0; i < [data count]; i++) {
        NSMutableDictionary* dict = [data objectAtIndex:i];
        
        NSString* name = [dict objectForKey:@"path"];
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        name = [name stringByReplacingOccurrencesOfString:[name stringByDeletingLastPathComponent] withString:@""];
        NSString* tmxString = [dict objectForKey:@"data"];
        NSData* dat = decodeBase64WithString(tmxString);
        
        NSString* path = [[Util GetInst] writeToTemporary:dat atName:name];
        if([name rangeOfString:@"tmx"].location != NSNotFound)
            tmxFileName = path;
    }
    //[self startSimulateTmx:data];
    [self startSimulateTmx:tmxFileName];
    [self setServerConnector:nil];
    [self finishIndicator];
}

- (void)ReciveFileList:(id)obj
{
    NSMutableDictionary* dict = [self parseReciveDateToDict:obj];
    
    
    [[UIKitRootViewController sharedUIKitController] refreshFileList:dict OrderDate:NO];
    [self setServerConnector:nil];
    [self finishIndicator];
}
- (void)ReciveFail:(id)obj
{
    NSString *reply = [[[NSString alloc] initWithData:[obj data] 
											 encoding:NSUTF8StringEncoding] 
					   autorelease]; 
    
    NSLog(@"ReciveFail = %@",reply);
    
    [self setServerConnector:nil];
    [self finishIndicator];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network process error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)startIndicator
{
    self.indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator sizeToFit];
    
    [[[UIKitRootViewController sharedUIKitController] view] addSubview:self.indicator];
    
    CGRect rt = [self.indicator frame];
    CGSize sz = CGSizeMake(rt.size.width*2, rt.size.height*2);
    int x = ([[Util GetInst] GetScreenWidth] - sz.width)/2;
    int y = ([[Util GetInst] GetScreenHeight] - sz.height)/2;

    [self.indicator setFrame:CGRectMake(x, y, sz.width, sz.height)];
    [self.indicator startAnimating];
}

- (void)finishIndicator
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    [self setIndicator:nil];
}

- (NSMutableDictionary*)parseReciveDateToDict:(id)obj
{
    NSData * data = [obj data];
    NSString * error = [[NSString alloc] initWithString:@""];
    NSPropertyListFormat format; 
    NSDictionary * _dict = (NSDictionary*)[NSPropertyListSerialization 
                                           propertyListFromData:data 
                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                           format:&format 
                                           errorDescription:&error]; 
    
    [error release];
    return _dict;
    
}

- (void)dealloc
{
    UIViewController* viewController = nil;
    viewController = [[UIViewControllerChanger sharedUIChanger] cocosController];
    [viewController release];
    
    viewController = [UIKitRootViewController sharedUIKitController];
    [viewController release];

    [_serverConnector release];
    _serverConnector = nil;
    [super dealloc];
}

@end
