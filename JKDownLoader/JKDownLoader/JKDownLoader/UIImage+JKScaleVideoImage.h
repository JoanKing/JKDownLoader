//
//  UIImage+JKScaleVideoImage.h
//  JKLaunchAd
//
//  Created by 王冲 on 2018/12/17.
//  Copyright © 2018年 JK科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JKScaleVideoImage)

#pragma mark 截取指定时间的视频缩略图
/**
 截取指定时间的视频缩略图
 
 @param url 视频的链接
 @param videoTime 时间点，单位：s
 @param imageMaxSize 最大尺寸
 @return 返回一个图片
 */
+(UIImage *)jk_videoThumbnailImageWithVideoUrl:(NSURL *)url withVideoTime:(CGFloat)videoTime withVideoImageMaxSize:(CGSize)imageMaxSize;

@end

NS_ASSUME_NONNULL_END
