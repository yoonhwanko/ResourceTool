//
//  SimulateTMX.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import "SimulateTMX.h"


static int sceneIdx=-1;
static NSString *transitions[] = {	
    
    @"SimulateTMX",

};

enum {
	kTagTileMap = 1,
};

Class nextAction(void);
Class backAction(void);
Class restartAction(void);


Class nextAction()
{
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;	
	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}


@implementation SimulateTMX
@synthesize tmxFile = _tmxFile;
+(CCScene *) scene:(NSString*)file
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SimulateTMX *layer = [SimulateTMX node];
    
	layer.tmxFile = file;
    
    [layer start];
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
	if( (self=[super init]) ) {
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        self.isTouchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
        self.isMouseEnabled = YES;
#endif
        
        
	}	
	return self;
}

-(void) start
{

    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(211,211,211,255)];
    [self addChild:colorLayer];
    
    if(self.tmxFile == nil)
        NSLog(@"file does not exist");
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:self.tmxFile];//@"TileMaps/orthogonal-test5.tmx"];
    [self addChild:map z:0 tag:kTagTileMap];
    
    CGSize s = map.contentSize;
    NSLog(@"ContentSize: %f, %f", s.width,s.height);
    
    CCTMXLayer *layer;
    layer = [map layerNamed:@"Layer 0"];
    [layer.texture setAntiAliasTexParameters];
    
    layer = [map layerNamed:@"Layer 1"];
    [layer.texture setAntiAliasTexParameters];
    
    layer = [map layerNamed:@"Layer 2"];
    [layer.texture setAntiAliasTexParameters];

}

-(void) updateMap:(ccTime) dt
{
	// IMPORTANT
	//   The only limitation is that you cannot change an empty, or assign an empty tile to a tile
	//   The value 0 not rendered so don't assign or change a tile with value 0
    
	CCTileMapAtlas *tilemap = (CCTileMapAtlas*) [self getChildByTag:kTagTileMap];
	
	//
	// For example you can iterate over all the tiles
	// using this code, but try to avoid the iteration
	// over all your tiles in every frame. It's very expensive
	//	for(int x=0; x < tilemap.tgaInfo->width; x++) {
	//		for(int y=0; y < tilemap.tgaInfo->height; y++) {
	//			ccColor3B c =[tilemap tileAt:ccg(x,y)];
	//			if( c.r != 0 ) {
	//				NSLog(@"%d,%d = %d", x,y,c.r);
	//			}
	//		}
	//	}
	
	// NEW since v0.7
	ccColor3B c =[tilemap tileAt:ccg(13,21)];		
	c.r++;
	c.r %= 50;
	if( c.r==0)
		c.r=1;
	
	// NEW since v0.7
	[tilemap setTile:c at:ccg(13,21)];			
	
}

-(NSString *) title
{
	return @"Editable TileMapAtlas";
}

-(void) dealloc
{
	[super dealloc];
}
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];	
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
	
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
	
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	
	CCNode *node = [self getChildByTag:kTagTileMap];
	CGPoint currentPos = [node position];
	[node setPosition: ccpAdd(currentPos, diff)];
}
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

-(BOOL) ccMouseDragged:(NSEvent *)event
{
	CCNode *node = [self getChildByTag:kTagTileMap];
	CGPoint currentPos = [node position];
	[node setPosition: ccpAdd(currentPos, CGPointMake( event.deltaX, -event.deltaY) )];
    
	return YES;
}
#endif

-(void) restartCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [restartAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [nextAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [backAction() node]];
	[[CCDirector sharedDirector] replaceScene: s];
}

@end
