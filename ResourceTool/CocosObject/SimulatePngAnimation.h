//
//  SimulatePngAnimation.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SimulatePngAnimation : CCLayer {
    NSMutableArray* _simulateFileData;
    
    CCSprite* mainSprite;
}
@property (nonatomic, retain) NSMutableArray* simulateFileData;

+(CCScene *) scene:(NSMutableArray*)simulateData;
-(void) startAnimation;
@end
