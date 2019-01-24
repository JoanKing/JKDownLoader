//
//  JKVideoListsViewController.m
//  JKDownLoader
//
//  Created by 王冲 on 2019/1/24.
//  Copyright © 2019年 JK科技有限公司. All rights reserved.
//

#import "JKVideoListsViewController.h"
#import "JKDown.h"
@interface JKVideoListsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation JKVideoListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"资源列表";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.dataArray addObjectsFromArray:@[@"专家讲座",@"俄罗斯舞蹈"]];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、 %@",indexPath.row,self.dataArray[indexPath.row]];
    cell.backgroundColor = JKRandomColor;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+JKstatusBarHeight, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT-44-JKstatusBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            // 小于11.0的不做操作
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    return _tableView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cell_name = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];

    if ([cell_name isEqualToString:@"专家讲座"]) {
        
    }else if ([cell_name isEqualToString:@"俄罗斯舞蹈"]){
       
    }
}

@end
