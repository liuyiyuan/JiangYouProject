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
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
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
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    static NSString *cellId = @"JYHomeVideoTableViewCell";
    JYHomeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell){
        cell = [[JYHomeVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"msgImg"]] placeholderImage:nil];
    cell.fromButton.titleLabel.text = dict[@"whereFrom"];
    cell.playButton.tag = indexPath.row;
    [cell.playButton addTarget:self action:@selector(click_playButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
                            @"tagId":@121,
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


-(void)click_playButton :(UIButton *)button{
    NSDictionary *dict = self.dataArray[button.tag];
    NSString *urlString = dict[@"shareUrl"];
    AVPlayerViewController *play = [[AVPlayerViewController alloc] init];
    
    play.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    // 是否显示视频播放控制控件默认YES
    play.showsPlaybackControls = YES;
    
    // 设置视频播放界面的尺寸播放选项
    // AVLayerVideoGravityResizeAspect   默认 不进行比例缩放 以宽高中长的一边充满为基准
    // AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
    // AVLayerVideoGravityResize     进行缩放充满屏幕
    play.videoGravity = @"AVLayerVideoGravityResizeAspect";
    
    // 获取是否已经准备好开始播放
    //    play.isReadyForDisplay
    
    // 获取视频播放界面的尺寸
    //    play.videoBounds
    
    // 视频播放器的视图 自定义的控件可以添加在其上
    //    play.contentOverlayView
    
    // 画中画代理iOS9后可用
//    play.delegate = self;
    
    // 是否支持画中画 默认YES
//    play.allowsPictureInPicturePlayback = YES;
    
    
    //    [play.player play];
    
    [self presentViewController:play animated:YES completion:nil];

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
