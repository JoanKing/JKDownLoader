//
//  JKDownLoader.m
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKDownLoader.h"

@interface JKDownLoader()

/* 保存文件的输出流
 - (void)open; 写入之前，打开流
 - (void)close; 写入完毕之后，关闭流
 */
@property(nonatomic,strong)NSOutputStream *fileStream;

/*
 保存下载线程的运行循环,也就是下载任务的 runloop
 */
@property(nonatomic,assign)CFRunLoopRef downloadRunloop;

/*
 下载的 downloadConnection
 */
@property(nonatomic,strong)NSURLConnection *downloadConnection;


@end

@implementation JKDownLoader


/**
 取消当前下载
 */
-(void)pause{
    
    [self.downloadConnection cancel];
}

#pragma mark 下载
/**
 目的： 下载
 1.先实现一个简单的下载功能
 2.对外提供接口
 
 NSURLSession下载
 1.跟踪进度
 2.断点续传
    2.1、将文件保存到固定的位置；
    2.2、再次下载文件前，先检查固定位置是否存在文件
    2.3、如果有，直接速传
 3.扩展
    3.1、进度  --- 通知下载的百分比
    3.2、是否完成 ---通知下载保存路径
    3.3、是否出错  -- 通知错误信息

 @param url 下载的url
 */
-(void)jk_downloadWithUrl:(NSURL *)url withDownProgress:(downProgress)progress completion:(downCompletion)completion fail:(downFailed)failed{
    
    // block 赋值
    self.progress = progress;
    self.completion = completion;
    self.failed = failed;
    
    // 0、保存下载的 URL
    self.downloadUrl = url;
    
    // 1、检查服务器文件的大小
    [self selectServerFileInfoWithUrl:url];
    NSLog(@"服务器文件总大小：%lld \n文件保存位置：%@",self.expectdContentLength,self.downloadPath);
    // 2、检查本地文件的大小
    if (![self checkLocalFileInfo]) {
        NSLog(@"文件已经下载到本地，不需要再次下载");
        return;
    }
    NSLog(@"下载文件");
    // 3、如果需要就要从服务器下载
    NSLog(@"从 %lld 开始下载文件",self.currentContentLength);
    [self downloadFile];
}

#pragma mark 下载文件
-(void)downloadFile{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1.建立请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:self.downloadUrl cachePolicy:1 timeoutInterval:MAXFLOAT];
        // 2.设置下载的字节范围，self.currentLength到之后所有的字节
        NSString *downloadRangeStr = [NSString stringWithFormat:@"bytes=%lld-",self.currentContentLength];
        // 3.设置请求头字段
        [request setValue:downloadRangeStr forHTTPHeaderField:@"Range"];
        // 4.开始网络连接
        self.downloadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        // 5.设置代理工作的操作 [[NSOperationQueue alloc]init] 默认创建一个异步并发队列
        [self.downloadConnection setDelegateQueue:[[NSOperationQueue alloc]init]];
        // 启动连接
        [self.downloadConnection start];
        
        //5.启动运行循环
        /*
         CoreFoundation 框架 CFRunLoop
         CFRunloopStop() 停止指定的runloop
         CFRunloopGetCurrent() 获取当前的Runloop
         CFRunloopRun() 直接启动当前的运行循环
         */
        
        // (1)、拿到当前的运行循环
        self.downloadRunloop = CFRunLoopGetCurrent();
        // (2)、启动当前的运行循环
        CFRunLoopRun();

    });

}

#pragma mark NSURLConnection的代理NSURLConnectionDataDelegate的方法
// 1、接收服务器的响应 --- 状态和响应头做一些准备工作
// expectedContentLength : 文件的总大小
// suggestedFilename : 服务器建议保存的名字
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    self.fileStream = [[NSOutputStream alloc]initToFileAtPath:self.downloadPath append:YES];
    [self.fileStream open];
    
}
// 2、接收服务器的数据，由于数据是分块发送的，这个代理方法会被执行多次，因此我们也会拿到多个data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // 接收数据，用输出流拼接，计算下载进度
    
    // 将数据拼接起来，并判断是否可写如，一般情况下可写入，除非磁盘空间不足
    if ([self.fileStream hasSpaceAvailable]) {
        
        [self.fileStream write:data.bytes maxLength:data.length];
    }
    
    // 当前长度拼接
    self.currentContentLength += data.length;
    
    // 计算百分比
    // progress = (float)long long / long long
    float progress = (float)self.currentContentLength/self.expectdContentLength;
    
    // 传送百分比
    if (self.progress) {
        self.progress(progress);
    }
    
    NSLog(@"%f %@",progress,[NSThread currentThread]);
    
}
// 3、接收到所有的数据下载完毕后会有一个通知
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    NSLog(@"下载完毕");
    
    [self.fileStream close];
    
    // 下载完成的回调
    if (self.completion) {
        self.completion(self.downloadPath);
    }
    
    // 关闭当前下载完的 RunLoop
    CFRunLoopStop(self.downloadRunloop);
    
}

// 4、下载错误的处理
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"连接失败：%@",error.localizedDescription);
    // 关闭流
    [self.fileStream close];
    
    // 关闭当前的 RunLoop
    CFRunLoopStop(self.downloadRunloop);
    
}

#pragma mark 私有方法
#pragma mark 2.从本地检查要下载的文件信息
/**
 2.从本地检查要下载的文件信息(除了文件下载完，其他的情况都需要下载文件)

 @return YES：需要下载，NO：不需要下载
 */
-(BOOL)checkLocalFileInfo{
    
    long long fileSize = 0;
    // 1.判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:self.downloadPath]) {
        
        // 获取本地存在文件大小
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:self.downloadPath error:NULL];
        NSLog(@"%@",attributes);
        fileSize = [attributes[NSFileSize] longLongValue];
    }
    
    // 2.根据文件大小来判断文件是否存在
    if(fileSize > self.expectdContentLength){
        
        // 文件异常，删除该文件
        [[NSFileManager defaultManager]removeItemAtPath:self.downloadPath error:NULL];
        fileSize = 0;
    }else if (fileSize == self.expectdContentLength)
    {
        // 文件已经下载完
        return NO;
    }
    
    // 记录下载的位置
    self.currentContentLength = fileSize;
    
    return YES;
}

#pragma mark 1.从服务器查询下载文件的信息
// 1.从服务器查询下载文件的信息
-(void)selectServerFileInfoWithUrl:(NSURL *)url{
    
    // 1.请求信息
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:kTimeOut];
    request.HTTPMethod = @"HEAD";
    
    // 2.建立网络连接
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    // NSLog(@"%@ %@ %lld",data,response,response.expectedContentLength);
    // 3.记录服务器的文件信息
    // 3.1、文件长度
    self.expectdContentLength = response.expectedContentLength;

    // 3.2、建议保存的文件名字，将在文件保存在tmp，系统会自动回收
    // self.downloadPath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
    // self.downloadPath = [@"/Users/wangchong/Desktop/JK视频下载器" stringByAppendingPathComponent:response.suggestedFilename];
    NSString *documentsPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/JKDowning"];
    self.downloadPath = [documentsPath stringByAppendingPathComponent:response.suggestedFilename];
    
}

@end
