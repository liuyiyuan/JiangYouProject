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
#import "JYHomeBeautyPictureHeaderView.h"
#import "JYHomeBeautyPictureHotManager.h"
#import "JYHomeBeautyPictureTagManager.h"
@interface JYHomeBeautyPittureViewController ()<UITableViewDataSource,UITableViewDelegate,JYPictureHotDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JYHomeBeautyPictureHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *hotDataArray;//热门推荐数组

@property (nonatomic, strong) NSMutableArray *PictureTagArray;//标签介绍(固定三个)

@property (nonatomic, strong) NSString *tagId;//标签

@end

@implementation JYHomeBeautyPittureViewController
{
    NSInteger _page;
    
}
-(NSMutableArray *)PictureTagArray{
    if(!_PictureTagArray){
        _PictureTagArray = [[NSMutableArray alloc]init];
    }
    return _PictureTagArray;
}

-(NSMutableArray *)hotDataArray{
    if(!_hotDataArray){
        _hotDataArray = [[NSMutableArray alloc]init];
    }
    return _hotDataArray;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    self.tagId = @"124";
    [self loadNewData];
    [self getBeautyPictureHot];//热门推荐
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    static NSString *cellId = @"JYHomePictureTableViewCell";
    JYHomePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell){
        cell = [[JYHomePictureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.titleLabel.text = dict[@"title"];
    cell.imageUrl = dict[@"msgImg"];
    [cell.likeButton setTitle:[NSString stringWithFormat:@" %@",dict[@"likeCount"]] forState:UIControlStateNormal];
    [cell.unLikeButton setTitle:[NSString stringWithFormat:@" %@",dict[@"unLikeCount"]] forState:UIControlStateNormal];
    [cell.commentsButton setTitle:[NSString stringWithFormat:@" %@",dict[@"commentCount"]] forState:UIControlStateNormal];
    [cell.starButton setTitle:[NSString stringWithFormat:@" %@",dict[@"collectCount"]] forState:UIControlStateNormal];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.hotDataArray = self.hotDataArray;
    self.headerView.PictureTagArray = self.PictureTagArray;
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pixelValue(414);
}



#pragma mark - 新闻刷新
- (void)loadNewData{
    _page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    NSDictionary *param = @{@"userId":@"18",
                            @"tagId":self.tagId,
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
    NSDictionary *param = @{@"userId":@"18",
                            @"tagId":self.tagId,
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

#pragma mark - 获取热门推荐
-(void)getBeautyPictureHot{
    
    JYHomeBeautyPictureHotManager *beautyPictureHot = [[JYHomeBeautyPictureHotManager alloc] init];
    [beautyPictureHot loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.hotDataArray addObject:dic[@"msgImg"]];
        }
        
        [self getTag];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}


#pragma mark - 标签介绍
-(void)getTag{
    JYHomeBeautyPictureTagManager *PictureTag = [[JYHomeBeautyPictureTagManager alloc] init];
    [PictureTag loadDataWithParams:@{@"userId":@"18"} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.PictureTagArray addObject:dic];
        }
        
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}

#pragma mark - JYPictureHotDelegate
- (void)clickHotViewIndex:(NSIndexPath *)indexPath{
    
}
#pragma mark -  老照片
-(void)click_oldPictureTap{
    self.tagId = @"124";
    [self loadNewData];
}
#pragma mark -  大美江油
-(void)click_bigBeautyJyTap{
    self.tagId = @"125";
    [self loadNewData];
}
#pragma mark -  随手拍
-(void)click_BTWTap{
    self.tagId = @"126";
    [self loadNewData];
}


-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,self.view.frame.size.height) style:UITableViewStyleGrouped];
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

-(JYHomeBeautyPictureHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeBeautyPictureHeaderView alloc]init];
        //老照片
        UITapGestureRecognizer *oldPictureTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click_oldPictureTap)];
        [_headerView.oldPicture addGestureRecognizer:oldPictureTap];
        //大美江油
        UITapGestureRecognizer *bigBeautyJyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click_bigBeautyJyTap)];
        [_headerView.bigBeautyJy addGestureRecognizer:bigBeautyJyTap];
        //随手拍
        UITapGestureRecognizer *BTWTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click_BTWTap)];
        [_headerView.BTW addGestureRecognizer:BTWTap];
    }
    return _headerView;
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
