//
//  NNHTTPRequest.m
//
//
//  Created by  alic on 15-12-14.
//  Copyright (c) 2013年 alic. All rights reserved.
//

#import "NNHTTPRequest.h"

@interface NNHTTPRequest()

@property(retain,nonatomic) NSURL *url;

-(id)initWithURL:(NSURL *)downURL;
@end

@implementation NNHTTPRequest
{
    BOOL isFinish;
    BOOL _stop;
}

@synthesize url;
@synthesize savePath;
@synthesize postData;
@synthesize contentLength;
@synthesize responseData;
@synthesize code;
@synthesize requestMethod;
@synthesize suggestedFilename;
@synthesize delegate;

@synthesize startedBlock;
@synthesize finishedBlock;
@synthesize failedBlock;


-(id)initWithURL:(NSString *)theUrl{
    
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:theUrl];
    }
    return self;
}

+(id)requestWithURL:(NSString *)theUrl{
    return [[self alloc] initWithURL:theUrl];
}

-(void)setStartedBlock:(NNBasicBlock)aStartedBlock{
    if (aStartedBlock != startedBlock) {
        startedBlock = [aStartedBlock copy];
    }
   
}

-(void)setFinishedBlock:(NNFinishBlock)aFinishedBlock{
    if (aFinishedBlock != finishedBlock) {
        finishedBlock = [aFinishedBlock copy];
    }
}

-(void)setFaileBlock:(NNFailBlock)aFaileBlock{
    if (aFaileBlock != failedBlock) {
        failedBlock = [aFaileBlock copy];
    }
}

-(void)main{
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:self.url]; // 默认超时时间为60s
    
    NSLog(@"%@",self.url);
    
    if (requestMethod) {
        [request setHTTPMethod:requestMethod];
    }else
        [request setHTTPMethod:@"POST"];
    
    if (postData) {
        [request setHTTPBody:postData];
    }
    
    //[request setValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];
   // [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  // [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //NSLog(@"%@",request.allHTTPHeaderFields);
    
    
    responseData = [[NSMutableData alloc] init];
    
    [NSURLConnection connectionWithRequest:request delegate:self];

    NSLog(@"Is Main Thread %@",[[NSThread currentThread]isMainThread]?@"YES":@"NO");
    while (!isFinish) { // 等待 finish 或者 failed

        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"%s",__FUNCTION__);
    
    self.suggestedFilename = response.suggestedFilename;
    self.contentLength = response.expectedContentLength;// 服务器返回的长度，并不一定是实际长度
    
    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
    self.code = httpURLResponse.statusCode;
    
    NSLog(@"%@",httpURLResponse.allHeaderFields);
    if (startedBlock) {
        startedBlock();
    }
    
    if ([delegate respondsToSelector:@selector(requestStarted:)]) {
        [delegate requestStarted:self];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSLog(@"%s",__FUNCTION__);
    [responseData appendData:data];
    
    if ([delegate respondsToSelector:@selector(request:didReceiveResponseData:)]) {
        [delegate request:self didReceiveResponseData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"%s",__FUNCTION__);
    if (savePath) {
        [responseData writeToFile:savePath atomically:YES];
    }

    if (finishedBlock) {
        finishedBlock(responseData);
    }
    
    if ([delegate respondsToSelector:@selector(requestFinished:)]) {
        [delegate requestFinished:self];
    }

    
    isFinish = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%s",__FUNCTION__);
    
    if (failedBlock) {
        failedBlock(error);
    }
    
    if ([delegate respondsToSelector:@selector(requestFailed:didFailWithError:)]) {
        [delegate requestFailed:self didFailWithError:error];
    }
    
    isFinish = YES;
}



@end
