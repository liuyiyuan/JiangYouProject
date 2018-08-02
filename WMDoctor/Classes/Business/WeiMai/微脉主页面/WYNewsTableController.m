//
//  WYNewsTableController.m
//  WYNews
//
//  Created by dai.fengyi on 15/5/27.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "WYNewsTableController.h"
#import "MJRefresh.h"
#import "WYNetwork.h"
#import "WYNews.h"
#import "WYDefaultNewsCell.h"
#import "WYImagesNewsCell.h"
#import "WYWideImageNewsCell.h"
#import "WYNewsDetailVC.h"
#import "JYHomeNewAPIManager.h"
#import "JYHomeFocusTableViewCell.h"
//#import "WYtool.h"
@interface WYNewsTableController ()<UIScrollViewDelegate>

@end
//typedef enum {
//    DefaultNews,
//    ImagesNews,
//    Advertisement,
//} NewsStyle;
@implementation WYNewsTableController
{
    NSMutableArray *_dataArray;
    NSInteger _page;
    MJRefreshHeader *_header;
    MJRefreshFooter *_footer;
}
/*
 DefaultNews,
 ImagesNews,
 Advertisement,
 */
//static NSString *reuseDefaultNewsIdentifier = @"DefaultNews";
//static NSString *reuseImagesNewsIdentifier = @"ImagesNews";
//static NSString *reuseAdvertisementIdentifier = @"Advertisement";
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    //    self.tableView.preservesSuperviewLayoutMargins = NO;
    //    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = pixelValue(380);
    self.tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer = footer;
//    _header = [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    _footer = [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)setTid:(NSString *)tid
{
    _tid = tid;
}
#pragma mark - Refresh
- (void)loadMoreData
{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    
    NSDictionary *param = @{
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    
    JYHomeNewAPIManager *homeNewsManager = [[JYHomeNewAPIManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login success data : %@", responseObject);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in [responseObject allObjects]) {
            //            WYNews *news = [[WYNews alloc] initWithDic:dic];
            [_dataArray addObject:dic];
        }
        _page++;
        [_footer endRefreshing];
        [self.tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
        [_footer endRefreshing];
    }];
    
//    //    if (_footer.state == MJRefreshFooterStateIdle) {
//    NSLog(@"loadmoreData");
//    NSMutableString *url = [NSMutableString stringWithString:kWYNetWorkNewsListBaseStr];
//    [url appendFormat:@"/%@/%ld-%d.html", _tid, kWYNetWorkNewsListFetchOnceCount * _page, kWYNetWorkNewsListFetchOnceCount];
//    [[WYNetwork sharedWYNetwork] HttpGetNews:url success:^(id responseObject) {
//        //            NSLog(@"abc");
//        if (![responseObject isKindOfClass:[NSDictionary class]]) {
//            return;
//        }
//        if (![[responseObject allObjects] isKindOfClass:[NSArray class]]) {
//            return;
//        }
//        for (NSDictionary *dic in [[responseObject allObjects] lastObject]) {
//            WYNews *news = [[WYNews alloc] initWithDic:dic];
//            [_dataArray addObject:news];
//        }
//        _page++;
//        [_footer endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"\nerror is %@", [error localizedDescription]);
//        [_footer endRefreshing];
//    }];
//    //    }else [_footer endRefreshing];
}



#pragma mark - 新闻刷新
- (void)loadNewData
{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)_page];
    
    NSDictionary *param = @{@"searchKey":@"",
                            @"userId":@"-1",
                            @"pageNo":pageString,
                            @"pageSize":@"15"
                            };
    
    JYHomeNewAPIManager *homeNewsManager = [[JYHomeNewAPIManager alloc] init];
    [homeNewsManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login success data : %@", responseObject);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in [responseObject allObjects]) {
//            WYNews *news = [[WYNews alloc] initWithDic:dic];
            [_dataArray addObject:dic];
        }
        _page = 1;
        [_header endRefreshing];
        [self.tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
        [_header endRefreshing];
    }];
    
    
    
    //    if (_header.state == MJRefreshHeaderStateIdle) {
//    NSMutableString *url = [NSMutableString stringWithString:kWYNetWorkNewsListBaseStr];
//    [url appendFormat:@"/%@/%d-%d.html", _tid, 0, kWYNetWorkNewsListFetchOnceCount];
//    [[WYNetwork sharedWYNetwork] HttpGetNews:url success:^(id responseObject) {
//        //            NSLog(@"abc");
//        if (![responseObject isKindOfClass:[NSDictionary class]]) {
//            return;
//        }
//        if (![[responseObject allObjects] isKindOfClass:[NSArray class]]) {
//            return;
//        }
//        [_dataArray removeAllObjects];
//        for (NSDictionary *dic in [[responseObject allObjects] lastObject]) {
//            WYNews *news = [[WYNews alloc] initWithDic:dic];
//            [_dataArray addObject:news];
//        }
//        _page = 1;
//        [_header endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"\nerror is %@", [error localizedDescription]);
//        [_header endRefreshing];
//    }];
    //    }else [_header endRefreshing];
}

#pragma mark - ScrollView Delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //在最低部时，contentOffset.y = contentSize.height - scrollView.bounds.size.height
//    NSLog(@"did end dragging %f", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height - 250) {
//        [self loadMoreData];
//    }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //在最低部时，contentOffset.y = contentSize.height - scrollView.bounds.size.height
//    NSLog(@"did end dragging %f", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height - 250) {
//        [self loadMoreData];
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"\ndid scroll contentoffset.y %f, contentsize.height %f", scrollView.contentOffset.y, scrollView.contentSize.height);
//}
#pragma mark - Table view data source
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WYNews *news = _dataArray[indexPath.row];
//    if (news.imgextra) {
//        return 118;
//    }else if (news.imgType) {
//        return 178;
//    }
//    return 80;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataArray ?  _dataArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *reuseIdentifier;
//    WYNews *news = (WYNews *)_dataArray[indexPath.row];
//    if (news.imgextra) {
//        reuseIdentifier = @"ImagesNews";
//    }else if (news.imgType) {
//        reuseIdentifier = @"WideImageNews";
//    }else {
//        reuseIdentifier = @"DefaultNews";
//    }
//    //    NSClassFromString([NSString stringWithFormat:@"WY%@Cell", reuseIdentifier]);
//    WYBaseNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (cell == nil) {
//        cell = [NSClassFromString([NSString stringWithFormat:@"WY%@Cell", reuseIdentifier]) cell];
//    }
//    // Configure the cell...
//    cell.news = news;
//    //    cell.textLabel.text = news.title;
    NSDictionary *dict = _dataArray[indexPath.row];
    static NSString *cellId = @"JYHomeFocusTableViewCell";
    JYHomeFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[JYHomeFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.contentLabel.text = dict[@"content"];
    cell.timeLabel.text = [self timeWithTimeIntervalString:dict[@"createTime"]];
    [cell.likedButton setTitle:[NSString stringWithFormat:@" 转帖%@次",dict[@"likeCount"]] forState:UIControlStateNormal];
    [cell.forwardingButton setTitle:[NSString stringWithFormat:@" 热评%@条",dict[@"turnCount"]] forState:UIControlStateNormal];
    [cell.commentsButton setTitle:[NSString stringWithFormat:@" 赞%@次",dict[@"commentCount"]] forState:UIControlStateNormal];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    WYNewsDetailVC *vc = [[WYNewsDetailVC alloc] init];
    //    WYNews *news = _dataArray[indexPath.row];
    //    vc.docid = news.docid;
    //    vc.news = news;
    //    [self.navigationController pushViewController:vc animated:YES];
//    [WYTool showMsg:@"why I can't get in?"];
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

@end
