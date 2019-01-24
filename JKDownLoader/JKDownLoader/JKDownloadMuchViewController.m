//
//  JKDownloadMuchViewController.m
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/23.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKDownloadMuchViewController.h"

#import "JKDownloaderManger.h"
@interface JKDownloadMuchViewController ()

@property(nonatomic,strong) NSURL *url;

@end

@implementation JKDownloadMuchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 100, 40)];
    [buttton1 setTitle:@"开始下载1" forState:UIControlStateNormal];
    [buttton1 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton1 setBackgroundColor:[UIColor yellowColor]];
    [buttton1 addTarget:self action:@selector(startLoadTask1) forControlEvents:UIControlEventTouchUpInside];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton1];
    
    UIButton *buttton12 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttton1.frame)+20, 150, 100, 40)];
    [buttton12 setTitle:@"开始下载2" forState:UIControlStateNormal];
    [buttton12 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton12 setBackgroundColor:[UIColor yellowColor]];
    [buttton12 addTarget:self action:@selector(startLoadTask2) forControlEvents:UIControlEventTouchUpInside];
    buttton12.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton12];
    
    UIButton *buttton13 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttton12.frame)+20, 150, 100, 40)];
    [buttton13 setTitle:@"开始下载3" forState:UIControlStateNormal];
    [buttton13 setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttton13 setBackgroundColor:[UIColor yellowColor]];
    [buttton13 addTarget:self action:@selector(startLoadTask3) forControlEvents:UIControlEventTouchUpInside];
    buttton13.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:buttton13];
    
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
-(void)startLoadTask:(NSURL *)url{
    
    
    [[JKDownloaderManger shareDownloaderManger] jk_downloadWithUrl:url withDownProgress:^(float progress) {
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
    
    [[JKDownloaderManger shareDownloaderManger]pauseloadWithUrl:self.url];
}

#pragma mark 继续下载
-(void)resumeLoadTask{
    
    
    
    
}

#pragma mark 开始下载
-(void)startLoadTask1{
    
    NSString *urlStr = @"http://localhost/专家演讲4.mp4";
    // iOS9 之后取代上面的 api
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    self.url = url;
    
    [self startLoadTask:url];
    
}

-(void)startLoadTask2{

    NSString *urlStr = @"http://localhost/专家演讲2.mp4";
    
    // iOS9 之后取代上面的 api
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    self.url = url;

    [self startLoadTask:url];
}

-(void)startLoadTask3{
    
    NSString *urlStr = @"http://localhost/专家演讲3.mp4";
    
    // iOS9 之后取代上面的 api
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    self.url = url;
    [self startLoadTask:url];
}

@end

