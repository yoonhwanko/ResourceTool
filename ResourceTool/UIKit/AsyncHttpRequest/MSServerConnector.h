//
//  MSServerConnector.h
//  PHP_SERVER
//
//  Created by 고윤환 on 11. 4. 8..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ServerConfig.h"
#define kLicensed               @"isRegisterApp"
#define kLicensedBuildVer       @"RegisteredBuildVersion"

#define kSort_asc_name          @"asc_name"
#define kSort_desc_name         @"desc_name"
#define kSort_asc_modify        @"asc_modify"
#define kSort_desc_modify       @"desc_modify"
#define kSort_asc_size          @"asc_size"
#define kSort_desc_size         @"desc_size"

@interface MSServerConnector : NSObject <UIWebViewDelegate>{
    NSString* _appID;
	NSString* _appName;
	id delegate_;
	SEL okSelector_;
	SEL failSelector_;
	
	// Will be filled after request
	BOOL success_;
	id data_;
}
+ (MSServerConnector*) sharedMSServerConnector;


@property(nonatomic, readonly) BOOL success;
@property(nonatomic, readonly) id data;

-(id) initWithAppID:(NSString*)appID
            Delegate:(id)delegate
            okSelector:(SEL)okSelector
          failSelector:(SEL)failSelector;
-(id) initWithAppID:(NSString*)appID
			  AppName:(NSString*)appName
			  delegate:(id)delegate
			okSelector:(SEL)okSelector
		  failSelector:(SEL)failSelector;

// Getting data
- (void) test;

// License Server Methods.
- (void) sendLicenseAppinfo:(NSString*)task;
- (void) licenseProcess;
- (void) conversionApp;

// News Server MEthods.
- (void) getNewsTask;
-(void) newsDone:(ASIHTTPRequest *)request;
-(void) newsFail:(ASIHTTPRequest *)request;


- (void) getSimulateDataFiles:(NSMutableArray*) data;
- (void) getFileList:(NSString*)path Sort:(NSString*)sort;

// Send ok or fail
-(void) ok;
-(void) fail;
-(void) fail:(ASIHTTPRequest*)request;

-(NSData*) responseToData:(NSString*) responseString;

@end
