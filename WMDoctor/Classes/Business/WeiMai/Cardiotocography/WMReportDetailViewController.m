//
//  WMReportDetailViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportDetailViewController.h"
#import "WMReportDetailModel.h"
#import "WMReportDetailManager.h"
#import "WMReportDatailCell.h"
#import "WMAllReportListViewController.h"
#import "WMReportReadCell.h"
#import "WMTaiXinTableViewCell.h"
#import "AppConfig.h"

#import "LKCMonitorView.h"
#import "LKCHeart.h"
#import "LKCOneRecord.h"
#import "WMJSONUtil.h"
#import "LKCResultFormVC.h"

#import "WMAdviceAPIManager.h"
#import "WMCostomAdviceModel.h"

#import "WMHistoryReportWebViewController.h"
#import "WMQuickReplyListViewController.h"

@interface WMReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    WMReportDetailModel * _models;
    WMReportDetailModelResult * _resultModel;
    WMReportDetailModelData * _dataModel;
    NSMutableDictionary * _mdic;
    WorkEnvironment _currentEnvir;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huifuHeight;   //默认47，快捷回复247
@property (weak, nonatomic) IBOutlet UITextField *huifuTextFeild;
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@property (weak, nonatomic) IBOutlet UIView * quickView;

//快捷回复
@property (weak, nonatomic) IBOutlet UILabel *onelabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;

@property (strong, nonatomic) LKCMonitorView          *monitorView; // 监听视图

@property (nonatomic , strong)  NSString * totalStr;
@property (nonatomic , strong)  NSString * scoreStr;
@property (nonatomic , strong)  NSString * modelScore;
@property (nonatomic , strong)  NSArray * suggestArr;

@property (nonatomic , strong)  NSArray * typeArr;
@property (nonatomic , strong)  NSArray * adviceArr;
@end

@implementation WMReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:30];
    
    [self setupUI];
    [self setupData];
//    self.httpManager = [LKCHttpManager shareInstance];
    // Do any additional setup after loading the view.
}

- (void)setupData{
    
    _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    
    self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    _models = [[WMReportDetailModel alloc]init];
    _resultModel = [[WMReportDetailModelResult alloc]init];
    _dataModel = [[WMReportDetailModelData alloc]init];
    
    WMReportDetailManager * apiManager = [WMReportDetailManager new];
    [apiManager loadDataWithParams:@{@"mid":self.report_id} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _models = (WMReportDetailModel *)responseObject;
        _resultModel = _models.detailsResult;
        _dataModel = _resultModel.data;
        [_dataSource addObjectsFromArray:_dataModel.desc];
        _mdic = [[NSMutableDictionary alloc]initWithCapacity:30];
        
        if (!stringIsEmpty(_dataModel.scoringDetails)) {
            _mdic = [WMJSONUtil JSONObjectWithString:_dataModel.scoringDetails];
        }
        
        if (_dataSource.count > 0) {
            _huifuHeight.constant = 0;
        }
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

-(UIView *)sureView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, 70, 40);
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(0, 0, 70, 40);
    label.textColor=[UIColor whiteColor];
    label.text=@"所有报告";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllreport)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    [view addGestureRecognizer:PrivateLetterTap];
    return view;
}

- (void)setupUI{
    self.quickView.hidden = YES;
    self.huifuHeight.constant = 47.f;
    self.huifuTextFeild.returnKeyType = UIReturnKeySend;
    self.huifuTextFeild.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //入口已改到报告列表中
//    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:[self sureView]];
//    buttonItem.width=70;
//    self.navigationItem.rightBarButtonItems = @[buttonItem];
    
    
    self.onelabel.userInteractionEnabled = YES;
    self.twoLabel.userInteractionEnabled = YES;
    self.threeLabel.userInteractionEnabled = YES;
    self.fourLabel.userInteractionEnabled = YES;
    self.fiveLabel.userInteractionEnabled = YES;
    [self.onelabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    [self.twoLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    [self.threeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    [self.fourLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    [self.fiveLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(changeTextValue:) name:@"QuickReplyNotification" object:@"quickStr"];
    
    
}

- (void)changeTextValue:(NSNotification*)sender{
    self.huifuTextFeild.text = [sender.userInfo objectForKey:@"theQuickStr"];
    [self.huifuTextFeild becomeFirstResponder];
}

- (void)goAllreport{
    NSArray * vcArr = self.navigationController.viewControllers;
    for (int i= 0; i<vcArr.count; i++) {
        UIViewController * vc = (UIViewController *)vcArr[i];
        if ([vc isKindOfClass:[WMAllReportListViewController class]]) {
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
    }
    
    WMAllReportListViewController * goVC = [WMAllReportListViewController new];
    goVC.title = @"所有报告";
    [self.navigationController pushViewController:goVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_dataSource.count < 1) {
            return 0;
        }
//        WMReportDetailModelDesc * model = [[WMReportDetailModelDesc alloc]initWithDictionary:_dataSource[indexPath.row] error:nil];
        WMReportDetailModelDesc * model = (WMReportDetailModelDesc *)_dataSource[indexPath.row];
        
        NSString * tempStr = model.advice;
        
        float height = [CommonUtil heightForLabelWithText:tempStr width:kScreen_width-30 font:[UIFont systemFontOfSize:14]] + 15.f+43.f;
        
        return height;
        
    }else if (indexPath.section == 1){
        float height = [CommonUtil heightForLabelWithText:[self getStr] width:kScreen_width-30 font:[UIFont systemFontOfSize:13]];
        
        
        return 139.5+height-2+[CommonUtil heightForLabelWithText:[NSString stringWithFormat:@"病历史：%@",_dataModel.medicalhistory] width:kScreen_width-30 font:[UIFont systemFontOfSize:13]];
    }else if (indexPath.section == 2){
        if (kScreen_width > 375) {
            return 620;
        }else if(kScreen_width < 321){
            return 500;
        }else{
            return 580;
        }
        
    }else{
        return 50.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_dataSource.count < 1) {
            return 0.00000000001f;
        }
        return 150.f;   //报告已解读
    }
    return 0.000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_dataSource.count < 1) {
            return nil;
        }
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 150)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
        label.center = CGPointMake(kScreen_width/2, 114);
        label.text = @"报告已解读";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [view addSubview:label];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.center = CGPointMake(kScreen_width/2, 60);
        imageView.image = [UIImage imageNamed:@"Combined_Shape"];
        [view addSubview:imageView];
        return view;
    }
    return nil;
}

- (NSString *)getStr{
    
    
    //        NSLog(@"=-=-=  %@",autoContentDic);
    
    _modelScore = [_mdic objectForKey:@"asctype"];
    
    
    
    

    _suggestArr = [[NSArray alloc] initWithObjects:@"时间过短或数据异常，无法完成评分。",@"本次监护结果为反应型，监护曲线提示本次监护结果良好（仅供参考）",@"本次监护结果为轻无反应型，可稍后再次进行胎心监测或辅以其他监测，确认胎儿状态（仅供参考）",@"本次监护结果为无反应型，请重视并辅以其他监测，确认胎儿状态（仅供参考）",@"本次监护结果为无反应型，怀疑胎儿窘迫，请反复进行胎心监测，确认胎儿状态，并向医生进行咨询，进行胎监报告解读（仅供参考））",@"危险警告，怀疑胎儿窘迫，请立即向医生进行咨询，进行胎监报告解读（仅供参考）", nil];
    
    
    _scoreStr = [_mdic objectForKey:@"result"];
    _typeArr = [_mdic objectForKey:@"advise"];
    _adviceArr = [_mdic objectForKey:@"type"];
    NSArray * totalArr = [_mdic objectForKey:@"totalscore"];
    NSLog(@"=== %@",totalArr);
    if ([[totalArr objectAtIndex:0] isEqual:[totalArr objectAtIndex:1]]) {
        _totalStr =[totalArr objectAtIndex:0];
    } else {
        _totalStr = [NSString stringWithFormat:@"%@-%@",[totalArr objectAtIndex:0],[totalArr objectAtIndex:1]];
    }
    NSArray * adviceArr = [_mdic objectForKey:@"advise"];
    //            NSString * dangerStr = @"";
    NSString * adviceStr = @"";
    
    NSString *warning =NSLocalizedString(@"报警内容",nil);
    NSArray * typeArr = [_mdic objectForKey:@"type"];
    if (([[totalArr objectAtIndex:0] intValue] + [[totalArr objectAtIndex:1] intValue])/2 < 7) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"低分警告",nil)];
    }
    if ([[typeArr objectAtIndex:0] intValue]>1) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"心率值异常警告",nil)];
    }
    if ([[typeArr objectAtIndex:1] intValue]>2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"变异过小警告",nil)];
    }
    if ([[typeArr objectAtIndex:3] intValue]!=1 && [[typeArr objectAtIndex:3] intValue]!=2 && [[typeArr objectAtIndex:3] intValue]!=8) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"存在减速警告",nil)];
    }
    if ([[typeArr objectAtIndex:4] intValue]==2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"正弦波警告",nil)];
    }
    if ([[typeArr objectAtIndex:5] intValue]==2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"STV警告",nil)];
    }
    if ([warning isEqualToString:NSLocalizedString(@"报警内容",nil)]) {
        warning = @"";
    }
    
    NSLog(@"___%@",[adviceArr objectAtIndex:4]);
    
    if ([_modelScore isEqual:[NSNumber numberWithInteger:5]]) {
        adviceStr = [_suggestArr objectAtIndex:[[adviceArr objectAtIndex:2]  intValue]];
    } else {
        adviceStr = [_suggestArr objectAtIndex:[[adviceArr objectAtIndex:1]  intValue]];
    }
    
    NSString *label_text1 = @"";
    if ([[typeArr objectAtIndex:4] intValue]==2) {
        //            warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"正弦波警告",nil)];
        
        label_text1 =[NSString stringWithFormat:@"%@  %@ %@",NSLocalizedString(@"一切以医生回复为准",nil),warning,NSLocalizedString(@"点击评分详情进行查看具体内容",nil)];
    }else{
        label_text1 =[NSString stringWithFormat:@"%@ %@%@ %@，%@ %@ ",NSLocalizedString(@"一切以医生回复为准",nil),NSLocalizedString(@"系统评分",nil),_totalStr,NSLocalizedString(@"分",nil),adviceStr,warning];
    }
    
    return label_text1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        LKCResultFormVC * formvc = [[LKCResultFormVC  alloc ]init];
        formvc.scoreStr = _mdic[@"result"];
        formvc.totalScore = [_mdic[@"totalscore"] firstObject];
//        formvc.ScoreModel = _mdic[@"asctype"];
        formvc.ScoreModel = @3;
        formvc.typeArr = _mdic[@"advise"];
        formvc.adviceArr = _mdic[@"type"];
        //       [self.navigationController pushViewController:vc animated:YES];
        
        [self presentViewController:formvc animated:YES completion:nil];
    }else if(indexPath.section == 3){
        //http://192.168.1.181/FHRM-h5/historyReport.html?uid=Y18968082441
        
        WMHistoryReportWebViewController * hisWeb = [[WMHistoryReportWebViewController alloc]init];
        if (_currentEnvir == 0) {
            hisWeb.urlString = [NSString stringWithFormat:@"%@?uid=%@",TX_LISHI_URL_FORMAL,_dataModel.uid];
        }else if(_currentEnvir == 3){
            hisWeb.urlString = [NSString stringWithFormat:@"%@?uid=%@",TX_LISHI_URL_PRE,_dataModel.uid];
        }else{
            hisWeb.urlString = [NSString stringWithFormat:@"%@?uid=%@",TX_LISHI_URL_TEST,_dataModel.uid];
        }
        
        //测试
//        hisWeb.urlString = @"http://dev.m.myweimai.com/hosp/taixinjianhu.html?uid=Y18968082441";
        
        
        [self.navigationController pushViewController:hisWeb animated:YES];
        
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataSource.count;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {   //报告解读
        WMReportReadCell * cell = (WMReportReadCell *)[tableView dequeueReusableCellWithIdentifier:@"WMReportReadCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        WMReportDetailModelDesc * model = [[WMReportDetailModelDesc alloc]initWithDictionary:_dataSource[indexPath.row] error:nil];
        WMReportDetailModelDesc * model = (WMReportDetailModelDesc *)_dataSource[indexPath.row];
        [cell setCellValue:model];
        return cell;
    }else if (indexPath.section == 1){  //系统评分
        WMReportDatailCell * cell = (WMReportDatailCell *)[tableView dequeueReusableCellWithIdentifier:@"WMReportDatailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setValueCell:_dataModel];
        cell.detailLabel.text = [self getStr];
        
        return cell;
    }else if (indexPath.section == 2){  //第三方胎心报告
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taixin"];
        
        if (kScreen_width > 375) {
            self.monitorView = [[LKCMonitorView alloc]  initWithFrame:CGRectMake(0, 0, kScreen_width, 620)];
        }else if(kScreen_width < 321){
            self.monitorView = [[LKCMonitorView alloc]  initWithFrame:CGRectMake(0, 0, kScreen_width, 500)];
        }else{
            self.monitorView = [[LKCMonitorView alloc]  initWithFrame:CGRectMake(0, 0, kScreen_width, 580)];
        }
        
        [cell addSubview:self.monitorView];
        
        if (!stringIsEmpty(_dataModel.fhrpath)) {
            self.monitorView.mp3OrWavString = _dataModel.wavpath;
            self.monitorView.monitorType = MonitorTypeReplay;
            NSDictionary* fhrInfo  = [self getfhrData:_dataModel.fhrpath];
            if (fhrInfo) {
                LKCOneRecord *record = [LKCOneRecord new];
                //保存fhr文件
                [self getDetailHttpFetalData:fhrInfo record:record];
                self.monitorView.replayRecord = record;
            }else{
                [WMHUDUntil showMessageToWindow:@"获取报告失败"];
            }
            
            
        }
        
        
        
        
        
        return cell;
    }else{      //历史报告入口
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thecell"];
        cell.textLabel.text = @"查看她的历史报告";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    
}

- (void)labelTap:(UITapGestureRecognizer *)gesture{
    
    self.huifuTextFeild.text = ((UILabel *)gesture.view).text;
    self.quickView.hidden = YES;
    self.huifuHeight.constant = 47.f;
    
}
- (IBAction)quickBtn:(id)sender {
//    self.quickView.hidden = NO;
//    self.huifuHeight.constant = 300.f;
//    [self.huifuTextFeild becomeFirstResponder];
    
    //新版快捷回复
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    WMQuickReplyListViewController * quickVC = [storyboard instantiateViewControllerWithIdentifier:@"WMQuickReplyListViewController"];
    quickVC.typeStr = @"Cardiotocography";
    [self.navigationController pushViewController:quickVC animated:YES];
}

//! 根据h返回的字典获取其中的fhr数据 将数据保存本地
-(void)getDetailHttpFetalData:(NSDictionary*)fhrInfo record:(LKCOneRecord*)record{
    if (fhrInfo == nil) {
        return;
    }else{
        NSString* type = [fhrInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"3p"]) {
            
            NSSet *fhrArray = [fhrInfo objectForKey:@"data"];//data域
            NSString* timeLong =  [fhrInfo objectForKey:@"tlong"];
            NSArray* allObject = [fhrArray allObjects];
            NSDictionary *dic  = [fhrInfo objectForKey:@"key"];
            NSInteger a = dic.count;
            
            NSMutableArray *heartRateArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            int i = 0;
            int *byte = malloc(sizeof(int) * a);
            
            for (NSString* stringFhr in allObject) {
                byte[i++] = [stringFhr intValue];
                if (i == a) {
                    i = 0;
                    LKCHeart *heart = [[LKCHeart alloc] init];
                    heart.rate      = byte[0];
                    heart.rate2     = byte[1];
                    heart.tocoValue = byte[3];
                    heart.signal    = byte[4];
                    heart.move      = byte[6] * 2;
                    heart.battValue = byte[7];
                    if (a == 10) {
                        heart.tocoReset = byte[9];// 注意警惕啊分析时 内存泄漏问题
                    }
                    
                    [heartRateArray addObject:heart];
                }
            }
            
            record.hearts = [heartRateArray mutableCopy];//将所有的胎心数据全部拷贝
            record.monitorDuration = [timeLong intValue];
            NSDate * nowDate = [NSDate date];
            record.startTimeInterval = [nowDate timeIntervalSince1970];
//            LKCHistoryManager *historyManager = [LKCHistoryManager shareHistoryManager];
//            [historyManager archiveRecordToHistory:record];//写成RTF文件
            
        }
        
    }
}

//更新记录时，获取服务器上的某条记录的fhr波形数据
-(id) getfhrData:(NSString*) fhrName{
    
    NSDictionary* resultInfo = [self receiveDictionaryForURLString:[NSURL URLWithString:fhrName]];
    return resultInfo;
}

//输入url地址，发送http协议，返回返回的字典
-(id)receiveDictionaryForURLString:(NSURL*)urlString{
    
    //第一步，创建URL
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    //第三步，连接服务器
    NSError * error;
    
    NSData *received = (NSData*)[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSLog(@"---- %@",urlString);
    NSLog(@"---- %@",received);
    NSString *result0 = [[NSString alloc] initWithData:received  encoding:NSUTF8StringEncoding];
    NSLog(@"---==- %@",result0);
    
    if (!result0) {
        return nil;
    }
    
    //过滤json返回的错误数据
    result0 = [result0 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"“" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"”" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"'" withString:@""];
    result0 = [result0 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSData* xmlData = [result0 dataUsingEncoding:NSUTF8StringEncoding];
    if (received == nil) {
        return nil;
    }else{
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:xmlData options:kNilOptions error:nil];
        return result;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.huifuTextFeild resignFirstResponder];
    self.quickView.hidden = YES;
    self.huifuHeight.constant = 47.f;
    
    if (self.huifuTextFeild.text.length < 1) {
        [WMHUDUntil showMessageToWindow:@"回复内容不能为空"];
        return NO;
    }
    
    WMAdviceAPIManager * apiManager = [WMAdviceAPIManager new];
    
    WMCostomAdviceModel * costomModel = [[WMCostomAdviceModel alloc]init];
    costomModel.desc = self.huifuTextFeild.text;
    costomModel.mid = _dataModel.mid;
    costomModel.score = [_dataModel.score intValue];
    
    NSArray * scarrSprit = [_mdic[@"result"] componentsSeparatedByString:@"," ];
    
//    NSArray * arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[scarrSprit[0] integerValue]],[NSNumber numberWithInteger:[scarrSprit[0] integerValue]],[NSNumber numberWithInteger:[scarrSprit[0] integerValue]], nil];
    
    NSArray * scarr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[scarrSprit[0] integerValue]],[NSNumber numberWithInteger:[scarrSprit[1] integerValue]],[NSNumber numberWithInteger:[scarrSprit[2] integerValue]],[NSNumber numberWithInteger:[scarrSprit[3] integerValue]],[NSNumber numberWithInteger:[scarrSprit[4] integerValue]], nil];
    WMReportDetailModelSc * sc = [WMReportDetailModelSc new];
    sc.sc4 = scarr;
    sc.scorer = @"";
    costomModel.scdetail = sc;
    
    WMCostomAdviceModels * reportModel = [[WMCostomAdviceModels alloc]init];
    reportModel.report = costomModel;
    
    
    [apiManager loadDataWithParams:reportModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary * adviceDic = responseObject[@"adviceResult"];
        if ([adviceDic[@"errmsg"] intValue] == -2) {
            [WMHUDUntil showMessageToWindow:@"该报告已被处理，不能再次解读"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCount" object:nil userInfo:nil];
        
        [self setupData];
        self.huifuTextFeild.text = nil;
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
    
    
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuickReplyNotification" object:@"quickStr"];
}

- (void)viewDidDisappear:(BOOL)animated{
    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
    
    [LKCPlayManager stop];
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
