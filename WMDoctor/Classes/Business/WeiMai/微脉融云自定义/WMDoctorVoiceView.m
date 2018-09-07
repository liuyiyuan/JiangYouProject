//
//  WMDoctorVoiceView.m
//  WMDoctor
//
//  Created by xugq on 2017/10/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorVoiceView.h"
#import "WMDoctorVoiceCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MZTimerLabel.h>
#import "WMListeningNotesAPIManager.h"
#import "WMRCUserInfoEntitys+CoreDataClass.h"
#import "WMDoctorVoiceAPIManager.h"
#import "WMRCDataManager.h"
#import "WMTabBarController.h"
#import "WMNavgationController.h"

@interface WMDoctorVoiceView()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageNum;
    BOOL _isDoctor;
}

@property (nonatomic, strong)UITableView *doctorVoiceTableView;
@property (nonatomic, strong)UIButton *haveIntroduced;
@property (nonatomic, strong)NSMutableArray *doctorVoices;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, assign)long lastIndex;
@property (nonatomic, strong) MZTimerLabel *timerLabel;

@end

@implementation WMDoctorVoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NSNotificationForTheRoleType:) name:@"DoctorVoiceChangeFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickChatBtn:) name:@"ClickChatBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublishDoctorVoice:) name:@"PublishDoctorVoice" object:nil];
    _isDoctor = YES;
    return self;
}

- (void)setupDoctorVoiceView{
    self.doctorVoices = [NSMutableArray new];
    _pageNum = 1;
    [self setupTableView];
//    [self loadDoctorVoiceData];
}

- (void)setupTableView{
    self.doctorVoiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 47) style:UITableViewStylePlain];
    self.doctorVoiceTableView.delegate = self;
    self.doctorVoiceTableView.dataSource = self;
    self.doctorVoiceTableView.showsVerticalScrollIndicator = NO;
    self.doctorVoiceTableView.separatorColor = [UIColor clearColor];
    self.doctorVoiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.doctorVoiceTableView.backgroundColor = [UIColor colorWithHexString:@"F3F5F9"];
    [self addSubview:self.doctorVoiceTableView];
    [self.doctorVoiceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMDoctorVoiceCell class]) bundle:nil] forCellReuseIdentifier:@"WMDoctorVoiceCell"];
    self.doctorVoiceTableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadDoctorVoiceData];
    }];
//    self.doctorVoiceTableView.mj_footer = [MJWeiMaiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDoctorVoiceData)];
    self.doctorVoiceTableView.mj_footer = footer;
    [self.doctorVoiceTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0,*)) {
        self.doctorVoiceTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.doctorVoiceTableView.contentInset = UIEdgeInsetsMake(0, 0, 47, 0);
        self.doctorVoiceTableView.scrollIndicatorInsets = self.doctorVoiceTableView.contentInset;
        
        self.doctorVoiceTableView.estimatedRowHeight = 0;
        self.doctorVoiceTableView.estimatedSectionHeaderHeight = 0;
        self.doctorVoiceTableView.estimatedSectionFooterHeight = 0;
        
    }else{
//        self.superviewcontroller.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    self.haveIntroduced = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.haveIntroduced.frame = CGRectMake(0, self.frame.size.height - 47, kScreen_width, 47);
    [self.haveIntroduced setImage:[UIImage imageNamed:@"soundRecording"] forState:UIControlStateNormal];
    [self.haveIntroduced setTitle:@"  发布今日医声" forState:UIControlStateNormal];
    [self.haveIntroduced setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.haveIntroduced.titleLabel.font = [UIFont systemFontOfSize:18];
    self.haveIntroduced.backgroundColor = [UIColor colorWithHexString:@"18A2FF"];
    [self.haveIntroduced addTarget:self action:@selector(haveIntroducedClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.haveIntroduced];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.doctorVoices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMDoctorVoiceModel *doctorVoice = self.doctorVoices[indexPath.row];
    
    CGFloat height = [CommonUtil heightForLabelWithText:doctorVoice.title width:kScreen_width - 30 font:[UIFont systemFontOfSize:16]];
    if (height>22) {
        return  164.f;
    }
    return 142.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMDoctorVoiceModel *doctorVoice = self.doctorVoices[indexPath.row];
    WMDoctorVoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMDoctorVoiceCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.playBtn.tag = indexPath.row;
    [cell.playBtn addTarget:self action:@selector(playBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setupValueWithModel:doctorVoice];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)playBtnClickAction:(UIButton *)button{
    
    WMDoctorVoiceModel *doctorVoice = self.doctorVoices[button.tag];
    NSURL * url  = [NSURL URLWithString:doctorVoice.soundFileIndex];
    NSIndexPath *index = [NSIndexPath indexPathForRow:button.tag inSection:0];
    WMDoctorVoiceCell *cell = [self.doctorVoiceTableView cellForRowAtIndexPath:index];
    [self.timerLabel setCountDownTime:[doctorVoice.timeLength intValue]];
    self.timerLabel.timeLabel = cell.voiceInLength;
    if (button.tag != self.lastIndex) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        _player = nil;
        self.lastIndex = button.tag;
    }
    if (_player == nil) {
        //点击一个新的
        [_timerLabel reset];
        [_timerLabel pause];
        AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:url];
        _player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [self addObserverToPlayerItem:_player.currentItem];
        [_player setVolume:100];
        [_player play];
        WMListeningNotesAPIManager *listeningNotesAPIManager = [[WMListeningNotesAPIManager alloc] init];
        RCUserInfo *userInfo = [WMRCUserInfoEntitys getPatientEntity:[RCIM sharedRCIM].currentUserInfo.userId];
        NSString *tempUserType = @"1";
        if (!stringIsEmpty(userInfo.type)) {
            tempUserType = userInfo.type;
        }
        NSDictionary *param = @{
                                @"numberType" : tempUserType,
                                @"soundId" : doctorVoice.soundId,
                                @"userId" : [RCIM sharedRCIM].currentUserInfo.userId
                                };
        [listeningNotesAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"收听记录 = %@", responseObject);
            if ([[responseObject allKeys] containsObject:@"listenedNum"]) {
                doctorVoice.listenedNum = [responseObject objectForKey:@"listenedNum"];
                [self.doctorVoiceTableView reloadData];
            }
        } withFailure:^(ResponseResult *errorResult) {
            NSLog(@"收听记录error = %@", errorResult);
        }];
    } else{
        //和上一次点击的是一个
        if (_player.rate == 1.0) {
            //正在播放中暂停
            [_player pause];
            [_timerLabel pause];
        } else if(_player.rate == 0){
            //重新播放
            [_player play];
            [_timerLabel start];
        }
    }
    
    if ([[UIDevice currentDevice] systemVersion].intValue >= 10) {
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    NSLog(@"播放器状态： = %lu", playerItem.status);
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            [_timerLabel start];
        } else if (status == AVPlayerStatusFailed){
            RCNetworkStatus connectStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
            if (connectStatus == RC_NotReachable) {
                [WMHUDUntil showMessage:@"貌似与互联网失去连接" toView:self];
            } else{
                [WMHUDUntil showMessage:@"播放失败" toView:self];
            }
            [self.player.currentItem removeObserver:self forKeyPath:@"status"];
            [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _player = nil;
            [_timerLabel reset];
            [_timerLabel pause];
        }
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}

//mp3文件读取完毕
- (void)playerItemDidPlayToEnd:(NSNotification *)noti{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _player = nil;
}

//发布今日医声
- (void)haveIntroducedClickAction:(UIButton *)button{
    
    
}

//加载今日医声数据
- (void)loadDoctorVoiceData{
    WMDoctorVoiceAPIManager *doctorVoiceAPIManager = [[WMDoctorVoiceAPIManager alloc] init];
    NSDictionary *param = @{
                            @"groupId" : self.targetId,
                            @"pageNum" : [NSString stringWithFormat:@"%ld", _pageNum],
                            @"pageSize" : @"20"
                            };
    [doctorVoiceAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (_pageNum == 1) {
            [self.doctorVoices removeAllObjects];
        }
        _pageNum += 1;
        NSArray *list = [responseObject objectForKey:@"list"];
        for (NSDictionary *dic in list) {
            WMDoctorVoiceModel *doctorVoice = [[WMDoctorVoiceModel alloc] initWithDictionary:dic error:nil];
            [self.doctorVoices addObject:doctorVoice];
        }
        if (self.doctorVoices.count == 0) {
            if (_isDoctor) {
                [self.doctorVoiceTableView showListEmptyView:@"doctorVoice"];
            } else{
                [self.doctorVoiceTableView showListEmptyView:@"doctorVoiceAssistant" title:@"暂无医声" buttonTitle:nil completion:^(UIButton *button) {}];
            }
        } else{
            [self.doctorVoiceTableView removeListEmptyViewForNeedToChangeSeparator:YES];
            [self.doctorVoiceTableView reloadData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([self.doctorVoiceTableView.mj_header isRefreshing]) {
                [self.doctorVoiceTableView.mj_header endRefreshing];
            }
            if ([self.doctorVoiceTableView.mj_footer isRefreshing]) {
                [self.doctorVoiceTableView.mj_footer endRefreshing];
            }
        });
    } withFailure:^(ResponseResult *errorResult) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([self.doctorVoiceTableView.mj_header isRefreshing]) {
                [self.doctorVoiceTableView.mj_header endRefreshing];
            }
            if ([self.doctorVoiceTableView.mj_footer isRefreshing]) {
                [self.doctorVoiceTableView.mj_footer endRefreshing];
            }
        });
    }];
}

- (void)headerRefresh{
    _pageNum = 1;
    [self loadDoctorVoiceData];
}

- (MZTimerLabel *)timerLabel{
    __weak typeof(self) weakself = self;
    if (!_timerLabel) {
        _timerLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        _timerLabel.timeFormat = @"m:ss";
        [_timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
            [weakself.timerLabel reset];
        }];
    }
    return _timerLabel;
}

//获取到角色类型的通知
- (void)NSNotificationForTheRoleType:(NSNotification*)sender{
    self.doctorVoiceTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.haveIntroduced.hidden = YES;
    if (self.doctorVoices.count == 0) {
        [self.doctorVoiceTableView showListEmptyView:@"doctorVoiceAssistant" title:@"暂无医声" buttonTitle:nil completion:^(UIButton *button) {}];
    } else{
        [self.doctorVoiceTableView removeListEmptyViewForNeedToChangeSeparator:YES];
    }
    _isDoctor = NO;
}

//点击头部tab聊天通知
- (void)clickChatBtn:(NSNotification *)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _player = nil;
    [_timerLabel setStopWatchTime:0];
}

//发布今日医生后返回通知
- (void)PublishDoctorVoice:(NSNotification *)sender{
    [self headerRefresh];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClickChatBtn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DoctorVoiceChangeFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PublishDoctorVoice" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
