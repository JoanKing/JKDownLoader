//
//  JKDownloaderManger.h
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


// 下载成功的 block 返回下载后的文件路径
typedef void(^downCompletion)(NSString *downFilePath);
// 下载进度的 block 返回进度值
typedef void(^downProgress)(float progress);
// 下载失败的 block 返回下载失败的信息
typedef void(^downFailed)(NSString *error);


NS_ASSUME_NONNULL_BEGIN

@interface JKDownloaderManger : NSObject

@property(nonatomic,strong) downFailed failed;


+(instancetype)shareDownloaderManger;

#pragma mark 定义一个下载的方法
/**
 定义一个下载的方法
 
 @param url 下载的地址 url
 */
-(void)jk_downloadWithUrl:(NSURL *)url withDownProgress:(downProgress)progress completion:(downCompletion)completion fail:(downFailed)failed;

#pragma mark 暂停某个文件下载
-(void)pauseloadWithUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
