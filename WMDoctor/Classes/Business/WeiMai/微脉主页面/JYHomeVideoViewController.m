//
//  JYHomeVideoViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeVideoViewController.h"
#import "JYHomeVideoHeaderView.h"
#import "JYHomeVideoManager.h"
#import "JYHomeVideoTableViewCell.h"
#import "JYHomeVideoLunBoManager.h"
@interface JYHomeVideoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JYHomeVideoHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@end

@implementation JYHomeVideoViewController
{
    NSInteger _page;
    NSDictionary *_userDict;
}

-(NSMutableArray *)imageUrls{
    if(!_imageUrls){
        _imageUrls = [[NSMutableArray alloc]init];
    }
    return _imageUrls;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"JYLoginUserInfo"];
    [self loadNewData];
    [self getVideoLunBo];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
    [self.view addSubview:self.tableView];
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dict = self.dataArray[indexPath.row];
    static NSString *cellId = @"JYHomeVideoTableViewCell";
    JYHomeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[JYHomeVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.imageUrls = self.imageUrls;
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pixelValue(500);
}


#pragma mark - 获取视频列表
- (void)loadNewData{
    _page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    NSDictionary *param = @{@"userId":@"18",
                            @"tagId":@322,
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    JYHomeVideoManager *video = [[JYHomeVideoManager alloc] init];
    [video loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.dataArray addObject:dic];
        }
        
        _page++;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

#pragma mark - Refresh
- (void)loadMoreData{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    NSDictionary *param = @{@"userId":_userDict[@"userId"],
                            @"tagId":@322,
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    
    JYHomeVideoManager *video = [[JYHomeVideoManager alloc] init];
    [video loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.dataArray addObject:dic];
        }
        _page++;
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }
    }];
    
    
}


-(void)getVideoLunBo{
    JYHomeVideoLunBoManager *videoLunBo = [[JYHomeVideoLunBoManager alloc] init];
    [videoLunBo loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.imageUrls addObject:dic[@"msgImg"]];
        }
        
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}


-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        //        _tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH,self.view.frame.size.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = pixelValue(380);
        _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        __weak typeof(self) weakSelf = self;
        MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
            
        }];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

-(JYHomeVideoHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeVideoHeaderView alloc]init];
        
    }
    return _headerView;
}

@end
