//
//  WMTradeMessageViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMTradeMessageViewController.h"
#import "WMNormalMessageCell.h"
#import "WMMessageLisParamModel.h"
#import "WMMessageListModel.h"
#import "WMMessageListAPIManager.h"
@interface WMTradeMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_pageDic;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMTradeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"交易消息";
    [self setupView];
    [self setupData];
    [self loadDefaultData];

    
    // Do any additional setup after loading the view.
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
-(void)setupData{
    self.dataSource=[[NSMutableArray alloc]initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
    
}
-(void)loadDefaultData{
    
    [self loadDataWithPage:1];
}

- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    
    
    WMMessageLisParamModel *messageLisParamModel=[[WMMessageLisParamModel alloc]init];
    messageLisParamModel.type=@"1003";
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
            [_tableView showBackgroundView:@"暂无记录" type:BackgroundTypeNOTrade];
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
             [_tableView showBackgroundView:@"暂无记录" type:BackgroundTypeNOTrade];
            //_loadingFailView.loadingLable.text=[error errorDescription];
            //[_loadingFailView showInView:self.view];
            
        }else{
            //[WMHUDUntil showFailWithMessage:[error errorDescription] toView:self.view.window];
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        
    }];
    
    
}

#pragma mark--UITableViewDataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMNormalMessageCell *normalMessageCell=(WMNormalMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    WMMessageListDetailModel *listDetailModel=_dataSource[indexPath.row];
    if (!normalMessageCell) {
        normalMessageCell=[[[NSBundle mainBundle]loadNibNamed:@"WMNormalMessageCell" owner:self options:Nil] lastObject];
    }
    [normalMessageCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [normalMessageCell setupViewWithModel:listDetailModel];
    return normalMessageCell;

    
}
#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMMessageListDetailModel *listDetailModel=_dataSource[indexPath.row];
    if ([listDetailModel.skipTag intValue]==0) {
        //不能点击
        return;
    }
    else{
        [PopUpUtil confirmWithTitle:NSLocalizedString(@"kText_warm_prompt", nil) message:NSLocalizedString(@"kText_message_version_upgrade", nil) toViewController:nil buttonTitles:@[NSLocalizedString(@"kText_temporarily_not_update", nil),NSLocalizedString(@"kText_upgrade_immediately", nil)] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
            }
            
        }];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
