//
//  HelloWorldLayer.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 29..
//  Copyright Home 2011년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import <dispatch/dispatch.h>
// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
    	// add the label as a child to this Layer
		[self addChild: label];
        
        
        UIImage* image = [UIImage imageWithContentsOfFile:[[Util GetInst] GetBundlePath:@"file.png"]];
        
        CCSprite* sprite = [CCSprite spriteWithCGImage:image.CGImage key:nil];
        sprite.position = CGPointMake(50, 50);
        [self addChild:sprite];
        
        // test GCD Code
        dispatch_queue_t dqueue = dispatch_queue_create("test", NULL);
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
        i++;
	}
	return self;
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
