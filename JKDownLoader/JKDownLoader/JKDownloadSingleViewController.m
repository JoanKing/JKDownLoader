//
//  JKDownloadSingleViewController.m
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKDownloadSingleViewController.h"

#import "JKDownLoader.h"
@interface JKDownloadSingleViewController ()

@property(nonatomic,strong) JKDownLoader *downLoader;

@end

@implementation JKDownloadSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 100, 40)];
    [buttton1 setTitle:@"开始下载" forState:UIControlStateNormal];
    [buttton1 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton1 setBackgroundColor:[UIColor yellowColor]];
    [buttton1 addTarget:self action:@selector(startLoadTask) forControlEvents:UIControlEventTouchUpInside];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton1];
    
    UIButton *buttton2 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton1.frame)+20, 100, 40)];
    [buttton2 setTitle:@"暂停下载" forState:UIControlStateNormal];
    [buttton2 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton2 setBackgroundColor:[UIColor yellowColor]];
    [buttton2 addTarget:self action:@selector(pauseLoadTask) forControlEvents:UIControlEventTouchUpInside];
    buttton2.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton2];
    
    UIButton *buttton3 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttton2.frame)+20, 100, 40)];
    [buttton3 setTitle:@"继续下载" forState:UIControlStateNormal];
    [buttton3 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton3 setBackgroundColor:[UIColor yellowColor]];
    [buttton3 addTarget:self action:@selector(resumeLoadTask) forControlEvents:UIControlEventTouchUpInside];
    buttton3.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton3];
}


#pragma mark 开始下载
-(void)startLoadTask{
    
    NSLog(@"开始下载");
    self.downLoader = [[JKDownLoader alloc]init];
    // [downLoader jk_downloadWithUrl:[NSURL URLWithString:@"http://play.ciotimes.com/DJT55.mp4"]];
    [self.downLoader jk_downloadWithUrl:[NSURL URLWithString:@"http://play.ciotimes.com/DJT55.mp4"] withDownProgress:^(float progress) {
        // 下载进度
        NSLog(@"下载进度= %f",progress);
        
    } completion:^(NSString * _Nonnull downFilePath) {
        // 下载成功
        NSLog(@"下载成功的路径= %@",downFilePath);
        
    } fail:^(NSString * _Nonnull error) {
        // 下载出错
        NSLog(@"下载出错的信息= %@",error);
        
    }];
    
}

#pragma mark 暂停下载
-(void)pauseLoadTask{
    
    NSLog(@"暂停下载");
    [self.downLoader pause];
    
}

#pragma mark 继续下载
-(void)resumeLoadTask{
    
    NSLog(@"继续下载");
    
    NSURL *url =  [NSURL URLWithString:@"http://play.ciotimes.com/DJT55.mp4"];
    
    NSLog(@"path= %@",url.path);
}



@end
