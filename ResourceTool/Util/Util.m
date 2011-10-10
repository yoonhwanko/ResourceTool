//
//  Util.m
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 29..
//  Copyright 2011년 Home. All rights reserved.
//

#import "Util.h"
#import "AppDelegate.h"
@implementation Util

static Util* pInstUtil = nil;

+ (Util*) GetInst
{
    if(pInstUtil == nil)
        pInstUtil = [[Util alloc] init];
    
    return pInstUtil;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (int) GetScale
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 2.0;
    else
        return 1.0;
}
- (CGSize) GetSize
{
    UIInterfaceOrientation orient = [[UIDevice currentDevice] orientation];
    if(orient == UIInterfaceOrientationPortrait || orient == UIInterfaceOrientationPortraitUpsideDown)
    {
        UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];

        int x = CGRectGetWidth([[window screen] bounds]);
        int y = CGRectGetHeight([[window screen] bounds]);
        
        if(x<y)
            return CGSizeMake(x, y);
        else
            return CGSizeMake(y, x);
    }else
    {
        UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
        
        int x = CGRectGetWidth([[window screen] bounds]);
        int y = CGRectGetHeight([[window screen] bounds]);
        
        if(x>y)
            return CGSizeMake(x, y);
        else
            return CGSizeMake(y, x);        
    }
        
}

- (int) GetScreenWidth
{
    UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
    
    return CGRectGetWidth([[window screen] bounds]);

}
- (int) GetScreenHeight
{
    UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
    
    return CGRectGetHeight([[window screen] bounds]);

}

- (float) GetScreenScale
{
    UIWindow* window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
    
    return [[window screen] scale];
}

- (NSString*) GetBundlePath:(NSString*)filename
{
    return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}

#pragma mark -
#pragma mark Property List Control
- (NSMutableArray*)readBundlePlistName:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSString * error = [[NSString alloc] initWithString:@""];
    
    NSPropertyListFormat format;
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSMutableArray* plistDict = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    [error release];
    return plistDict;
}

- (void)writeToBundlePlistArray:(NSMutableArray*) list atName:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSString * error = [[NSString alloc] initWithString:@""];
    
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:list format:format errorDescription:&error];
    
    [data writeToFile:filePath atomically:YES];
    
    [error release];
}
- (NSMutableArray*)readPlistName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,fileName];
    
    NSString * error = [[NSString alloc] initWithString:@""];
    
    NSPropertyListFormat format;
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSMutableArray* plistDict = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    [error release];
    return plistDict;
}

- (void)writeToPlistArray:(NSMutableArray*) list atName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,fileName];
    
    NSString * error = [[NSString alloc] initWithString:@""];
    
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:list format:format errorDescription:&error];
    [data writeToFile:filePath atomically:YES];
    
    [error release];
    
}

- (NSString*)writeToTemporary:(NSData*)data atName:(NSString*)fileName
{
    NSString *documentPath = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@%@",documentPath,fileName];
    
    filePath = [filePath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    NSString * error = [[NSString alloc] initWithString:@""];
    
    [data writeToFile:filePath atomically:YES];
    
    [error release];
    
    
    return filePath;
}

- (void)clearTemporary
{
    NSString *file;
    NSString *documentPath = NSTemporaryDirectory();
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentPath];
    NSError* err;
    while (file = [dirEnum nextObject]) {
        err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[documentPath stringByAppendingPathComponent:file] error:&err];
        if(err){
            //print some errror message
        }
    }
}
@end
