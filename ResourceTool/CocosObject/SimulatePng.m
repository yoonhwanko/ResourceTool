//
//  SimulatePng.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import "SimulatePng.h"


@implementation SimulatePng
@synthesize pngFile = _pngFile;
+(CCScene *) scene:(NSString*)pngFile
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SimulatePng *layer = [SimulatePng node];
    
	layer.pngFile = pngFile;
    
    [layer start];
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
		
    }
	return self;
}

-(void) start
{
    
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    if(self.pngFile)
    {
        CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(211,211,211,255)];
        [self addChild:layer];
        
        NSString* imgFile = self.pngFile;
        
        UIImage* image = [UIImage imageWithContentsOfFile:imgFile];
        
        mainSprite = [CCSprite spriteWithCGImage:image.CGImage key:nil];//[CCSprite spriteWithFile:self.pngFile];
        mainSprite.position =  ccp( size.width /2 , size.height/2 );
        
        [self addChild:mainSprite];
        
        
        
    }
    
    
    //            id action = [CCSequence actions:
    //                         [CCPlace actionWithPosition:ccp(200,200)],
    //                         [CCShow action],
    //                         [CCMoveBy actionWithDuration:1 position:ccp(100,0)],
    //                         [CCCallFunc actionWithTarget:self selector:@selector(callback1)],
    //                         [CCCallFuncN actionWithTarget:self selector:@selector(callback2:)],
    //                         [CCCallFuncND actionWithTarget:self selector:@selector(callback3:data:) data:(void*)0xbebabeba],
    //                         nil];
    //            
    //            [grossini runAction:action];
    
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
