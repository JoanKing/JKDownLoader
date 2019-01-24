//
//  JKFilePathExtension.m
//  JKOCFilePathOperation
//
//  Created by 王冲 on 2019/1/24.
//  Copyright © 2019年 希爱欧科技有限公司. All rights reserved.
//

#import "JKFilePathExtension.h"

@implementation JKFilePathExtension

#pragma mark 1、判断文件或文件夹是否存在
+(BOOL)jk_judgeFileOrFolderExists:(NSString *)filePathName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@",filePathName];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        
        // 不存在的路径才会创建
        return NO;
    }else{
        
        return YES;
    }
    return nil;
}

/**类方法创建文件夹目录 folderNmae:文件夹的名字*/
+(NSString *)jk_createFolder:(NSString *)folderName{
    
    // NSHomeDirectory()：应用程序目录， Caches、Library、Documents目录文件夹下创建文件夹(蓝色的)
    // @"Documents/JKPdf"
    NSString *filePath = [NSString stringWithFormat:@"%@",folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        
        // 不存在的路径才会创建
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}


+(NSString *)jk_checkFilePath:(NSString *)filePath{
    
    if (![self jk_judgeFileOrFolderExists:filePath]) {
        // 不存在创建
        
        [self jk_createFolder:filePath];
    }
    
    return filePath;
}



/**
 输入文件路径，得到排序好的相关数组，可以设置升序或降序
 
 @param path 文件列表路径
 @param isascending 是否升序
 @return 排序好的数组
 */
+ (NSMutableArray *)jk_fileDirectoryList:(NSString *)path Isascending:(BOOL)isascending{
    
    // 1.先判断路径是否存在
    if(![self jk_judgeFileOrFolderExists:path]){
        // 不存在的话直接返回一个空的列表
        return [[NSMutableArray alloc]init];
    }
    
    // 2.取得目录下所有文件列表
    NSArray *fileList  = [[NSFileManager defaultManager] subpathsAtPath:path];
    // 2.1将文件列表排序
    fileList = [fileList sortedArrayUsingComparator:^(NSString *firFile, NSString *secFile) {
        // 获取前一个文件完整路径
        NSString *firPath = [path stringByAppendingPathComponent:firFile];
        // 获取后一个文件完整路径
        NSString *secPath = [path stringByAppendingPathComponent:secFile];
        // 获取前一个文件信息
        NSDictionary *firFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firPath error:nil];
        // 获取后一个文件信息
        NSDictionary *secFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secPath error:nil];
        // 获取前一个文件创建时间
        id firData = [firFileInfo objectForKey:NSFileCreationDate];
        // 获取后一个文件创建时间
        id secData = [secFileInfo objectForKey:NSFileCreationDate];
        
        if (isascending) {
            // 升序
            return [firData compare:secData];
        } else {
            // 降序
            return [secData compare:firData];
        }
        
    }];
    
    // 将所有文件按照日期分成数组
    NSMutableArray  *listArray = [NSMutableArray new];//最终数组
    NSMutableArray  *tempArray = [NSMutableArray new];//每天文件数组
    NSDateFormatter *format    = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    for (NSString *fileName in fileList) {
        
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        // 获取文件信息
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSMutableDictionary *fileDic = [NSMutableDictionary new];
        //文件名字
        fileDic[@"Name"] = fileName;
        //文件大小
        // fileDic[NSFileSize] = fileInfo[NSFileSize];
        fileDic[NSFileSize] = [self fileSize:[fileInfo[NSFileSize] longLongValue]];
        //时间
        fileDic[NSFileCreationDate] = fileInfo[NSFileCreationDate];
        
        // 获取日期进行比较, 按照 XXXX 年 XX 月 XX 日来装数组
        if (tempArray.count > 0) {
            
            NSString *currDate = [format stringFromDate:fileInfo[NSFileCreationDate]];
            NSString *lastDate = [format stringFromDate:tempArray.lastObject[NSFileCreationDate]];
            
            if (![currDate isEqualToString:lastDate]) {
                [listArray addObject:tempArray];
                tempArray = [NSMutableArray new];
            }
        }
        [tempArray addObject:fileDic];
    }
    
    // 装载最后一个 array 数组
    if (tempArray.count > 0) {
        [listArray addObject:tempArray];
    }

    return listArray;
}

#pragma mark 路径下所有文件的列表(一定都是文件，没有文件夹)
/**
 输入文件路径，得到排序好的相关数组，可以设置升序或降序
 
 @param path 文件列表路径
 @param isascending 是否升序
 @return 排序好的数组
 */
+ (NSMutableArray *)jk_fileList:(NSString *)path Isascending:(BOOL)isascending{
    
    // 1.先判断路径是否存在
    if(![self jk_judgeFileOrFolderExists:path]){
        // 不存在的话直接返回一个空的列表
        return [[NSMutableArray alloc]init];
    }
    
    // 2.取得目录下所有文件列表
    NSArray *fileList  = [[NSFileManager defaultManager] subpathsAtPath:path];
    // 2.1将文件列表排序
    fileList = [fileList sortedArrayUsingComparator:^(NSString *firFile, NSString *secFile) {
        // 获取前一个文件完整路径
        NSString *firPath = [path stringByAppendingPathComponent:firFile];
        // 获取后一个文件完整路径
        NSString *secPath = [path stringByAppendingPathComponent:secFile];
        // 获取前一个文件信息
        NSDictionary *firFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firPath error:nil];
        // 获取后一个文件信息
        NSDictionary *secFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secPath error:nil];
        // 获取前一个文件创建时间
        id firData = [firFileInfo objectForKey:NSFileCreationDate];
        // 获取后一个文件创建时间
        id secData = [secFileInfo objectForKey:NSFileCreationDate];
        
        if (isascending) {
            // 升序
            return [firData compare:secData];
        } else {
            // 降序
            return [secData compare:firData];
        }
        
    }];
    
    // 将所有文件设置：名字，日期，大小 ，三个字段的字典
    NSMutableArray  *tempArray = [NSMutableArray new];
    NSDateFormatter *format    = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    for (NSString *fileName in fileList) {
        
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        // 获取文件信息
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSMutableDictionary *fileDic = [NSMutableDictionary new];
        //文件名字
        fileDic[@"Name"] = fileName;
        //文件大小
        // fileDic[NSFileSize] = fileInfo[NSFileSize];
        fileDic[NSFileSize] = [self fileSize:[fileInfo[NSFileSize] longLongValue]];
        //时间
        fileDic[NSFileCreationDate] = fileInfo[NSFileCreationDate];
        
        [tempArray addObject:fileDic];
    }
    
    return tempArray;
}

#pragma mark unsigned long long 转换
+(NSString *)fileSize:(long long)size{
    
    NSString *sizeString;
    
    if (size >= 1024.0*1024.0*1024.0) {
        
        sizeString = [NSString stringWithFormat:@"%.2fG",(float)size / (1024.0*1024.0*1024.0)];
        
    }else if (size >= 1024.0 * 1024.0) {
        
        sizeString = [NSString stringWithFormat:@"%.2fMB",(float)size / (1024.0 * 1024.0)];
    }else if (size >= 1024.0){
        
        sizeString = [NSString stringWithFormat:@"%.fkb",(float)size / (1024.0)];
    }else{
        
        sizeString = [NSString stringWithFormat:@"%llub",size];
    }

    return sizeString;
}

#pragma mark 路径下所有文件的列表(一定都是文件，没有文件夹)
/**
 输入文件路径，得到排序好的相关数组，可以设置升序或降序

 @param donePath 已经下载的文件列表路径
 @param downingPath 下载中的文件列表
 @param isascending 是否升序
 @return 排序好的数组
 */
+ (NSMutableArray *)jk_checkJKDonePath:(NSString *)donePath withDowningPath:(NSString *)downingPath isascending:(BOOL)isascending;{
    
    // 1.先判断 下载好的路径与下载中的路径是否存在 路径是否存在，都不存在就直接返回空列表
    if(![self jk_judgeFileOrFolderExists:donePath] && ![self jk_judgeFileOrFolderExists:downingPath]){
        // 不存在的话直接返回一个空的列表
        return [[NSMutableArray alloc]init];
    }

    // 2.定义所有的文件数组
    NSMutableArray *allFileArray = [NSMutableArray new];
    
    if ([self jk_judgeFileOrFolderExists:downingPath]) {
        
         [allFileArray addObject:[self execFile:downingPath isascending:isascending withFileType:@"1"]];
    }
    
    if ([self jk_judgeFileOrFolderExists:donePath]){
    
        [allFileArray addObject:[self execFile:donePath isascending:isascending withFileType:@"2"]];
    }
    
    return allFileArray;
}

+(NSMutableDictionary *)execFile:(NSString *)downPath isascending:(BOOL)isascending withFileType:(NSString *)type{
    
    // 2.1、取得下中目录下所有文件列表
    NSArray *fileList  = [[NSFileManager defaultManager] subpathsAtPath:downPath];
    

    
    // 2.2、将文件列表排序
    fileList = [fileList sortedArrayUsingComparator:^(NSString *firFile, NSString *secFile) {
        // 获取前一个文件完整路径
        NSString *firPath = [downPath stringByAppendingPathComponent:firFile];
        // 获取后一个文件完整路径
        NSString *secPath = [downPath stringByAppendingPathComponent:secFile];
        // 获取前一个文件信息
        NSDictionary *firFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firPath error:nil];
        // 获取后一个文件信息
        NSDictionary *secFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secPath error:nil];
        // 获取前一个文件创建时间
        id firData = [firFileInfo objectForKey:NSFileCreationDate];
        // 获取后一个文件创建时间
        id secData = [secFileInfo objectForKey:NSFileCreationDate];
        
        if (isascending) {
            // 升序
            return [firData compare:secData];
        } else {
            // 降序
            return [secData compare:firData];
        }
        
    }];
    
    // 将所有文件设置：名字，日期，大小 ，三个字段的字典
    NSMutableArray  *tempArray = [NSMutableArray new];
    NSDateFormatter *format    = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    for (NSString *fileName in fileList) {
        
        NSString *filePath = [downPath stringByAppendingPathComponent:fileName];
        // 获取文件信息
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSMutableDictionary *fileDic = [NSMutableDictionary new];
        //文件名字
        fileDic[@"Name"] = fileName;
        //文件大小
        // fileDic[NSFileSize] = fileInfo[NSFileSize];
        fileDic[NSFileSize] = [self fileSize:[fileInfo[NSFileSize] longLongValue]];
        //时间
        fileDic[NSFileCreationDate] = fileInfo[NSFileCreationDate];
        
        if(!([fileName rangeOfString:@".DS_Store"].location !=NSNotFound)){
            
            // 不包含才添加
            [tempArray addObject:fileDic];
        }
    }
    
    NSLog(@"tempArray=%@",tempArray);
    
    NSMutableDictionary *filedowingDict = [NSMutableDictionary new];
    // 下载中的类型1
    filedowingDict[@"type"] = type;
    filedowingDict[@"dowingFile"] = tempArray;
    
    return filedowingDict;
}

#pragma mark 离线列表
+ (NSMutableArray *)jk_testcheckJKDonePath:(NSString *)donePath withDowningPath:(NSString *)downingPath isascending:(BOOL)isascending{
    
    // 1.先判断 下载好的路径与下载中的路径是否存在 路径是否存在，都不存在就直接返回空列表
    if(![self jk_judgeFileOrFolderExists:donePath] && ![self jk_judgeFileOrFolderExists:downingPath]){
        // 不存在的话直接返回一个空的列表
        return [[NSMutableArray alloc]init];
    }
    
    // 2.定义所有的文件数组
    NSMutableArray *allFileArray = [NSMutableArray new];
    
    if ([self jk_judgeFileOrFolderExists:downingPath]) {
        
        [allFileArray addObjectsFromArray:[self execTestFile:downingPath isascending:isascending withFileType:@"1"]];
    }
    
    if ([self jk_judgeFileOrFolderExists:donePath]){
        
        [allFileArray addObjectsFromArray:[self execTestFile:donePath isascending:isascending withFileType:@"2"]];
    }
    
    return allFileArray;
}


+(NSMutableArray *)execTestFile:(NSString *)downPath isascending:(BOOL)isascending withFileType:(NSString *)type{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:downPath error:nil];
    
    NSLog(@"contentsOfPathArray=%@",fileList);
    
    // 2、遍历每一个
    
    NSMutableArray *filedowingArray = [NSMutableArray new];
    
    // 将所有文件设置：名字，日期，大小 ，三个字段的字典
    NSMutableArray  *tempArray = [NSMutableArray new];
    NSDateFormatter *format  = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    for (NSString *fileName in fileList) {
        
        if([fileName rangeOfString:@".DS_Store"].location !=NSNotFound) continue;
        
        NSMutableArray  *tempArray2 = [NSMutableArray new];
        
        NSString *filePath = [downPath stringByAppendingPathComponent:fileName];
        // 获取文件信息
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSMutableDictionary *fileDic = [NSMutableDictionary new];
        //文件名字
        fileDic[@"Name"] = fileName;
        //文件大小
        // fileDic[NSFileSize] = fileInfo[NSFileSize];
        fileDic[NSFileSize] = [self fileSize:[fileInfo[NSFileSize] longLongValue]];
        //时间
        fileDic[NSFileCreationDate] = fileInfo[NSFileCreationDate];

        NSMutableDictionary *filedowingDict = [NSMutableDictionary new];
        
        if ([type isEqualToString:@"2"]) {
            
            [tempArray2 addObject:fileDic];
            
            NSString *smallFilePath = [downPath stringByAppendingPathComponent:fileName];
            NSArray *smallfileList = [fileManager contentsOfDirectoryAtPath:smallFilePath error:nil];
            
            if (smallfileList.count > 0) {
                
                // 下载中的类型1
                filedowingDict[@"type"] = @"3";
                filedowingDict[@"dowingFile"] = tempArray2;
                
                long long smalFilesize = 0;
                
                int number = 0;
                
                for (NSString *smallfileName in smallfileList) {
                    
                    if([smallfileName rangeOfString:@".DS_Store"].location !=NSNotFound) continue;
                    
                    number++;
                    
                    NSString *path = [smallFilePath stringByAppendingPathComponent:smallfileName];
                    
                    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
                    smalFilesize += [fileInfo[NSFileSize] longLongValue];
                }
                
                fileDic[NSFileSize] = [self fileSize:smalFilesize];
                filedowingDict[@"number"] = [NSString stringWithFormat:@"%d",number];
            }else{
                
                // 下载中的类型1
                filedowingDict[@"type"] = type;
                filedowingDict[@"dowingFile"] = tempArray2;
            }
            
            [filedowingArray addObject:filedowingDict];
        }else{
            
            // 添加
            [tempArray addObject:fileDic];
        
        }
    }
    
    NSLog(@"tempArray=%@",tempArray);
    
    if ([type isEqualToString:@"1"]) {
        
        // 下载中的类型1
        NSMutableDictionary *filedowingDict = [NSMutableDictionary new];
        filedowingDict[@"type"] = type;
        filedowingDict[@"dowingFile"] = tempArray;
        [filedowingArray addObject:filedowingDict];
        
    }
    
    return filedowingArray;
    
}


@end
