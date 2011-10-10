//
//  HttpClient.h
//  HttpClient
//
//  Created by 고윤환 on 11. 1. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY"; 
static NSString * const FORM_FLE_INPUT = @"uploaded"; 
#define ASSERT(x) NSAssert(x, @"") 

@interface HttpClient : NSObject {
	NSURL *serverURL; 
    NSString *filePath; 

    id delegate; 
    SEL doneSelector; 
    SEL errorSelector; 
    BOOL uploadDidSucceed; 
	BOOL downloadDidSucceed; 
	
	
	NSMutableDictionary* m_pDict;
	NSMutableDictionary* m_pFileDict;
	NSMutableData* m_pDownload;
    
    id m_pRecvData;
	
}
@property (nonatomic,retain) NSMutableData* m_pDownload;
@property (nonatomic,retain) NSMutableString* m_pRecvData;

-	(id)initWithURL: (NSURL *)serverURL  
			filePath: (NSString *)filePath  
			delegate: (id)delegate  
			doneSelector: (SEL)doneSelector  
			errorSelector: (SEL)errorSelector; 

-	(id)initWithURL: (NSURL *)aServerURL  
			 data: (NSData *)data
		 delegate: (id)aDelegate  
	 doneSelector: (SEL)aDoneSelector  
	errorSelector: (SEL)anErrorSelector;

-	(id)initWithURL: (NSURL *)aServerURL  
		 delegate: (id)aDelegate  
	 doneSelector: (SEL)aDoneSelector  
	errorSelector: (SEL)anErrorSelector;

-   (NSString *)filePath; 
-(void) setValue:(NSString*)value forName:(NSString *)name;
-(void) setFileContents:(NSData*)data forName:(NSString*)name;

@end


@interface HttpClient (Private) 
- (void)upload; 
- (void)download;
- (void)download:(NSData*)data;
- (NSURLRequest *)postRequestWithURL: (NSURL *)url 
                             boundry: (NSString *)boundry 
                                data: (NSData *)data; 
- (NSData *)compress: (NSData *)data; 
-(NSData*) uncompress:(NSData*)data;
- (void)uploadSucceeded: (BOOL)success; 
- (void)downloadSucceeded: (BOOL)success;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection; 
@end 


/* EX)

 [[EPUploader alloc] initWithURL:[NSURL URLWithString:@"http://yourserver.com/uploadDB.php"] 
 filePath:@"path/to/some/file" 
 delegate:self 
 doneSelector:@selector(onUploadDone:) 
 errorSelector:@selector(onUploadError:)]; 


*/