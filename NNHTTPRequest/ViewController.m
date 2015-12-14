//
//  ViewController.m
//  NNHTTPRequest
//
//  Created by Air on 15/12/14.
//  Copyright © 2015年 Air. All rights reserved.
//

#import "ViewController.h"
#import "NNHTTPRequest.h"

#define TEMPPath NSTemporaryDirectory()

@interface ViewController ()

@end

@implementation ViewController
{
    NSOperationQueue *queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    queue = [[NSOperationQueue alloc]init];
    
}
- (IBAction)getData:(UIButton *)sender
{
    // 下载
    
    NSString *url = @"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg";
    NSString *path = [TEMPPath stringByAppendingPathComponent:url.lastPathComponent];
    
    NSLog(@"%@",path);
    NNHTTPRequest *theRequest = [NNHTTPRequest requestWithURL:url];
    [theRequest setSavePath:path];
    theRequest.requestMethod = @"GET";
    [theRequest setFailedBlock:^(NSError *error){
        
        NSLog(@"下载失败！原因：%@",error);
    }];
    [theRequest setFinishedBlock:^(NSData *data){
        
        //NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"下载完成！%@",string);
    }];
    
    //[theRequest start]; // 同步下载
    
    [queue addOperation:theRequest]; // 异步下载
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
