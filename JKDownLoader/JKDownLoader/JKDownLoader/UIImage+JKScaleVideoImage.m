//
//  UIImage+JKScaleVideoImage.m
//  JKLaunchAd
//
//  Created by 王冲 on 2018/12/17.
//  Copyright © 2018年 JK科技有限公司. All rights reserved.
//

#import "UIImage+JKScaleVideoImage.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (JKScaleVideoImage)


+(UIImage *)jk_videoThumbnailImageWithVideoUrl:(NSURL *)url withVideoTime:(CGFloat)videoTime withVideoImageMaxSize:(CGSize)imageMaxSize{
    
    if (!url)
    {
        return nil;
    }
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.maximumSize = imageMaxSize;
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error = nil;
    CMTime requestTime = CMTimeMakeWithSeconds(videoTime, 600);
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if(error)
    {
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@", error.localizedDescription);
        return nil;
    }
    
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

@end
