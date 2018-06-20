//
//  WMSystemMessageViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMSystemMessageViewController.h"
#import "WMSystemMessageCell.h"
#import "WMNotificationMessageViewController.h"
#import "WMTradeMessageViewController.h"
#import "WMRecommendNewViewController.h"
#import "WMMessageTypeAPIManager.h"
#import "WMMessageTypeModel.h"

@interface WMSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMSystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"微脉消息";
   
    [self setupView];
    [self setupData];
    [self loadDefaultData];
    [self clearMessagesUnreadStatus];
}
-(void)clearMessagesUnreadStatus{
    for (int i=0; i<self.systemTargetIdArr.count; i++) {
        NSString *targetId=self.systemTargetIdArr[i];
        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:targetId];
    }
}

-(void)setupView{
     self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, kScreen_width, kScreen_height);
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDefaultData];
}
-(void)setupData{
    
    self.dataSource=[[NSMutableArray alloc]initWithCapacity:0];
    
}
-(void)loadDefaultData{
    
    WMMessageTypeAPIManager *messageTypeAPIManager=[[WMMessageTypeAPIManager alloc]init];
    [messageTypeAPIManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMMessageTypeModel *messageTypeModel=(WMMessageTypeModel *)responseObject;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:messageTypeModel.messageType];
        if (self.dataSource.count==0) {
            [_tableView showBackgroundView:@"暂无数据" type:BackgroundTypeEmpty];
        }
        else{
            _tableView.backgroundView = nil;
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            
            [_tableView.mj_header endRefreshing];
            
        }

        [_tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
        
        if ([_tableView.mj_header isRefreshing]) {
            
            [_tableView.mj_header endRefreshing];
            
        }

    }];
}

#pragma mark--UITableViewDataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMSystemMessageCell *systemMessageCell=(WMSystemMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    WMMessageDetailModel *messageDetailModel=self.dataSource[indexPath.row];
    
    if (!systemMessageCell) {
        systemMessageCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSystemMessageCell" owner:self options:Nil] lastObject];
    }
    [systemMessageCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [systemMessageCell setupViewWithModel:messageDetailModel];
    return systemMessageCell;

   
    
}

#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     WMMessageDetailModel *messageDetailModel=self.dataSource[indexPath.row];
    WMMessageType messageType;
    messageType=[messageDetailModel.type intValue];
    switch (messageType) {
        case WMMessageTypeNotification:
        {
            //通知消息
            WMNotificationMessageViewController *vc=[[WMNotificationMessageViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WMMessageTypeTradeMessage:
        {
            //交易消息
            WMTradeMessageViewController *vc=[[WMTradeMessageViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WMMessageTypeRecommend:
        {
            //新闻咨询、活动
            WMRecommendNewViewController *vc=[[WMRecommendNewViewController alloc]init];
            vc.titleName=messageDetailModel.name;
            vc.type = @"1005";
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case WMMessageTypeInformation:
        {
            //资讯消息
            WMRecommendNewViewController *vc=[[WMRecommendNewViewController alloc]init];
            vc.titleName=messageDetailModel.name;
            vc.type = @"1006";
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:{
            [PopUpUtil confirmWithTitle:NSLocalizedString(@"kText_warm_prompt", nil) message:NSLocalizedString(@"kText_message_version_upgrade", nil) toViewController:nil buttonTitles:@[NSLocalizedString(@"kText_temporarily_not_update", nil),NSLocalizedString(@"kText_upgrade_immediately", nil)] completionBlock:^(NSUInteger buttonIndex) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
                }
                
            }];
        }
            break;
    }
       
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
