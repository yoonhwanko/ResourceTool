//
//  SimulateTMX.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SimulateTMX : CCLayer 
{
    CCTextureAtlas *atlas;
    
    NSString* _tmxFile;
}

@property (nonatomic, retain) NSString* tmxFile;
+(CCScene *) scene:(NSString*)file;
-(void) start;
-(NSString*) title;
-(NSString*) subtitle;
@end
