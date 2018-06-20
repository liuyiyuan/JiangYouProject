//
//  WMMyOrderTableViewController.m
//  WMDoctor
//  我的订单
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyOrderTableViewController.h"
#import "WMOrderListAPIManager.h"
#import "WMPublicPageParamModel.h"
#import "WMOrderListModel.h"
#import "WMOrderlistCell.h"
#import "WMOrderCountCell.h"
#import "WMDoctorIncomeViewController.h"
#import "WMOrderCell.h"
#import "WMRCConversationViewController.h"
#import "RCIMGroupViewController.h"
#import "WMFriendCircleSetViewController.h"
#import "WMServiceViewController.h"
#import "AppConfig.h"
#import "WMQuestionDetailViewController.h"

@interface WMMyOrderTableViewController ()
{
    WMOrderListMainModel * model;
    NSMutableDictionary *_pageDic;
    WMOrderListModel * _orderModel;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMMyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    //[self loadDefaultData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupView{
    //初始化
    self.tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMOrderCell class]) bundle:nil] forCellReuseIdentifier:@"WMOrderCell"];
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadDefaultData{
    [self loadDataWithPage:1];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {     //总价详细
        if (_dataSource.count == 0) {
            return 0;
        }
        return 1;
    }else{    //订单列表
        return _dataSource.count;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 116.0f;
    }else{
        WMOrderListModel * listModel = (WMOrderListModel *)_dataSource[indexPath.row];
        if ([listModel.orderType intValue] == 7) {
            return 160.0f;
        }
        return 214.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {   //累计收入
        WMOrderCountCell *cell = (WMOrderCountCell *)[tableView dequeueReusableCellWithIdentifier:@"WMOrderCountCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.layer addSublayer:[CommonUtil backgroundColorInView:cell andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
        [cell.incomeBtn addTarget:self action:@selector(incomeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setValueForCell:model.totalFee];
        return cell;
    }else{
        
        WMOrderListModel * listModel = (WMOrderListModel *)_dataSource[indexPath.row];
        WMOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMOrderCell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setValueWithModel:listModel];
        cell.accept.tag = indexPath.row;
        [cell.accept addTarget:self action:@selector(acceptClickAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)acceptClickAction:(UIButton *)button{
    
    WMOrderListModel * order = (WMOrderListModel *)_dataSource[button.tag];
    if ([order.orderType intValue] == 1 || [order.orderType intValue] == 7) {
        WMRCConversationViewController *conversationVC = [[WMRCConversationViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;//model.conversationType;
        conversationVC.targetId = order.patientWeimaihao;
        conversationVC.title = order.huanzhexm;
        conversationVC.backName=@"微脉";
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    } else if ([order.orderType intValue] == 8){
        RCIMGroupViewController *conversationVC = [[RCIMGroupViewController alloc]init];
        conversationVC.conversationType = ConversationType_GROUP;
        conversationVC.targetId = order.groupId;
        conversationVC.groupName = order.groupName;
        conversationVC.backName=@"微脉";
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    } else if ([order.orderType intValue] == 9){
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
        WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
        WMQuestionModel *question = [[WMQuestionModel alloc] init];
        question.questionId = order.questionId;
        questionDetailViewController.question = question;
        questionDetailViewController.hidesBottomBarWhenPushed = YES;
        questionDetailViewController.backTitle = @"返回";
        [self.navigationController pushViewController:questionDetailViewController animated:YES];
    }
}

- (void)incomeBtnClickAction:(UIButton *)button{
    WMDoctorIncomeViewController *incomeViewController = [[WMDoctorIncomeViewController alloc] init];
    [self.navigationController pushViewController:incomeViewController animated:YES];
}


//分页数据加载
- (void)loadDataWithPage:(NSInteger)pageIndex{
    WMPublicPageParamModel *patientReportedParamModel=[[WMPublicPageParamModel alloc]init];
    patientReportedParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    patientReportedParamModel.pageSize=kPAGEROW;
    
    
    WMOrderListAPIManager * manager = [[WMOrderListAPIManager alloc]init];
    [manager loadDataWithParams:patientReportedParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        model = (WMOrderListMainModel *)responseObject;

        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:model.orders];
        [_pageDic setValue:[NSString stringWithFormat:@"%@",model.currentPage] forKey:@"currentPage"];
//        _orderModel = model.orders;
        if (_dataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            [self.tableView showBackgroundView:@"暂无订单" type:BackgroundTypeNODingdan];
        }
        else if ([[_pageDic valueForKey:@"currentPage"] floatValue]<[model.totalPage floatValue]) {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = NO;
        }
        else {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    } withFailure:^(ResponseResult *errorResult) {
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
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
