//
//  UIViewControllerChanger.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 30..
//  Copyright 2011년 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _UIControlID{
    UIViewControllerNone = 0, 
    UIViewControllerCocos2d,
    UIViewControllerUIKitRoot
}UIControlID;

@class RootViewController;
@class MSServerConnector;

@interface UIViewControllerChanger : NSObject
{
    RootViewController	*cocosController;
    MSServerConnector   *_serverConnector;
    
    UIActivityIndicatorView*   _indicator;
}

@property (nonatomic, retain) MSServerConnector* serverConnector;
@property (nonatomic, retain) RootViewController* cocosController;
@property (nonatomic, retain) UIActivityIndicatorView* indicator;
+(id) sharedUIChanger;
- (void)changeToViewController:(UIControlID)controlID;
+(id)getViewController:(UIControlID)controlID;
- (void)startCocos2d;
- (void)startSimulatePng:(NSMutableArray *)data;
- (void)startSimulateTmx:(NSString*)file;
- (void)startSimulatePngAnimation:(NSMutableArray*)data;

- (void) simulateFileDownload:(NSMutableArray*)data Type:(NSString*)type;
- (void) refreshFileList:(NSString*)path Sort:(NSString*)sort;
- (void) simulateFileDownloadMultiThreadCB:(id)sender;
- (void) refreshFileListMultiThreadCB:(id)sender;

- (void)ReciveSimulationFiles:(id)obj;
- (void)ReciveSimulationPNG:(id)obj;
- (void)ReciveSimulationTMX:(id)obj;
- (void)ReciveFileList:(id)obj;
- (void)ReciveFail:(id)obj;


- (void)startIndicator;
- (void)finishIndicator;

- (NSMutableDictionary*)parseReciveDateToDict:(id)obj;

@end
