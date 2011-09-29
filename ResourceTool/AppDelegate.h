//
//  AppDelegate.h
//  ResourceTool
//
//  Created by 고 윤환 on 11. 9. 29..
//  Copyright Home 2011년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
