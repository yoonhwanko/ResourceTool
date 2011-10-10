//
//  SimulatePngAnimation.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import "SimulatePngAnimation.h"
#import "base64.h"

@implementation SimulatePngAnimation
@synthesize simulateFileData = _simulateFileData;

+(CCScene *) scene:(NSMutableArray*)simulateData
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SimulatePngAnimation *layer = [SimulatePngAnimation node];

	layer.simulateFileData = simulateData;

    [layer startAnimation];
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

-(void) startAnimation
{
    
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(211,211,211,255)];
    [self addChild:layer];
    
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    mainSprite = [CCSprite spriteWithFile:@"file.png"];
    mainSprite.position =  ccp( size.width /2 , size.height/2 );
    [self addChild:mainSprite];
    
    CCAnimation* animation = [CCAnimation animation];
    if([self.simulateFileData count] > 0)
    {
        for(int i = 0; i < [self.simulateFileData count]; i++)
        {
            NSString* imgFile = [self.simulateFileData objectAtIndex:i];
            
            UIImage* image = [UIImage imageWithContentsOfFile:imgFile];
            CCSprite* sprite = [CCSprite spriteWithCGImage:image.CGImage key:nil];
           
            // position the label on the center of the screen
            sprite.position =  ccp( size.width /2 , size.height/2 );

            sprite.anchorPoint = ccp(4.5f,4.5f);
            sprite.scale = 4.5f;
            
            CGRect rt = CGRectMake(0, 0, sprite.contentSize.width, sprite.contentSize.height); 
            [animation addFrameWithTexture:sprite.texture rect:rt];

        }
        
        id action = [CCAnimate actionWithDuration:(0.05*([self.simulateFileData count])) animation:animation restoreOriginalFrame:NO];
        id action_back = [action reverse];
        id seq = [CCSequence actions:action, action_back, nil];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
        [mainSprite runAction: repeat];
        
        
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
-(void) callback1
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"callback 1 called" fontName:@"Marker Felt" fontSize:16];
    [label setPosition:ccp( s.width/4*1,s.height/2)];
    
    [self addChild:label];
}

-(void) callback2:(id)sender
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"callback 2 called" fontName:@"Marker Felt" fontSize:16];
    [label setPosition:ccp( s.width/4*2,s.height/2)];
    
    [self addChild:label];
}

-(void) callback3:(id)sender data:(void*)data
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"callback 3 called" fontName:@"Marker Felt" fontSize:16];
    [label setPosition:ccp( s.width/4*3,s.height/2)];
    
    [self addChild:label];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    
    [_simulateFileData release];
    _simulateFileData = nil;
}

@end
