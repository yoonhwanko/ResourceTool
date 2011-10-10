//
//  Util.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 29..
//  Copyright 2011년 Home. All rights reserved.
//



@interface Util : NSObject
{
    
}

+ (Util*) GetInst;


- (CGSize) GetSize;
- (int) GetScale;
- (int) GetScreenWidth;
- (int) GetScreenHeight;

- (NSString*) GetBundlePath:(NSString*)filename;
#pragma mark -
#pragma mark Property List Control
- (NSMutableArray*)readBundlePlistName:(NSString*)fileName;
- (void)writeToBundlePlistArray:(NSMutableArray*) list atName:(NSString*)fileName;
- (NSMutableArray*)readPlistName:(NSString*)fileName;
- (void)writeToPlistArray:(NSMutableArray*) list atName:(NSString*)fileName;
- (NSString*)writeToTemporary:(NSData*)data atName:(NSString*)fileName;
- (void)clearTemporary;
@end
