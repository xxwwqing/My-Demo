//
//  ViewController.m
//  XWQDownlond
//
//  Created by qianfeng on 15/11/23.
//  Copyright © 2015年 谢文清. All rights reserved.
//

#import "ViewController.h"

#define DOWNLOADURL @"http://b.zol-img.com.cn/sjbizhi/images/7/800x1280/1416382184881.jpg?downfile=1416382184881.jpg"

@interface ViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    UIImageView *_imageView;
    
    NSURLConnection *_urlConnection;
    
     NSMutableData *_mutableData;
    
    UIProgressView *_progressView;
    //文件总长度
    unsigned long long _fileSize;
    //进度值
    double _progressValue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    
    _mutableData = [NSMutableData new];
    
    CGRect rect = {{100,100},{200,30}};
    _progressView = [[UIProgressView alloc]initWithFrame:rect];
    _progressView.center = CGPointMake(self.view.center.x, 50);
    
    [self initConnection];
    [self.view addSubview:_progressView];

   
    
}
-(void)initConnection{
    if (_urlConnection == nil) {
        NSURL *url = [NSURL URLWithString:DOWNLOADURL];
        
        
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
        
        
        _urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"失败了");
    NSLog(@"%@",[error description]);

}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [_mutableData appendData:data];
    NSLog(@"接收到数据");
    
    _progressValue = (double)_mutableData.length/_fileSize;
    _progressView.progress = _progressValue;
}

//连接成功的回调方法（首包时间），只会调一次
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    NSLog(@"连上了");
    
    //期望的文件下载总长度
    _fileSize = [response expectedContentLength];
    
}
//数据请求成功
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"数据请求成功");
    
    _imageView.image = [UIImage imageWithData:_mutableData];
    _progressView.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
