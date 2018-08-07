//
//  JYNewsViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPittureViewController.h"
#import "UIViewController+ZJScrollPageController.h"
#import "JYHomePictureTableViewCell.h"//美图cell
#import "JYHomeBeautyPictureLIstManager.h"//美图接口
@interface JYHomeBeautyPittureViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JYHomeBeautyPittureViewController
{
    NSInteger _page;
}
-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {

    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    static NSString *cellId = @"JYHomePictureTableViewCell";
    JYHomePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[JYHomePictureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.titleLabel.text = dict[@"title"];
    cell.myImageView.image = [UIImage imageNamed:@"news_placed"];
    return cell;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH,self.view.frame.size.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

#pragma mark - 新闻刷新
- (void)loadNewData{
    _page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    NSDictionary *param = @{@"userId":@"1",
                            @"tagId":@"3",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    JYHomeBeautyPictureLIstManager *beautyPictureLIs = [[JYHomeBeautyPictureLIstManager alloc] init];
    [beautyPictureLIs loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
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
    NSDictionary *param = @{@"userId":@"1",
                            @"tagId":@"3",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    
    JYHomeBeautyPictureLIstManager *beautyPictureLIs = [[JYHomeBeautyPictureLIstManager alloc] init];
    [beautyPictureLIs loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
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
                                  
// 使用系统的生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear------%ld", self.zj_currentIndex);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-----%ld", self.zj_currentIndex);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-----%ld", self.zj_currentIndex);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear--------%ld", self.zj_currentIndex);
    
}

@end
