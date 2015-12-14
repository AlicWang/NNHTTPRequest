//
//  NNHTTPRequest.h
//
//
//  Created by  alic on 15-12-14.
//  Copyright (c) 2013年 alic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NNBasicBlock)(void);
typedef void (^NNFinishBlock)(NSData *data);
typedef void (^NNFailBlock)(NSError *error);

@protocol NNHTTPRequestDelegate;

@interface NNHTTPRequest : NSOperation


@property (retain,nonatomic) NSString *savePath;
@property (retain,nonatomic) NSData *postData;
@property (retain,nonatomic) NSMutableData *responseData;
@property (retain,nonatomic) NSString *requestMethod;


@property (assign,nonatomic) long long contentLength;
@property (retain,nonatomic) NSString *suggestedFilename;
@property (assign,nonatomic) id<NNHTTPRequestDelegate>delegate;
@property (assign,nonatomic) NSInteger code;


@property (nonatomic,copy) NNBasicBlock startedBlock;
@property (nonatomic,copy) NNFinishBlock finishedBlock;
@property (nonatomic,copy) NNFailBlock failedBlock;

-(void)setStartedBlock:(NNBasicBlock)aStartedBlock;
-(void)setFinishedBlock:(NNFinishBlock)aFinishedBlock;
-(void)setFaileBlock:(NNFailBlock)aFaileBlock;


+(id)requestWithURL:(NSString *)url;


@end




@protocol NNHTTPRequestDelegate <NSObject>

@optional

-(void)requestFinished:(NNHTTPRequest *)request;
-(void)requestStarted:(NNHTTPRequest *)request;
-(void)requestFailed:(NNHTTPRequest *)request didFailWithError:(NSError *)error;
-(void)request:(NNHTTPRequest *)request didReceiveResponseData:(NSData *)data;

@end