//
//  HttpClient.m
//  HttpClient
//
//  Created by 고윤환 on 11. 1. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import "HttpClient.h" 
#import <zlib.h> 

@implementation HttpClient 
@synthesize m_pDownload,m_pRecvData;
/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader initWithURL:filePath:delegate:doneSelector:errorSelector:] -- 
 * 
 *      Initializer. Kicks off the upload. Note that upload will happen on a 
 *      separate thread. 
 * 
 * Results: 
 *      An instance of Uploader. 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (id)initWithURL: (NSURL *)aServerURL   // IN 
         filePath: (NSString *)aFilePath // IN 
         delegate: (id)aDelegate         // IN 
     doneSelector: (SEL)aDoneSelector    // IN 
    errorSelector: (SEL)anErrorSelector  // IN 
{ 
    if ((self = [super init])) { 
		ASSERT(aServerURL); 
		ASSERT(aFilePath); 
		ASSERT(aDelegate); 
		ASSERT(aDoneSelector); 
		ASSERT(anErrorSelector); 
		serverURL = [aServerURL retain]; 
		filePath = [aFilePath retain]; 
		delegate = [aDelegate retain]; 
		doneSelector = aDoneSelector; 
		errorSelector = anErrorSelector; 
		[self upload]; 
    } 
    return self; 
} 


-	(id)initWithURL: (NSURL *)aServerURL  
			 data: (NSData *)data  
		 delegate: (id)aDelegate  
	 doneSelector: (SEL)aDoneSelector  
	errorSelector: (SEL)anErrorSelector
{
	if ((self = [super init])) { 
		ASSERT(aServerURL); 
		ASSERT(data); 
		ASSERT(aDelegate); 
		ASSERT(aDoneSelector); 
		ASSERT(anErrorSelector); 
		serverURL = [aServerURL retain]; 
		delegate = [aDelegate retain]; 
		doneSelector = aDoneSelector; 
		errorSelector = anErrorSelector; 
		//[self download:data]; 
    } 
    return self;
	
}

-	(id)initWithURL: (NSURL *)aServerURL  
		 delegate: (id)aDelegate  
	 doneSelector: (SEL)aDoneSelector  
	errorSelector: (SEL)anErrorSelector
{
	if ((self = [super init])) { 
		ASSERT(aServerURL); 
		ASSERT(aDelegate); 
		ASSERT(aDoneSelector); 
		ASSERT(anErrorSelector); 
		serverURL = [aServerURL retain]; 
		delegate = [aDelegate retain]; 
		doneSelector = aDoneSelector; 
		errorSelector = anErrorSelector; 
		//[self download:data]; 
    } 
    return self;
}
/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader dealloc] -- 
 * 
 *      Destructor. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)dealloc 
{ 
    [serverURL release]; 
    serverURL = nil; 
    [filePath release]; 
    filePath = nil; 
	[m_pDownload release];
	m_pDownload = nil;
	[m_pDict release];
	[m_pFileDict release];
    [delegate release]; 
    delegate = nil; 
    doneSelector = NULL; 
    errorSelector = NULL; 
    [super dealloc]; 
} 

-(void) setValue:(NSString*)value forName:(NSString *)name
{
	if(m_pDict == nil)
		m_pDict = [[NSMutableDictionary alloc] init];
	[m_pDict setValue:value forKey:name];
}

-(void) setFileContents:(NSData*)data forName:(NSString*)name
{
	if(m_pFileDict == nil)
		m_pFileDict = [[NSMutableDictionary alloc] init];
	[m_pFileDict setValue:data forKey:name];
}

/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader filePath] -- 
 * 
 *      Gets the path of the file this object is uploading. 
 * 
 * Results: 
 *      Path to the upload file. 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (NSString *)filePath 
{ 
    return filePath; 
} 

@end // Uploader 

@implementation HttpClient (Private) 

/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) upload] -- 
 * 
 *      Uploads the given file. The file is compressed before beign uploaded. 
 *      The data is uploaded using an HTTP POST command. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)upload 
{ 
    NSData *data = [NSData dataWithContentsOfFile:filePath]; 
    ASSERT(data); 
    if (!data) { 
		[self uploadSucceeded:NO]; 
		return; 
    } 
    if ([data length] == 0) { 
		// There's no data, treat this the same as no file. 
		[self uploadSucceeded:YES]; 
		return; 
    } 
	//  NSData *compressedData = [self compress:data]; 
	//  ASSERT(compressedData && [compressedData length] != 0); 
	//  if (!compressedData || [compressedData length] == 0) { 
	//  [self uploadSucceeded:NO]; 
	//  return; 
	//  } 
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL 
												boundry:BOUNDRY 
												   data:data]; 
    if (!urlRequest) { 
		[self uploadSucceeded:NO]; 
		return; 
    } 
    NSURLConnection * connection = 
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; 
    if (!connection) { 
		[self uploadSucceeded:NO]; 
    } 
    // Now wait for the URL connection to call us back. 
} 

- (void)download:(NSData*)data
{ 
    downloadDidSucceed = NO;
	
    ASSERT(data); 
    if (!data) { 
		[self downloadSucceeded:NO]; 
		return; 
    } 
    if ([data length] == 0) { 
		// There's no data, treat this the same as no file. 
		[self downloadSucceeded:YES]; 
		return; 
    } 
	
	NSData *compressedData = [self compress:data]; 
	ASSERT(compressedData && [compressedData length] != 0); 
	if (!compressedData || [compressedData length] == 0) { 
		[self downloadSucceeded:NO]; 
		return; 
	} 
	
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL 
												boundry:BOUNDRY 
												   data:data]; 
    if (!urlRequest) { 
		[self downloadSucceeded:NO]; 
		return; 
    } 

    NSURLConnection * connection = 
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; 
    if (!connection) { 
		[self downloadSucceeded:NO]; 
    } 
    // Now wait for the URL connection to call us back. 
} 

- (void)download
{ 
    downloadDidSucceed = NO;
	
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL 
												boundry:BOUNDRY 
												   data:nil]; 
    if (!urlRequest) { 
		[self downloadSucceeded:NO]; 
		return; 
    } 
	
    NSLog(@"urlRequest = %@",urlRequest);
    NSURLConnection * connection = 
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; 
    if (!connection) { 
		[self downloadSucceeded:NO]; 
    } 
    // Now wait for the URL connection to call us back. 
} 
/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) postRequestWithURL:boundry:data:] -- 
 * 
 *      Creates a HTML POST request. 
 * 
 * Results: 
 *      The HTML POST request. 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (NSURLRequest *)postRequestWithURL: (NSURL *)url        // IN 
                             boundry: (NSString *)boundry // IN 
                                data: (NSData *)data      // IN 
{ 
    // from http://www.cocoadev.com/index.pl?HTTPFileUpload 
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url]; 
    [urlRequest setHTTPMethod:@"POST"]; 
    
	
	// Names and values
	
    if(m_pRecvData != nil)
	   [m_pRecvData release];
    m_pRecvData = nil;
    
	NSMutableString* body = [NSMutableString string];
	if([m_pDict count] > 0)
	{
		for(NSString* name in [m_pDict allKeys]){
			NSString* value = [m_pDict objectForKey:name];
			
			[body appendString:[NSString stringWithFormat:@"%@=%@&", name, value]];
		}
	}
	
	// Files
	NSMutableData *postData = [NSMutableData data];
	if([m_pFileDict count] > 0){
		[urlRequest setValue:
		 [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDRY]
		  forHTTPHeaderField:@"Content-Type"];
		
		
		
		
		for(NSString *name in [m_pFileDict allKeys]){
			// File data should be compressed.
			NSData* d = [self compress:[m_pFileDict objectForKey:name]];
			
			[postData appendData:
			 [[NSString stringWithFormat:@"--%@\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:
			 [[NSString stringWithFormat:
			   @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", name, name]
			  dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:d];
			[postData appendData:
			 [[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
		}
		
		
	}
	
	[postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog(@"%@", [[[NSString alloc] initWithData:postData
										encoding:NSUTF8StringEncoding]
				  autorelease]);
	
	
	if(data != nil)
	{
		[urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] 
								forHTTPHeaderField:@"Content-Type"]; 
		
		//NSMutableData *postData = [NSMutableData dataWithCapacity:[data length] + 512]; 
		
		[postData appendData: [[NSString stringWithFormat:@"--%@\r\n", boundry] 
															dataUsingEncoding:NSUTF8StringEncoding]]; 
		[postData appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.bin\"\r\n\r\n", FORM_FLE_INPUT] 
															dataUsingEncoding:NSUTF8StringEncoding]]; 
		[postData appendData:data]; 
		
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] 
															dataUsingEncoding:NSUTF8StringEncoding]]; 
	}
    [urlRequest setHTTPBody:postData]; 
    return urlRequest; 
} 
/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) compress:] -- 
 * 
 *      Uses zlib to compress the given data. 
 * 
 * Results: 
 *      The compressed data as a NSData object. 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (NSData *)compress: (NSData *)data // IN 
{ 
    if (!data || [data length] == 0) 
		return nil; 
    // zlib compress doc says destSize must be 1% + 12 bytes greater than source. 
    uLong destSize = [data length] * 1.001 + 12; 
    NSMutableData *destData = [NSMutableData dataWithLength:destSize]; 
    int error = compress((Bytef*)[destData mutableBytes], 
						 &destSize, 
						 (Bytef*)[data bytes], 
						 [data length]); 
    if (error != Z_OK) { 
		NSLog(@"%s: self:0x%p, zlib error on compress:%d\n",__func__, self, error); 
		return nil; 
    } 
    [destData setLength:destSize]; 
    return destData; 
} 


-(NSData*) uncompress:(NSData*)data
{
	if(!data || [data length] == 0){
		return nil;
	}
	
	// Dest size must be enough.
	uLong destSize = 1024*1024;
	NSMutableData *destData = [NSMutableData dataWithLength:destSize];
	
	int error = uncompress((Bytef*)[destData mutableBytes], &destSize, 
						   (Bytef*)[data bytes], [data length]);
	
	if(error != Z_OK){
		return nil;
	}
	
	[destData setLength:destSize];
	return destData;
}


/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) uploadSucceeded:] -- 
 * 
 *      Used to notify the delegate that the upload did or did not succeed. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)uploadSucceeded: (BOOL)success // IN 
{ 
    [delegate performSelector:success ? doneSelector : errorSelector 
				   withObject:self]; 
} 

- (void)downloadSucceeded: (BOOL)success // IN
{
    
    
	if(success){
        NSString *reply = [[[NSString alloc] initWithData:m_pRecvData
                                                 encoding:NSUTF8StringEncoding] 
                           autorelease]; 
        
        if([reply rangeOfString:@"Server process finish."].length > 0)
        {
            NSRange range = [reply rangeOfString:@"Server process start."];
            reply = [reply stringByReplacingCharactersInRange:range withString:@""];
            
            range = [reply rangeOfString:@"Server process finish."];
            reply = [reply stringByReplacingCharactersInRange:range withString:@""];
            
            [m_pRecvData release];
            m_pRecvData = nil;
            m_pRecvData = [reply dataUsingEncoding:NSUTF8StringEncoding];
            [m_pRecvData retain];
        }

		// uncompress the response data
		NSData* uncompressed = [self uncompress:m_pDownload];
		[m_pDownload release];
		m_pDownload = [uncompressed retain];
	}
	
    if([delegate respondsToSelector:doneSelector] && [delegate respondsToSelector:errorSelector])
        [delegate performSelector:(success ? doneSelector : errorSelector)
				   withObject:self]; 
}

/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) connectionDidFinishLoading:] -- 
 * 
 *      Called when the upload is complete. We judge the success of the upload 
 *      based on the reply we get from the server. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection // IN 
{ 
    NSLog(@"%@",connection);
    NSLog(@"%s: self:0x%p\n", __func__, self); 
    [connection release]; 
    //[self uploadSucceeded:uploadDidSucceed]; 
	[self downloadSucceeded:downloadDidSucceed];
} 
/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) connection:didFailWithError:] -- 
 * 
 *      Called when the upload failed (probably due to a lack of network 
 *      connection). 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)connection:(NSURLConnection *)connection // IN 
  didFailWithError:(NSError *)error              // IN 
{ 
    NSLog(@"%s: self:0x%p, connection error:%s\n", 
		  __func__, self, [[error description] UTF8String]); 
    [connection release]; 
	
	//[self uploadSucceeded:NO];
    [self downloadSucceeded:NO]; 
} 

/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) connection:didReceiveResponse:] -- 
 * 
 *      Called as we get responses from the server. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
-(void)       connection:(NSURLConnection *)connection // IN 
      didReceiveResponse:(NSURLResponse *)response     // IN 
{ 
    NSLog(@"%s: self:0x%p\n", __func__, self); 
} 

/* 
 *----------------------------------------------------------------------------- 
 * 
 * -[Uploader(Private) connection:didReceiveData:] -- 
 * 
 *      Called when we have data from the server. We expect the server to reply 
 *      with a "YES" if the upload succeeded or "NO" if it did not. 
 * 
 * Results: 
 *      None 
 * 
 * Side effects: 
 *      None 
 * 
 *----------------------------------------------------------------------------- 
 */ 
- (void)connection:(NSURLConnection *)connection // IN 
    didReceiveData:(NSData *)data                // IN 
{ 
    NSLog(@"%s: self:0x%p\n", __func__, self); 
    NSString *reply = [[[NSString alloc] initWithData:data 
											 encoding:NSUTF8StringEncoding] 
					   autorelease]; 
    
    [reply stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%s: data: %s\n", __func__, [reply UTF8String]); 
    
    if([reply rangeOfString:@"Server process error."].length > 0)
    {
        downloadDidSucceed = NO;
        [m_pRecvData release];
        m_pRecvData = nil;
        return;
    }
    
    if([reply rangeOfString:@"Server process start."].length > 0)
    {
        downloadDidSucceed = YES;
        
        m_pRecvData = [[NSMutableData alloc] initWithData:data];
        return;
    }
    
    if([reply rangeOfString:@"Server process finish."].length > 0)
    {
        downloadDidSucceed = YES;
        [m_pRecvData appendData:data];
        return;
    }
    
    if(reply != nil)
    {
        downloadDidSucceed = YES;
        [m_pRecvData appendData:data];
    }
} 

@end 