//
//  SimulateMainScene.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 10. 2..
//  Copyright 2011년 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SimulateMainScene : CCScene {
    CCMenu *menu;
    
}

-(void) goBackMainUI:(id)sender;

- (void)startSimulateTmx:(NSString*)file;
- (void)startSimulatePng:(NSString *)pngFile;
- (void)startSimulatePngAnimation:(NSMutableArray*)data;

- (void)InsertBackButton;
@end
