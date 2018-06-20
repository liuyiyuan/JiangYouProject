//
//  WMRecommendDocViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRecommendDocViewController.h"
#import "WMRecommendDocCell.h"
#import "WMDoctorCardAPIManager.h"
#import "WMDoctorCardModel.h"
#import "WMRCBusinessCardMessage.h"
#import "WMDoctorCardSaveAPIManager.h"
#import "WMRCConversationViewController.h"

@interface WMRecommendDocViewController  ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;            //页面table
    NSInteger _lastIndexRow;            //记录点击cell所在行
    NSMutableArray *_rowSourceArray;    //row数据源
}
@property (nonatomic ,strong)UIButton *sureButton;
@end

@implementation WMRecommendDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleName;
    [self setupData];
    [self setupView];
    [self loadDefourData];
    
    // Do any additional setup after loading the view.
}
-(void)setupData{
    _rowSourceArray=[[NSMutableArray alloc] initWithCapacity:0];
    _lastIndexRow=10086;
    
    
    UIView *sureView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame=CGRectMake(0, 0, 40, 44);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor colorWithHexString:@"8CD1FF"] forState:UIControlStateNormal];//
    _sureButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    _sureButton.enabled=NO;
    [_sureButton addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureView addSubview:_sureButton];
    
    /*
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMessageAction)];
    [sureView addGestureRecognizer:rightTap];
     */

    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:sureView];
    self.navigationItem.rightBarButtonItem=item;
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    
}
-(void)loadDefourData{
    
    WMDoctorCardAPIManager *doctorCardAPIManager=[[WMDoctorCardAPIManager alloc] init];
    NSDictionary *paramDic=[[NSDictionary alloc] initWithObjectsAndKeys:self.officeId,@"officeId", nil];
    
    [doctorCardAPIManager loadDataWithParams:paramDic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        WMDoctorCardModel *doctorCardModel=[[WMDoctorCardModel alloc] initWithDictionary:responseObject error:nil];
        [_rowSourceArray addObjectsFromArray:doctorCardModel.doctorCards];
        
        [_tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
        NSLog(@"doctorCardModel=%@",errorResult);
        
    }];
}
- (void)setupView {
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 105, 0, 0);
    _tableView.tableFooterView=[UIView new];
    
    //刷新
    
    
}
-(void)sendMessageAction:(UIButton *)button{
    
    //根据 两个标志 把数据从数据源里面找到。开始拼接数据 发送消息  返回上一个页面。
    _sureButton.enabled=NO;
    [_sureButton setTitleColor:[UIColor colorWithHexString:@"8CD1FF"] forState:UIControlStateNormal];
    
    WMDoctorCardDetailModel *model=_rowSourceArray[_lastIndexRow];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model.orgId,@"JIGOUBH",model.employCode,@"YISHENGBH",model.officeId,@"KESHIBH", nil];
    NSString *dicStr=[self dictionaryToJson:dic];
    
    NSString *pushContentStr=[NSString stringWithFormat:@"%@的名片",model.doctorName];
    
    /*
     [jigoubh]: 910500000000110025
     [keshibh]: 910100000000035433
     [yishengbh]: 910100000000666189
     */
    WMRCBusinessCardMessage *doctorCardMessage=[WMRCBusinessCardMessage messageWithTitle:model.title withDoctorName:model.doctorName withHospital:model.orgName withHeadUrl:model.photo withDepartment:self.titleName withCardStr:@""];//[WMRCBusinessCardMessage messageWithTitle:model.title withDoctorName:model.doctorName withHospital:model.orgName withHeadUrl:model.photo withCardStr:@""];
    doctorCardMessage.extra=dicStr;
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE
                          targetId:self.targetIdStr
                           content:doctorCardMessage
                       pushContent:pushContentStr
                          pushData:nil
                           success:^(long messageId) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   [self sendMessageSavedGcenariosWithModel:model];                               });
                               
                               NSLog(@"发送成功。当前消息ID：%ld", messageId);
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                           }];

    
}
#pragma mark-- 发送信息后存档
-(void)sendMessageSavedGcenariosWithModel:(WMDoctorCardDetailModel *)model{
    

    
    WMDoctorCardSaveAPIManager *doctorCardSaveAPIManager=[[WMDoctorCardSaveAPIManager alloc] init];
    NSDictionary *paramDic=[[NSDictionary alloc] initWithObjectsAndKeys:model.userCode,@"userCode",model.doctorName,@"doctorName",model.orgName,@"orgName",model.title,@"title",model.photo,@"photo",self.dingdanhao,@"orderId",self.targetIdStr,@"weimaihao",model.employCode,@"employCode",nil];
    [doctorCardSaveAPIManager loadDataWithParams:paramDic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObjectresponseObject=%@",responseObject);
        NSArray * arr =  self.navigationController.viewControllers;
        for (int i = 0; i < arr.count;i++) {
            UIViewController * views = (UIViewController *)arr[i];
            if([NSStringFromClass(views.class) isEqualToString:@"WMRCConversationViewController"]){
                WMRCConversationViewController *VC=(WMRCConversationViewController *)views;
                //VC.photos=self.array;
                [self.navigationController popToViewController:VC animated:YES];
            }
            
        }
        _sureButton.enabled=YES;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        _sureButton.enabled=YES;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _rowSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    WMDoctorCardDetailModel *model=_rowSourceArray[indexPath.row];
    
    WMRecommendDocCell *cell=(WMRecommendDocCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"WMRecommendDocCell" owner:self options:Nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    [cell setupViewWithModel:model];
    if (indexPath.row==_lastIndexRow) {
        cell.choiceImageView.image=[UIImage imageNamed:@"选中"];
    }else{
         cell.choiceImageView.image=[UIImage imageNamed:@"未选中"];
    }
    
    return cell;
    
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 40)];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f0f0f0"];
    UILabel *keshiLabel=[[UILabel alloc] initWithFrame:CGRectMake(16, 10, 200, 20)];
    keshiLabel.textColor=[UIColor colorWithHexString:@"999999"];
    keshiLabel.font=[UIFont systemFontOfSize:14];
    keshiLabel.text=@"眼科";
    [headerView addSubview:keshiLabel];
    return headerView;
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastIndexRow=indexPath.row;
    
   
    if (_lastIndexRow!=10086) {
        _sureButton.enabled=YES;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//

    }
   [_tableView reloadData];
    
    /*
    NSString *messageStr=self.dateSoureArr[indexPath.row];
    RCTextMessage *testMessage=[RCTextMessage messageWithContent:messageStr];
    
    [[RCIM sharedRCIM] sendMessage:_conversationVC.conversationType
                          targetId:_conversationVC.targetId
                           content:testMessage
                       pushContent:nil
                          pushData:nil
                           success:^(long messageId) {
                               NSLog(@"发送成功。当前消息ID：%ld", messageId);
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                           }];
    [self.navigationController popViewControllerAnimated:YES];
    */
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
