//
//  WMDoctorMainTableViewController.m
//  WMDoctor
//  医生主页
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMDoctorMainTableViewController.h"
#import "WMDoctorServiceModel.h"
#import "WMGetDoctorServiceAPIManager.h"
#import "WMPublicPageParamModel.h"
#import "WMDoctorInfoCell.h"
#import "WMDoctorPriceCell.h"
#import "WMRateTableViewCell.h"
#import "WMOpenServiceAPIManager.h"
#import "WMCertificationViewController.h"

#import "UINavigationBar+Awesome.h"

@interface WMDoctorMainTableViewController ()
{
    WMDoctorServiceModel * model;
    NSMutableDictionary *_pageDic;
    WMDoctorMyServiceModel * _doctorModel;
    WMDoctorServiceCommentsModel * _commentModel;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//评价数据源
@property(nonatomic, strong)NSMutableArray *dataServiceSource;  //头部数据
@end

@implementation WMDoctorMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadDefaultData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //注册一个通知开启状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeOpenServiceNotification:) name:@"changeOpenServiceNotification" object:@"flagValue"];
    
    //注册一个通知改变价格
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePrice:) name:@"changePriceNotification" object:@"flagValue"];
    
}

//通知改变价格
- (void)changeOpenServiceNotification:(NSNotification *)notification{
    if ([notification.userInfo[@"type"] isEqualToString:@"0"]) {
        ((WMDoctorMyServiceModel *)_dataServiceSource[0]).openService = [notification.userInfo[@"flag"] intValue];
    }else{
        ((WMDoctorMyServiceModel *)_dataServiceSource[1]).openService = [notification.userInfo[@"flag"] intValue];
    }
    
    
    [self.tableView reloadData];
    
}

//通知改变价格
- (void)changePrice:(NSNotification *)notification{
    if ([notification.userInfo[@"type"] isEqualToString:@"0"]) {
        ((WMDoctorMyServiceModel *)_dataServiceSource[0]).price = [NSString stringWithFormat:@"%@元/次",notification.userInfo[@"price"]];
    }else{
        ((WMDoctorMyServiceModel *)_dataServiceSource[1]).price = [NSString stringWithFormat:@"%@元/月",notification.userInfo[@"price"]];
    }
    
    
    [self.tableView reloadData];
    
}

- (void)setupView{
    self.tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    //初始化
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    self.dataServiceSource = [[NSMutableArray  alloc] initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
    
    //注册CELL
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMRateTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"WMRateTableViewCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar.layer addSublayer:[CommonUtil backgroundColorInNavigation:self.navigationController.navigationBar]];
    
//    [self.navigationController.navigationBar.layer removeFromSuperlayer];
    
}

-(void)loadDefaultData{
    
    [self loadDataWithPage:1];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}

- (void)loadDataWithPage:(NSInteger)pageIndex{
    WMPublicPageParamModel *patientReportedParamModel=[[WMPublicPageParamModel alloc]init];
    patientReportedParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    patientReportedParamModel.pageSize=kPAGEROW;
    
    
    WMGetDoctorServiceAPIManager * manager = [[WMGetDoctorServiceAPIManager alloc]init];
    
    [manager loadDataWithParams:patientReportedParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        model = (WMDoctorServiceModel *)responseObject;
        [_dataServiceSource removeAllObjects];
        [_dataServiceSource addObjectsFromArray:model.myServices];
        
        [self.tableView reloadData];
        
        NSLog(@"%@",model);
    } withFailure:^(ResponseResult *errorResult) {
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        //医生评价
    return 0;
    
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 50.f;
    }
    
    WMDoctorServiceCommentsModel * commentmodel = (WMDoctorServiceCommentsModel *)_dataSource[indexPath.row -1];
    float height = 0;
    height += [CommonUtil heightForLabelWithText:commentmodel.commentContent width:kScreen_width-30 font:[UIFont systemFontOfSize:15]];
    if (commentmodel.commentTag && commentmodel.commentTag.length>0) {
        height += 20;
    }
    height += 98;
    return height;   //临时
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        return 0.00000001f; //二度人脉版本
        return 249.0f;
    }else{
        return 0.00000001f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00000001f;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //二度人脉版暂不需要
//        return nil;
        
        if (_dataServiceSource.count < 1) {
            return nil;
        }
        UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 149)];
        mainView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        
        //图文咨询
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, kScreen_width/2 - 20, 219)];
        leftView.layer.cornerRadius = 4;
        leftView.clipsToBounds = YES;
        leftView.backgroundColor = [UIColor whiteColor];
        
        //图文咨询topView
        UIView * leftTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2 -20, 110)];
        [leftTopView.layer addSublayer:[CommonUtil backgroundColorInView:leftTopView andStartColorStr:@"6ce1a1" andEndColorStr:@"3acac1"]];
        
        UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        leftImageView.layer.cornerRadius = 20;
        leftImageView.center = CGPointMake((kScreen_width/2-20)/2, 40);
        leftImageView.clipsToBounds = YES;
        leftImageView.backgroundColor = [UIColor whiteColor];
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:((WMDoctorMyServiceModel *)_dataServiceSource[0]).img] placeholderImage:[UIImage imageNamed:@"ic_tuwenzixun2"]];
        
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2-20, 22)];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.center = CGPointMake((kScreen_width/2-20)/2, 79);
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        leftLabel.text = ((WMDoctorMyServiceModel *)_dataServiceSource[0]).name;
        
        UILabel * leftMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2-20, 17)];
        leftMoneyLabel.textAlignment = NSTextAlignmentCenter;
        leftMoneyLabel.center = CGPointMake((kScreen_width/2-20)/2, 137);
        leftMoneyLabel.font = [UIFont systemFontOfSize:12];
        leftMoneyLabel.textColor = [UIColor colorWithHexString:@"666666"];
        if (((WMDoctorMyServiceModel *)_dataServiceSource[0]).openService == 0) {
            leftMoneyLabel.text = @"尚未提供此服务";
        }else if(((WMDoctorMyServiceModel *)_dataServiceSource[0]).openService == 1){
            leftMoneyLabel.text = ((WMDoctorMyServiceModel *)_dataServiceSource[0]).price;
        }else{
            leftMoneyLabel.text = @"暂未开通";
        }
        
        UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        
        
        if ((((WMDoctorMyServiceModel *)_dataServiceSource[0]).openService == 1)) {
            [leftBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"6ce1a1" andEndColorStr:@"3acac1"]];
            [leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(goServicePage:) forControlEvents:UIControlEventTouchUpInside];
        }else if(((WMDoctorMyServiceModel *)_dataServiceSource[0]).openService ==3){
            [leftBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"c8c8c8" andEndColorStr:@"bbbbbb"]];
            [leftBtn setTitle:@"开启" forState:UIControlStateNormal];
        }else{
            [leftBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"6ce1a1" andEndColorStr:@"3acac1"]];
            [leftBtn setTitle:@"开启" forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(openService:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        leftBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        leftBtn.center = CGPointMake((kScreen_width/2-20)/2, 219-40);
        leftBtn.layer.cornerRadius = 15;
        leftBtn.clipsToBounds = YES;
        leftBtn.tag = 10000;
        
        [mainView addSubview:leftView];
        [leftView addSubview:leftTopView];
        [leftView addSubview:leftMoneyLabel];
        [leftView addSubview:leftBtn];
        [leftTopView addSubview:leftImageView];
        [leftTopView addSubview:leftLabel];
        
        if (_dataServiceSource.count < 2) {
            return mainView;
        }
        
        //包月咨询
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(kScreen_width/2 +5, 15, kScreen_width/2 - 20, 219)];
        rightView.layer.cornerRadius = 4;
        rightView.clipsToBounds = YES;
        rightView.backgroundColor = [UIColor whiteColor];
        
        //图文咨询topView
        UIView * rightTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2 -20, 110)];
        [rightTopView.layer addSublayer:[CommonUtil backgroundColorInView:rightTopView andStartColorStr:@"ff9c57" andEndColorStr:@"f7701c"]];
        
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        rightImageView.layer.cornerRadius = 20;
        rightImageView.center = CGPointMake((kScreen_width/2-20)/2, 40);
        rightImageView.backgroundColor = [UIColor whiteColor];
        rightImageView.clipsToBounds = YES;
        [rightImageView sd_setImageWithURL:[NSURL URLWithString:((WMDoctorMyServiceModel *)_dataServiceSource[1]).img] placeholderImage:[UIImage imageNamed:@"ic_baoyuefuwu2"]];
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2-20, 22)];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.center = CGPointMake((kScreen_width/2-20)/2, 79);
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        rightLabel.text = ((WMDoctorMyServiceModel *)_dataServiceSource[1]).name;
        
        UILabel * rightMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width/2-20, 17)];
        rightMoneyLabel.textAlignment = NSTextAlignmentCenter;
        rightMoneyLabel.center = CGPointMake((kScreen_width/2-20)/2, 137);
        rightMoneyLabel.font = [UIFont systemFontOfSize:12];
        rightMoneyLabel.textColor = [UIColor colorWithHexString:@"666666"];
        
        if (((WMDoctorMyServiceModel *)_dataServiceSource[1]).openService == 0) {
            rightMoneyLabel.text = @"尚未提供此服务";
        }else if(((WMDoctorMyServiceModel *)_dataServiceSource[1]).openService == 1){
            rightMoneyLabel.text = ((WMDoctorMyServiceModel *)_dataServiceSource[1]).price;
        }else{
            rightMoneyLabel.text = @"暂未开通";
        }
        
        UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        
        if (((WMDoctorMyServiceModel *)_dataServiceSource[1]).openService == 1) {
            [rightBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"ff9c57" andEndColorStr:@"f7701c"]];
            [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(goServicePage:) forControlEvents:UIControlEventTouchUpInside];
        }else if(((WMDoctorMyServiceModel *)_dataServiceSource[1]).openService == 3){
            [rightBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"c8c8c8" andEndColorStr:@"bbbbbb"]];
            [rightBtn setTitle:@"开启" forState:UIControlStateNormal];
        }else{
            [rightBtn.layer addSublayer:[CommonUtil backgroundColorInView:leftBtn andStartColorStr:@"ff9c57" andEndColorStr:@"ff9c57"]];
            [rightBtn setTitle:@"开启" forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(openService:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        rightBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.center = CGPointMake((kScreen_width/2-20)/2, 219-40);
        rightBtn.layer.cornerRadius = 15;
        rightBtn.clipsToBounds = YES;
        rightBtn.tag = 10001;
        
        
        [mainView addSubview:rightView];
        [rightView addSubview:rightTopView];
        [rightView addSubview:rightMoneyLabel];
        [rightView addSubview:rightBtn];
        [rightTopView addSubview:rightImageView];
        [rightTopView addSubview:rightLabel];
        
        return mainView;
    }else if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 10)];
        view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        return view;
    }else if(section == 2){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 35)];
        view.layer.borderWidth = 0.5;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor colorWithHexString:@"dedede"].CGColor;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, 150, 23)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        
//        label.text = (stringIsEmpty(model.commentsNum))?@"患者评价(0)":[NSString stringWithFormat:@"患者评价(%@)",model.commentsNum];
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = (stringIsEmpty(model.commentsNum))?@"患者评价(0)":[NSString stringWithFormat:@"患者评价(%@)",model.commentsNum];
        return cell;
    }
    
    WMRateTableViewCell * cell = (WMRateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMRateTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WMDoctorServiceCommentsModel * commentmodel = (WMDoctorServiceCommentsModel *)_dataSource[indexPath.row-1];
    
    [cell setRateCellValue:commentmodel];
    if (commentmodel.commentTag && commentmodel.commentTag.length>0) {
        NSArray *labelArr = [commentmodel.commentTag componentsSeparatedByString:@","];
        [cell setLabelArr:labelArr];
        cell.commentTagView.hidden = NO;
    }else{  //隐藏评价标题
        cell.commentTagView.hidden = YES;
    }
    
    return cell;
    
    
    
}

- (void)openService:(UIButton *)btn{
    //认证状态：0:未提交认证 1:等待认证 2:认证通过 3:认证不通过
    if ([model.certificationStatus isEqualToString:@"0"] || [model.certificationStatus isEqualToString:@"3"]) {
        // 1.UIAlertView
        // 2.UIActionSheet
        // iOS8开始:UIAlertController == UIAlertView + UIActionSheet
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"认证后可开启在线咨询服务" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
//        __weak typeof(alert) weakAlert = alert;
        [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            WMCertificationViewController * goVC = [WMCertificationViewController new];
            goVC.isFirstLogin = false;
            goVC.service_model = model;
            [self.navigationController pushViewController:goVC animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if ([model.certificationStatus isEqualToString:@"1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已提交实名认证，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        //        __weak typeof(alert) weakAlert = alert;
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString * typeid = @"";
    if (btn.tag == 10000) {
        typeid = ((WMDoctorMyServiceModel *)self.dataServiceSource[0]).typeId;
    }else{
        typeid = ((WMDoctorMyServiceModel *)self.dataServiceSource[1]).typeId;
    }
    
    WMOpenServiceAPIManager * manager = [[WMOpenServiceAPIManager alloc]init];
    
    [manager loadDataWithParams:@{@"openService":@"1",@"typeId":typeid} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if (btn.tag == 10000) { //同时改变内存里的值，保证刷新表格后展现正确UI。
            ((WMDoctorMyServiceModel *)self.dataServiceSource[0]).openService = 1;
        }else{
            ((WMDoctorMyServiceModel *)self.dataServiceSource[1]).openService = 1;
        }
        [self.tableView reloadData];
        [self goServicePage:btn];
    } withFailure:^(ResponseResult *errorResult) {
    }];

}

//去服务设置页
-(void)goServicePage:(UIButton *)btn{
    if (btn.tag == 10000) {
        [self performSegueWithIdentifier:@"goMyServiceSegue" sender:self.dataServiceSource[0]];
    }else{
        [self performSegueWithIdentifier:@"goMyServiceSegue" sender:self.dataServiceSource[1]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 1) {
//         [self performSegueWithIdentifier:@"goMyServiceSegue" sender:nil];
//    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"changeOpenServiceNotification"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"changePriceNotification"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goMyServiceSegue"]) {   //去我的服务设置
        [segue.destinationViewController setValue:(WMDoctorMyServiceModel *)sender forKey:@"serviceModel"];
    }
}


@end
