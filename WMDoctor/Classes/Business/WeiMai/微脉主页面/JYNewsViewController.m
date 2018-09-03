//
//  JYNewsViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYNewsViewController.h"
#import "UIViewController+ZJScrollPageController.h"
#import "JYHomeNewAPIManager.h"
#import "JYHomeFocusTableViewCell.h"
#import "JYHomeDeletedManager.h"//删除
#import "JYHomeCancleFocusManager.h"//取消关注
#import "JYHomeFocusManager.h"//关注
#import "JYHomeNewsHeaderView.h"
@interface JYNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYHomeNewsHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JYNewsViewController
{
    NSInteger _page;
    NSDictionary *_userDict;

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
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    _userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"JYLoginUserInfo"];
    [self loadNewData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.headerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return pixelValue(80);
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSArray *imageArray = dict[@"imgList"];
    NSString *cellId = [NSString stringWithFormat:@"JYHomeFocusTableViewCell%lu",(unsigned long)imageArray.count];
    JYHomeFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(!cell){
        cell = [[JYHomeFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dict = dict;
    //关注按钮
    cell.focusButton.tag = indexPath.row;
    BOOL isFollowed = [dict[@"isFollow"] boolValue];
    if(isFollowed){
        [cell.focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [cell.focusButton addTarget:self action:@selector(cancle_focusButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [cell.focusButton addTarget:self action:@selector(click_focusButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    //删除按钮
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(click_deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    //头像
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"imgPath"]]] placeholderImage:nil];
    //姓名
    cell.nameLabel.text = dict[@"title"];
    //内容详情
    cell.contentLabel.text = dict[@"content"];
    //时间
    cell.timeLabel.text = [self timeWithTimeIntervalString:dict[@"createTime"]];
    cell.readCountLabel.text = [NSString stringWithFormat:@"%@阅读",dict[@"readCount"]];
    
    [cell.likedButton setTitle:[NSString stringWithFormat:@" 赞%@次",dict[@"likeCount"]] forState:UIControlStateNormal];
    [cell.forwardingButton setTitle:[NSString stringWithFormat:@" 热评%@条",dict[@"turnCount"]] forState:UIControlStateNormal];
    [cell.commentsButton setTitle:[NSString stringWithFormat:@" 转帖%@次",dict[@"commentCount"]] forState:UIControlStateNormal];
    return cell;
}


#pragma mark - 新闻刷新
- (void)loadNewData{
    _page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    
    //    NSDictionary *param = @{@"searchKey":@"",
    //                            @"userId":_userDict[@"userId"] ? _userDict[@"userId"] : @"-1",
    //                            @"pageNo":pageString,
    //                            @"pageSize":@"15"
    //                            };
    NSDictionary *param = @{@"searchKey":@"",
                            @"userId":@"-1",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    JYHomeNewAPIManager *homeNewsManager = [[JYHomeNewAPIManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in [responseObject allObjects]) {
            //            WYNews *news = [[WYNews alloc] initWithDic:dic];
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
    
    //    NSDictionary *param = @{@"searchKey":@"",
    //                            @"userId":_userDict[@"userId"] ? _userDict[@"userId"] : @"-1",
    //                            @"pageNo":pageString,
    //                            @"pageSize":@"15"
    //                            };
    
    NSDictionary *param = @{@"searchKey":@"",
                            @"userId":@"-1",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    JYHomeNewAPIManager *homeNewsManager = [[JYHomeNewAPIManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login success data : %@", responseObject);
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


#pragma amrk - 删除按钮点击
-(void)click_deleteButton:(UIButton *)button{
    
    NSDictionary *dict = _dataArray[button.tag];
    NSDictionary *param = @{@"userId":_userDict[@"userId"],
                            @"followId":dict[@"id"]
                            };
    
    JYHomeDeletedManager *homeNewsManager = [[JYHomeDeletedManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        //删除数据源  刷新列表
        [_dataArray removeObjectAtIndex:button.tag];
        [self.tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}


#pragma mark - 关注按钮点击
-(void)click_focusButton:(UIButton *)button{
    NSDictionary *dict = _dataArray[button.tag];
    NSDictionary *param = @{@"userId":_userDict[@"userId"],
                            @"followId":dict[@"id"]
                            };
    
    JYHomeFocusManager *homeNewsManager = [[JYHomeFocusManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}

#pragma mark - 取消关注按钮点击
-(void)cancle_focusButton:(UIButton *)button{
    NSDictionary *dict = _dataArray[button.tag];
    NSDictionary *param = @{@"userId":_userDict[@"userId"],
                            @"followId":dict[@"id"]
                            };
    
    JYHomeCancleFocusManager *homeNewsManager = [[JYHomeCancleFocusManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}


#pragma mark - 时间戳转化为时间NSDate
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - 搜索按钮点击
-(void)click_searchButton{
    _page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    
    //    NSDictionary *param = @{@"searchKey":@"",
    //                            @"userId":_userDict[@"userId"] ? _userDict[@"userId"] : @"-1",
    //                            @"pageNo":pageString,
    //                            @"pageSize":@"15"
    //                            };
    NSDictionary *param = @{@"searchKey":self.headerView.textField.text ? self.headerView.textField.text : @"",
                            @"userId":@"-1",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    JYHomeNewAPIManager *homeNewsManager = [[JYHomeNewAPIManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in [responseObject allObjects]) {
            //            WYNews *news = [[WYNews alloc] initWithDic:dic];
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

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UI_SCREEN_WIDTH,self.view.frame.size.height - pixelValue(80));
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


-(JYHomeNewsHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeNewsHeaderView alloc]init];
        _headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(80));
        [_headerView.searchButton addTarget:self action:@selector(click_searchButton) forControlEvents:UIControlEventTouchUpInside];
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
