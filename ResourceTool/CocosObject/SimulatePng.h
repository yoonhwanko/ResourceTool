//
//  SimulatePng.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SimulatePng : CCLayer {
    
    NSString* _pngFile;
    CCSprite* mainSprite;
}

@property (nonatomic, retain) NSString* pngFile;

+(CCScene *) scene:(NSData*)pngData;
-(void) start;
@end
