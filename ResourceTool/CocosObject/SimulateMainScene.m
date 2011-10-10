//
//  SimulateMainScene.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import "SimulateMainScene.h"
#import "UIViewControllerChanger.h"
#import "SimulateTMX.h"
#import "SimulatePng.h"
#import "SimulatePngAnimation.h"

@implementation SimulateMainScene

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // test GCD Code
        /*dispatch_queue_t dqueue = dispatch_queue_create("test", NULL);
        dispatch_semaphore_t exeSignal = dispatch_semaphore_create(2);
        int i = 0;
        
        dispatch_async(dqueue, ^{
            dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"GCD: %i",i);
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"GCD: %i END",i);
                
                dispatch_semaphore_signal(exeSignal);
                
            });
        });
        i++;
        
        dispatch_async(dqueue, ^{
            dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"GCD: %i",i);
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"GCD: %i END",i);
                
                dispatch_semaphore_signal(exeSignal);
                
            });
        });
        i++;
        
        dispatch_async(dqueue, ^{
            dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"GCD: %i",i);
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"GCD: %i END",i);
                
                dispatch_semaphore_signal(exeSignal);
                
            });
        });
        i++;
        
        dispatch_async(dqueue, ^{
            dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"GCD: %i",i);
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"GCD: %i END",i);
                
                dispatch_semaphore_signal(exeSignal);
                
            });
        });
        i++;
        
        dispatch_async(dqueue, ^{
            dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"GCD: %i",i);
                [NSThread sleepForTimeInterval:2.0f];
                NSLog(@"GCD: %i END",i);
                
                dispatch_semaphore_signal(exeSignal);
                
            });
        });
        i++;*/
	}
	return self;
}

-(void) goBackMainUI:(id)sender
{
    [self removeChildByTag:999 cleanup:YES];
    
    [[CCDirector sharedDirector] pause];
    
    
    UIViewControllerChanger* changer = [UIViewControllerChanger sharedUIChanger];
    [changer changeToViewController:UIViewControllerUIKitRoot];
//    [[UIViewControllerChanger sharedUIChanger] changeToViewController:UIViewControllerUIKitRoot];
}

- (void)startSimulateTmx:(NSString*)file
{
    SimulateTMX* layer = [SimulateTMX node];
    [layer setTmxFile:file];
    [layer start];
    [self addChild: layer z:0 tag:999];
    
    [self InsertBackButton];
}
- (void)startSimulatePng:(NSString *)pngFile
{
    SimulatePng* layer = [SimulatePng node];
    [layer setPngFile:pngFile];
    [layer start];
    [self addChild: layer z:0 tag:999];
    
    [self InsertBackButton];
}
- (void)startSimulatePngAnimation:(NSMutableArray*)data
{
    SimulatePngAnimation* layer = [SimulatePngAnimation node];
    [layer setSimulateFileData:data];
    [layer startAnimation];
    [self addChild: layer z:0 tag:999];
    
    [self InsertBackButton];
}

- (void)InsertBackButton
{
    // Font Item
    CCMenuItemFont *item6 = [CCMenuItemFont itemFromString: @"BACK" target:self selector:@selector(goBackMainUI:)];
    [item6 setFontName:@"Arial-BoldMT"];
    [item6 setColor:ccc3(0, 0, 0)];
    menu = [CCMenu menuWithItems: item6, nil];
    
    menu.position = ccp(50, 50);
    [self addChild:menu];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    
}
@end
