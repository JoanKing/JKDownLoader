//
//  JKDownLoader.h
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 超时的时间
#define kTimeOut 20.0

NS_ASSUME_NONNULL_BEGIN

// 下载成功的 block 返回下载后的文件路径
typedef void(^downCompletion)(NSString *downFilePath);
// 下载进度的 block 返回进度值
typedef void(^downProgress)(float progress);
// 下载失败的 block 返回下载失败的信息
typedef void(^downFailed)(NSString *error);

@interface JKDownLoader : NSObject<NSURLConnectionDataDelegate>

/**
 文件的总大小
 */
@property(nonatomic,assign) long long expectdContentLength;
/**
 本地已经下载的文件总大小
 */
@property(nonatomic,assign) long long currentContentLength;
/**
 视频的下载地址 URL
 */
@property(nonatomic,strong) NSURL *downloadUrl;
/**
 文件的下载路径
 */
@property(nonatomic,strong) NSString *downloadPath;


@property(nonatomic,strong) downCompletion completion;
@property(nonatomic,strong) downProgress progress;
@property(nonatomic,strong) downFailed failed;

#pragma mark 定义一个下载的方法
/**
 定义一个下载的方法

 @param url 下载的地址 url
 */
-(void)jk_downloadWithUrl:(NSURL *)url withDownProgress:(downProgress)progress completion:(downCompletion)completion fail:(downFailed)failed;


#pragma mark 暂停下载
-(void)pause;

@end

NS_ASSUME_NONNULL_END
