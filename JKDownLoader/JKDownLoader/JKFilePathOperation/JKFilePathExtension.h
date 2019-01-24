//
//  JKFilePathExtension.h
//  JKOCFilePathOperation
//
//  Created by 王冲 on 2019/1/24.
//  Copyright © 2019年 希爱欧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKFilePathExtension : NSObject

#pragma mark 1、判断文件或文件夹是否存在
+(BOOL)jk_judgeFileOrFolderExists:(NSString *)filePathName;
#pragma mark 2、类方法创建文件目录
/**类方法创建文件夹目录 folderNmae:文件夹的名字*/
+(NSString *)jk_createFolder:(NSString *)folderName;

#pragma mark 3、判断文件目录是否存在，不存在就创建
+(NSString *)jk_checkFilePath:(NSString *)filePath;

#pragma mark 输入文件路径，得到排序好的相关数组，可以设置升序或降序
/**
 输入文件路径，得到排序好的相关数组，可以设置升序或降序
 
 @param path 文件列表路径
 @param isascending 是否升序: YES：升  NO：降
 @return 排序好的数组
 */

+ (NSMutableArray *)jk_fileDirectoryList:(NSString *)path Isascending:(BOOL)isascending;

#pragma mark 路径下所有文件的列表
+ (NSMutableArray *)jk_fileList:(NSString *)path Isascending:(BOOL)isascending;

#pragma mark 离线列表
+ (NSMutableArray *)jk_checkJKDonePath:(NSString *)donePath withDowningPath:(NSString *)downingPath isascending:(BOOL)isascending;

#pragma mark 离线列表
+ (NSMutableArray *)jk_testcheckJKDonePath:(NSString *)donePath withDowningPath:(NSString *)downingPath isascending:(BOOL)isascending;

@end

NS_ASSUME_NONNULL_END
