//
//  JKDownloadFileListViewController.m
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKDownloadFileListViewController.h"
#import "UIImage+JKScaleVideoImage.h"
#import "JKFilePathOperationExtension.h"
#import "JKFilePathExtension.h"
@interface JKDownloadFileListViewController ()
{
    UIImageView *imageView;
}
@end

@implementation JKDownloadFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",[JKFilePathOperationExtension jKHomeDirectory]);
    
    UIButton *buttton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 150, 40)];
    [buttton1 setTitle:@"获取文件夹信息1" forState:UIControlStateNormal];
    [buttton1 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton1 setBackgroundColor:[UIColor yellowColor]];
    [buttton1 addTarget:self action:@selector(selectInfo1) forControlEvents:UIControlEventTouchUpInside];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton1];
    
    UIButton *buttton2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton1.frame)+50, 150, 40)];
    [buttton2 setTitle:@"获取文件夹信息2" forState:UIControlStateNormal];
    [buttton2 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton2 setBackgroundColor:[UIColor yellowColor]];
    [buttton2 addTarget:self action:@selector(selectInfo2) forControlEvents:UIControlEventTouchUpInside];
    buttton2.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton2];
    
    UIButton *buttton3 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton2.frame)+50, 150, 40)];
    [buttton3 setTitle:@"获取文件夹信息3" forState:UIControlStateNormal];
    [buttton3 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton3 setBackgroundColor:[UIColor yellowColor]];
    [buttton3 addTarget:self action:@selector(selectInfo3) forControlEvents:UIControlEventTouchUpInside];
    buttton3.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton3];
    
    UIButton *buttton4 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton3.frame)+50, 150, 40)];
    [buttton4 setTitle:@"创建目录" forState:UIControlStateNormal];
    [buttton4 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton4 setBackgroundColor:[UIColor yellowColor]];
    [buttton4 addTarget:self action:@selector(selectInfo4) forControlEvents:UIControlEventTouchUpInside];
    buttton4.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton4];
    
    UIButton *buttton5 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton4.frame)+50, 150, 40)];
    [buttton5 setTitle:@"获取文件夹信息5" forState:UIControlStateNormal];
    [buttton5 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton5 setBackgroundColor:[UIColor yellowColor]];
    [buttton5 addTarget:self action:@selector(selectInfo5) forControlEvents:UIControlEventTouchUpInside];
    buttton5.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton5];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height-150, 100, 100)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
}

#pragma mark 开始下载
-(void)selectInfo1{
    

    NSString *filePath1 = [[JKFilePathOperationExtension jKDocuments]stringByAppendingPathComponent:@"JKDone"];
    NSString *filePath2 = [[JKFilePathOperationExtension jKDocuments]stringByAppendingPathComponent:@"JKDowning"];

    NSArray *array = [JKFilePathExtension jk_testcheckJKDonePath:filePath1 withDowningPath:filePath2 isascending:YES];
    
    // NSLog(@"数量2=%ld \n array2=%@",array.count,array);
    
    for (NSDictionary *dict1 in array) {
        
        NSString *type = dict1[@"type"];
        NSArray *fileArray = dict1[@"dowingFile"];
        
        if ([type isEqualToString:@"3"]) {
            
            NSLog(@"类型=%@ 数组个数=%ld 小数组的个数=%@",type,fileArray.count,dict1[@"number"]);
        }else{
            
            NSLog(@"类型=%@ 数组个数=%ld",type,fileArray.count);
        }
        
        for (NSDictionary *dict2 in fileArray) {
            
            NSString *file_name = dict2[@"Name"];
            NSString *sizeStr = dict2[@"NSFileSize"];
            NSLog(@"文件的名字=%@ 文件的大小=%@",file_name,sizeStr);
            
        }
    }
    
    
}

#pragma mark 开始下载
-(void)selectInfo2{
    
    NSLog(@"selectInfo1");
    NSString *filePath2 = [JKFilePathOperationExtension jKDocuments];
    NSArray *array = [[JKFilePathOperationExtension new] jKShallowSearchAllFiles:filePath2];
    
    NSLog(@"数量2=%ld \n array2=%@",array.count,array);
    
}

-(void)selectInfo3{
    
    NSString *filePath1 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JK视频列表/DJT55.mp4"];
    NSString *filePath2 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JK视频列表/DJT56.mp4"];
    NSDictionary *dictionary1 = [JKFilePathOperationExtension jKGetFileAttributesFilePath:filePath1];
    NSDictionary *dictionary2 = [JKFilePathOperationExtension jKGetFileAttributesFilePath:filePath2];
    
    // NSLog(@"数量3=%ld\narray3=%@",array.count,array);
    NSLog(@"\n不完整文件的信息=%@ \n 完整文件的信息=%@",dictionary2,dictionary1);
}

-(void)selectInfo4{
//
//    NSString *filePath1 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JKDone"];
//    [JKFilePathOperationExtension jk_createFolder:filePath1];
//
//    NSString *filePath2 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JKDowning"];
//    [JKFilePathOperationExtension jk_createFolder:filePath2];
//
//    NSArray *array1 = [[JKFilePathOperationExtension new] jKShallowSearchAllFiles:filePath1];
//    NSArray *array2 = [[JKFilePathOperationExtension new] jKShallowSearchAllFiles:filePath2];
//
//    NSLog(@"array1=%@\n数量4=%ld",array1,array1.count);
//    NSLog(@"array2=%@\n数量4=%ld",array2,array2.count);
//
    NSString *filePath3 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JKDone/专家演讲"];
    [JKFilePathOperationExtension jk_createFolder:filePath3];
    NSArray *array3 = [[JKFilePathOperationExtension new] jKShallowSearchAllFiles:filePath3];
    NSLog(@"array3=%@\n数量4=%ld",array3,array3.count);
    
    
    
}

-(void)selectInfo5{
    
    NSString *filePath4 = [[JKFilePathOperationExtension jKDocuments] stringByAppendingPathComponent:@"JK视频列表/DJT56.mp4"];
    
    //NSData *data = [[JKFilePathOperationExtension new]jKReadfile:filePath4];
    
    // imageView.image = [UIImage thumbnailImageForVideo:[NSURL fileURLWithPath:filePath4] atTime:1];
    imageView.image = [UIImage jk_videoThumbnailImageWithVideoUrl:[NSURL fileURLWithPath:filePath4] withVideoTime:1 withVideoImageMaxSize:CGSizeMake(200, 150)];
    
    
}


@end
