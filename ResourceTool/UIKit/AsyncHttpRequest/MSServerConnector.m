//
//  MSServerConnector.m
//  PHP_SERVER
//
//  Created by 고윤환 on 11. 4. 8..
//  Copyright 2011 Home. All rights reserved.
//

#import "MSServerConnector.h"

#import "HttpClient.h"

#define kKeyTask        @"TASK"
#define kKeyAppID       @"APP_ID"
#define kKeyAppName     @"APP_NAME"
#define kKeyUdid        @"UDID"
#define kKeyBuildVer    @"BUILD_VER"
#define kKeyDevModel    @"DEV_MODEL"
#define kKeyDevVer      @"DEV_VER"

#define kKeyDir         @"olddir"
#define kKeySort        @"sorttype"

#define kKeyFileList    @"files"

#define kUserDataKeyDeviceToken @"device_token"

// Server connection
#define kServerPathFileList     @"/ResourceSimulator/filemanager.php"
#define kServerPathFileListDownload     @"/ResourceSimulator/filedownloader.php"
#define kServerPathTest         @"/APNS.php"
#define kServerPathLicense      @"/license/license_connect_ios.php"
#define kServerPathNews      @"/news/news_connect_ios.php"
#define kServerPathTestList     @"/tests/tests_connect_ios.php"

#define kServerPathUpdateRank @"/"

#define kServerPathUpdateUser @"/user/update_user"

#define ROUND_OFF(v, c) if(v < -c){ v = c + (v + c);}\
else if(v > c){v = -c + (v - c);}



@implementation MSServerConnector
@synthesize success = success_;
@synthesize data = data_;

-(id) initWithAppID:(NSString*)appID
           Delegate:(id)delegate
         okSelector:(SEL)okSelector
       failSelector:(SEL)failSelector
{
	if( (self = [super init]) )
	{
        _appID = [appID retain];
        _appName = nil;
		delegate_ = [delegate retain];
		okSelector_ = okSelector;
		failSelector_ = failSelector;
		
		success_ = NO;
		data_ = nil;
	}
	
	return self;
}

-(id) initWithAppID:(NSString*)appID
            AppName:(NSString*)appName
           delegate:(id)delegate
         okSelector:(SEL)okSelector
       failSelector:(SEL)failSelector
{
	if( (self = [super init]) )
	{
		_appID = [appID retain];
		_appName = [appName retain];
		delegate_ = [delegate retain];
		okSelector_ = okSelector;
		failSelector_ = failSelector;
		
		success_ = NO;
		data_ = nil;
	}
	
	return self;
}

-(void) dealloc
{
	//[data_ release];
    data_ = nil;
	[delegate_ release];
    if(_appID)
        [_appID release];
    if(_appName)
        [_appName release];
	[super dealloc];
}


#pragma mark Server Connection Methods

-(NSURL*) getURLWithPath:(NSString*)path
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerURL, path]];
}

- (void) test
{
//    NSURL* url = [self getURLWithPath:kServerPathTest];
//	HttpClient* downloader = [[HttpClient alloc] initWithURL:url
//													delegate:self 
//												doneSelector:@selector(done:)
//											   errorSelector:@selector(fail:)];
//    
//    [downloader setValue:@"1" forName:@"test"];
//	[downloader download];
    
    NSString* urlString = [NSString stringWithFormat:@"%@",[self getURLWithPath:kServerPathTest]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"]; 
    [request setPostValue:@"1" forKey:@"test"];
    
    [request setDidFinishSelector:@selector(done:)];
    [request setDidFailSelector:@selector(fail:)];
    [request setDelegate:self];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
    [request setTimeOutSeconds:4.0f];
    [request startAsynchronous];
    
}

- (void) setttingAppDefaultInfo:(ASIFormDataRequest*)downloader
{
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = @"ResourceTool";
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    //NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
    

    [downloader setPostValue:_appID forKey:kKeyAppID];
    if(_appName)
        [downloader setPostValue:_appName forKey:kKeyAppName];
    else
        [downloader setPostValue:appName forKey:kKeyAppName];
    [downloader setPostValue:deviceUuid forKey:kKeyUdid];
    [downloader setPostValue:appVersion forKey:kKeyBuildVer];
    [downloader setPostValue:deviceModel forKey:kKeyDevModel];
    [downloader setPostValue:deviceSystemVersion forKey:kKeyDevVer];
    
}

- (void) sendLicenseAppinfo:(NSString*)task
{
//    NSURL* url = [self getURLWithPath:kServerPathLicense];
    SEL done = nil;
    SEL fail = nil;
    if([task rangeOfString:@"REG"].length > 0)
    {
        done = @selector(registerAppDone:);
        fail = @selector(registerAppFail:);
    }else
    {
        done = @selector(updateAppDone:);
        fail = @selector(updateAppFail:);
    }
//	HttpClient* downloader = [[HttpClient alloc] initWithURL:url
//													delegate:self 
//												doneSelector:@selector(registerAppDone:)
//											   errorSelector:@selector(registerAppFail:)];
//    
//    [downloader setValue:task forName:kKeyTask];
//    [self setttingAppDefaultInfo:downloader];
//	[downloader download];

    NSString* urlString = [NSString stringWithFormat:@"%@",[self getURLWithPath:kServerPathLicense]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"]; 
    [request setPostValue:task forKey:kKeyTask];
    [self setttingAppDefaultInfo:request];
    [request setDidFinishSelector:done];
    [request setDidFailSelector:fail];
    [request setDelegate:self];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
    [request setTimeOutSeconds:4.0f];
    [request startAsynchronous];

}

- (void) conversionApp
{
//    NSURL* url = [self getURLWithPath:kServerPathLicense];
//	HttpClient* downloader = [[HttpClient alloc] initWithURL:url
//													delegate:self 
//												doneSelector:@selector(registerAppDone:)
//											   errorSelector:@selector(registerAppFail:)];
//
//    NSAssert([_appID intValue] % 2 == 1, @"app is full version it only free version methods.");
//    
//    [downloader setValue:@"CONVERSION" forName:kKeyTask];
//    [self setttingAppDefaultInfo:downloader];
//	[downloader download];
    
    NSString* urlString = [NSString stringWithFormat:@"%@",[self getURLWithPath:kServerPathLicense]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"]; 
    [request setPostValue:@"CONVERSION" forKey:kKeyTask];
    
    [request setDidFinishSelector:@selector(registerAppDone:)];
    [request setDidFailSelector:@selector(registerAppFail:)];
    [request setDelegate:self];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
    [request setTimeOutSeconds:4.0f];
    [request startAsynchronous];
    
}

- (void) licenseProcess
{
    NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
    
    if([_default objectForKey:kLicensed] == nil || 
       [[_default objectForKey:kLicensed] rangeOfString:@"NO"].length > 0)
    {
        [self sendLicenseAppinfo:@"REG"];
        
    }else if([[_default objectForKey:kLicensed] rangeOfString:@"YES"].length > 0)
    {
        NSString* build_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if([[_default objectForKey:kLicensedBuildVer] rangeOfString:build_ver].length == 0)
        {
            [self sendLicenseAppinfo:@"UPDATE"];
        }
    }
}

- (void) getSimulateDataFiles:(NSMutableArray*) data
{
    NSString* urlString = [NSString stringWithFormat:@"%@",[self getURLWithPath:kServerPathFileListDownload]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString* fileLists = @"";
    
    if([data count])
    {
        for (int i = 0; i < [data count]; i++) {
            fileLists = [fileLists stringByAppendingFormat:@"/%@||",[data objectAtIndex:i]];
        }
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"]; 
        [request setPostValue:fileLists forKey:kKeyFileList];
        
        [request setDidFinishSelector:@selector(done:)];
        [request setDidFailSelector:@selector(fail:)];
        [request setDelegate:self];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
        [request setTimeOutSeconds:4.0f];
        [request startAsynchronous];
    }else
    {
        [self fail:nil];
    }
}
- (void) getFileList:(NSString*)path Sort:(NSString*)sort
{
    NSString* urlString = [NSString stringWithFormat:@"%@",[self getURLWithPath:kServerPathFileList]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"]; 
    [request setPostValue:path forKey:kKeyDir];
    [request setPostValue:sort forKey:kKeySort];
    
    [request setDidFinishSelector:@selector(done:)];
    [request setDidFailSelector:@selector(fail:)];
    [request setDelegate:self];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: NO];
    [request setTimeOutSeconds:4.0f];
    [request startAsynchronous];    
    
}
#pragma mark - user custom selector

//-(void) registerAppDone:(HttpClient*)downloader
-(void) registerAppDone:(ASIHTTPRequest *)request
{
//    if(downloader.m_pRecvData)
//    {
//        data_ = downloader.m_pRecvData;
//        NSString* str = [[[NSString alloc] initWithData:(NSData*)data_ 
//                                               encoding:NSUTF8StringEncoding] 
//                         autorelease]; 
//        
//        NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
//        
//        NSString* build_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        
//        [_default setObject:@"YES" forKey:kLicensed];
//        [_default setObject:build_ver forKey:kLicensedBuildVer];
//        [_default synchronize];
//        [self ok];
//
//    }
//
//	[downloader release];
    
    
    NSString *responseString = [request responseString];
    
    data_ = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data_)
    {
  
        NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
        
        NSString* build_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [_default setObject:@"YES" forKey:kLicensed];
        [_default setObject:build_ver forKey:kLicensedBuildVer];
        [_default synchronize];
        [self ok];
    }
    else
        [self newsFail:nil];
    
    
}

-(void) registerAppFail:(ASIHTTPRequest *)request
{
    NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
    
    [_default setObject:@"NO" forKey:kLicensed];
    [_default removeObjectForKey:kLicensedBuildVer];
    [_default synchronize];
    [self fail];
	data_ = nil;
    //[downloader release];
    
}

-(void) updateAppDone:(ASIHTTPRequest *)request
{
//    if(downloader.m_pRecvData)
//    {
//        data_ = downloader.m_pRecvData;
//        NSString* str = [[[NSString alloc] initWithData:(NSString*)data_ 
//                                               encoding:NSUTF8StringEncoding] 
//                         autorelease]; 
//        
//        NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
//        
//        NSString* build_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        [_default setObject:build_ver forKey:kLicensedBuildVer];
//        [_default synchronize];
//    }
//    
//    [self ok];
//	[downloader release];
    
    
    NSString *responseString = [request responseString];
    
    data_ = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data_)
    {

        NSUserDefaults* _default = [NSUserDefaults standardUserDefaults];
        
        NSString* build_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        [_default setObject:build_ver forKey:kLicensedBuildVer];
        [_default synchronize];
        [self ok];
    }
    else
        [self newsFail:nil];
}

//-(void) updateAppFail:(HttpClient*)downloader
-(void) updateAppFail:(ASIHTTPRequest *)request
{
	data_ = nil;
    [self fail];
	//[downloader release];
}


//-(void) newsDone:(HttpClient*)downloader
-(void) newsDone:(ASIHTTPRequest *)request
{
    // Use when fetching text data
//    
//    if(downloader.m_pRecvData)
//    {
//        data_ = downloader.m_pRecvData;
//        
//        [self ok];
//    }
//    
//	[downloader release];

    NSString *responseString = [request responseString];
    
    data_ = [self responseToData:responseString];
    
    if(data_)
        [self ok];
    else
        [self newsFail:nil];
}

-(void) newsFail:(ASIHTTPRequest *)request
{
	data_ = nil;
    [self fail];
    //[downloader release];
}

-(void) ok
{
    if([delegate_ respondsToSelector:okSelector_])
        [delegate_ performSelector:okSelector_ withObject:self];
}

-(void) fail
{
	if([delegate_ respondsToSelector:failSelector_])
        [delegate_ performSelector:failSelector_ withObject:self];
}

//-(void) done:(HttpClient*)downloader
-(void) done:(ASIHTTPRequest*)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    data_ = [self responseToData:responseString];
    
    if(data_)
        [self ok];
    else
        [self fail:nil];
    
    
    
}

-(void) fail:(ASIHTTPRequest*)request
{
	data_ = nil;
    [self fail];
    
//	[downloader release];
}

-(NSData*) responseToData:(NSString*) responseString
{
    NSData* pData = nil;
    [responseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%s: data: %s\n", __func__, [reply UTF8String]); 
    
    if([responseString rangeOfString:@"Server process error."].length > 0)
    {
        
        return pData;
    }else   {
        if([responseString rangeOfString:@"Server process finish."].length > 0)
        {
            if([responseString rangeOfString:@"<?xml"].length > 0
               && [responseString rangeOfString:@"</plist>"].length > 0)
            {
                NSRange range = [responseString rangeOfString:@"<?xml"];
                range.length = range.location;
                range.location = 0;
                responseString = [responseString stringByReplacingCharactersInRange:range withString:@""];
                
                range = [responseString rangeOfString:@"</plist>"];
                range.location += range.length;
                range.length = [responseString length] - range.location;
                
                responseString = [responseString stringByReplacingCharactersInRange:range withString:@""];
                
                pData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            }else   {
                NSRange range = [responseString rangeOfString:@"Server process start."];
                responseString = [responseString stringByReplacingCharactersInRange:range withString:@""];
                
                range = [responseString rangeOfString:@"Server process finish."];
                responseString = [responseString stringByReplacingCharactersInRange:range withString:@""];
                
                pData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        
        return pData;
    }
}
@end
