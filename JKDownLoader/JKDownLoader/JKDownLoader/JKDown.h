//
//  JKDown.h
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#ifndef JKDown_h
#define JKDown_h

/** 1、NSLog的宏 */
#ifdef DEBUG
#define JKLog(...) NSLog(@"%s 第%d行: %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

/** 2、屏幕的宽高 */
#define JK_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define JK_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define JKstatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height



/** 3、随机色与RGB颜色 */
#define JKRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0  blue:arc4random_uniform(256)/255.0  alpha:1.0]
#define JKRGBColor(r,g,b,p) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:p]


#endif /* JKDown_h */
