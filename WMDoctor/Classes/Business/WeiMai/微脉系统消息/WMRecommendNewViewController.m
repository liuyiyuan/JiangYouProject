//
//  WMRecommendNewViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMRecommendNewViewController.h"
#import "WMNewInfoMessageCell.h"
#import "WMMessageListAPIManager.h"
#import "WMMessageLisParamModel.h"
#import "WMMessageListModel.h"
#import "WMMessageNewDetailViewController.h"
#import "AppConfig.h"
#import "WMDoctorInformationAPIManager.h"
#import "WMDoctorInfoNewsModel.h"


@interface WMRecommendNewViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_pageDic;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation WMRecommendNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleName;
    [self setupView];
    [self setupData];
    [self loadDefaultData];
}
-(void)setupView{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];

    _tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight);
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
     _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    _tableView.mj_footer = footer;
    [self.view addSubview:_tableView];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}
- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    
    
    WMMessageLisParamModel *messageLisParamModel=[[WMMessageLisParamModel alloc]init];
    messageLisParamModel.type=self.type;
    messageLisParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    messageLisParamModel.pageSize=kPAGEROW;
    
    WMMessageListAPIManager *messageTypeAPIManager=[[WMMessageListAPIManager alloc]init];
    
    [messageTypeAPIManager loadDataWithParams:messageLisParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        WMMessageListModel *messageTypeModel=(WMMessageListModel *)responseObject;
        
        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:messageTypeModel.messageList];
        [_pageDic setValue:[NSString stringWithFormat:@"%@",messageTypeModel.currentPage] forKey:@"currentPage"];
        
        if (_dataSource.count == 0) {
            NSLog(@"最后一页");
            _tableView.mj_footer.hidden = YES;
            [_tableView showBackgroundView:@"暂无消息" type:BackgroundTypeNOZiXun];
        }
        else if ([[_pageDic valueForKey:@"currentPage"] floatValue]<[messageTypeModel.totalPage floatValue]) {
            _tableView.backgroundView = nil;
            _tableView.mj_footer.hidden = NO;
        }
        else {
            _tableView.backgroundView = nil;
            _tableView.mj_footer.hidden = YES;
        }
        [_tableView reloadData];
        
        if ([_tableView.mj_header isRefreshing]) {
            
            [_tableView.mj_header endRefreshing];
            
        }
        if ([_tableView.mj_footer isRefreshing]) {
            
            [_tableView.mj_footer endRefreshing];
            
        }
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
        
        if (_dataSource.count<=0) {
             [_tableView showBackgroundView:@"暂无消息" type:BackgroundTypeNOZiXun];
            
            
        }else{
            
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        
    }];
    
    
}



-(void)setupData{
    self.dataSource=[[NSMutableArray alloc]initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];

}

-(void)loadDefaultData{
    
    [self loadDataWithPage:1];
}


#pragma mark--UITableViewDataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMNewInfoMessageCell *newInfoMessag=(WMNewInfoMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    WMMessageListDetailModel *listDetailModel=_dataSource[indexPath.row];
    if (!newInfoMessag) {
        newInfoMessag=[[[NSBundle mainBundle]loadNibNamed:@"WMNewInfoMessageCell" owner:self options:Nil] lastObject];
    }
    [newInfoMessag setSelectionStyle:UITableViewCellSelectionStyleNone];
    [newInfoMessag setupViewWithModel:listDetailModel];
    return newInfoMessag;

    
}
#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMMessageListDetailModel *listDetailModel=_dataSource[indexPath.row];
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    WMMessageNewDetailViewController *messageNewDetailVC=[[WMMessageNewDetailViewController alloc]init];
    
    if ([self.type intValue] == 1005) {
        //活动
        messageNewDetailVC.urlString = listDetailModel.messageUrl;
        messageNewDetailVC.shareTitle = listDetailModel.messageTitle;
        messageNewDetailVC.shareDetail = listDetailModel.messageSummary;
        messageNewDetailVC.sharePictureUrl = listDetailModel.messageImg;
        messageNewDetailVC.shareUrl = listDetailModel.messageUrl;
        [self.navigationController pushViewController:messageNewDetailVC animated:YES];
        return;
    }
    
    WMDoctorInformationAPIManager *doctorInfoAPIManager = [[WMDoctorInformationAPIManager alloc] init];
    NSDictionary *param = @{
                            @"newsId" : listDetailModel.messageUrl,
                            @"userCode" : [NSString stringWithFormat:@"%@", loginModel.userId]
                            };
    [doctorInfoAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMDoctorInfoNewsModel *doctorInfo = [[WMDoctorInfoNewsModel alloc] initWithDictionary:responseObject error:nil];
        NSString *urlStr = @"";
        if ([doctorInfo.doctorNewsDetailVo.type intValue] == 1) {
            urlStr = doctorInfo.doctorNewsDetailVo.content;
        }else{
            urlStr = doctorInfo.doctorNewsDetailVo.shareLink;
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"%newsId" withString:doctorInfo.doctorNewsDetailVo.newsId];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"%userCode" withString:[NSString stringWithFormat:@"%@", loginModel.userId]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"%isShare" withString:@"false"];
        messageNewDetailVC.urlString = urlStr;
        messageNewDetailVC.shareTitle = doctorInfo.doctorNewsDetailVo.title;
        messageNewDetailVC.shareDetail = doctorInfo.doctorNewsDetailVo.introduction;
        messageNewDetailVC.sharePictureUrl = doctorInfo.doctorNewsDetailVo.image;
        messageNewDetailVC.shareUrl = [urlStr stringByReplacingOccurrencesOfString:@"false" withString:@"true"];
        [self.navigationController pushViewController:messageNewDetailVC animated:YES];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"listDetail error : %@", errorResult);
    }];
    
    /*
    
    if ([listDetailModel.skipTag intValue]==0) {
        //不能点击
        return;
    }
    else if([listDetailModel.skipTag intValue]==1){
        WMMessageNewDetailViewController *messageNewDetailVC=[[WMMessageNewDetailViewController alloc]init];
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        messageNewDetailVC.urlString= [CommonUtil utf8WithString:[NSString stringWithFormat:@"%@&doctorId=%@",listDetailModel.messageUrl,loginModel.userId]];
//        [WMHUDUntil showMessageToWindow:messageNewDetailVC.urlString];
        
        
         messageNewDetailVC.shareTitle=listDetailModel.messageTitle;
        messageNewDetailVC.shareDetail=listDetailModel.messageSummary;

         messageNewDetailVC.shareUrl=listDetailModel.messageUrl;
        if ([self.type isEqualToString:@"1006"]) {
            
            WorkEnvironment currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
            NSString * urlStr = (currentEnvir == 0)?H5_URL_INFORMATIONDETAIL_FORMAL:(currentEnvir == 3)?H5_URL_INFORMATIONDETAIL_PRE:H5_URL_INFORMATIONDETAIL_TEST;
            messageNewDetailVC.urlString = [NSString stringWithFormat:@"%@?newsId=%@&userCode=%@&doctorId=%@",urlStr, listDetailModel.messageUrl, loginModel.userCode,loginModel.userId];
//            [WMHUDUntil showMessageToWindow:messageNewDetailVC.urlString];
            messageNewDetailVC.shareUrl = [NSString stringWithFormat:@"%@?newsId=%@&userCode=%@&isShare=true",urlStr, listDetailModel.messageUrl, loginModel.userCode];
        }
         messageNewDetailVC.sharePictureUrl=listDetailModel.messageImg;
        [self.navigationController pushViewController:messageNewDetailVC animated:YES];

    }
    else{
        [PopUpUtil confirmWithTitle:NSLocalizedString(@"kText_warm_prompt", nil) message:NSLocalizedString(@"kText_message_version_upgrade", nil) toViewController:nil buttonTitles:@[NSLocalizedString(@"kText_temporarily_not_update", nil),NSLocalizedString(@"kText_upgrade_immediately", nil)] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
            }
            
        }];
    }
    
    */
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 330;
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
