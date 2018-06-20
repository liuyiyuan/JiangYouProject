//
//  WMPatientEvaluationViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientEvaluationViewController.h"
#import "WMGetPatientCommentsAPIManager.h"
#import "WMPatientCommentsModel.h"
#import "WMPublicPageParamModel.h"
#import "WMRateTableViewCell.h"
#import "WMDoctorServiceModel.h"

@interface WMPatientEvaluationViewController ()
{
    WMPatientCommentsNewModel * model;
    NSMutableDictionary *_pageDic;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation WMPatientEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.title = @"患者评价";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width , kScreen_height) style:UITableViewStyleGrouped];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(14, 0, 0, 0);
    //初始化
    self.tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
    //注册CELL
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMRateTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"WMRateTableViewCell"];
}

- (void)setupData{
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
}


-(void)loadDefaultData{
    [self loadDataWithPage:1];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}

//分页数据加载
- (void)loadDataWithPage:(NSInteger)pageIndex{
    WMPublicPageParamModel *patientReportedParamModel=[[WMPublicPageParamModel alloc]init];
    patientReportedParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    patientReportedParamModel.pageSize=kPAGEROW;
    
    
    WMGetPatientCommentsAPIManager * manager = [[WMGetPatientCommentsAPIManager alloc]init];
    [manager loadDataWithParams:patientReportedParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        model = (WMPatientCommentsNewModel *)responseObject;
        
        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:model.patientComments];
        [_pageDic setValue:[NSString stringWithFormat:@"%@",model.currentPage] forKey:@"currentPage"];
        //        _orderModel = model.orders;
        if (_dataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            [self.tableView showBackgroundView:@"暂无患者评价" type:BackgroundTypeNODingdan];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00000001f;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_dataSource.count == 0){
            return 0;
        }
        return 1;
    }else{    //评价列表
        return _dataSource.count;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50.0f;
    }else{
        WMDoctorServiceCommentsModel * commentmodel = (WMDoctorServiceCommentsModel *)_dataSource[indexPath.row];
        float height = 0;
        height += [CommonUtil heightForLabelWithText:commentmodel.commentContent width:kScreen_width-30 font:[UIFont systemFontOfSize:15]];
        if (commentmodel.commentTag && commentmodel.commentTag.length>0) {
            height += 20;
        }
        height += 98;
        return height;   //临时
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {   //累计收入
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = (stringIsEmpty(model.commentsNum))?@"患者评价（0）":[NSString stringWithFormat:@"患者评价（%@）",model.commentsNum];
//        cell.separatorInset = UIEdgeInsetsMake(15, 0, 0, 0);
        return cell;
    }else{
        WMRateTableViewCell * cell = (WMRateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMRateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WMDoctorServiceCommentsModel * commentmodel = (WMDoctorServiceCommentsModel *)_dataSource[indexPath.row];
        
        [cell setRateCellValue:commentmodel];
        if (commentmodel.commentTag && commentmodel.commentTag.length>0) {
            NSArray *labelArr = [commentmodel.commentTag componentsSeparatedByString:@","];
            [cell setLabelArr:labelArr];
            cell.commentTagView.hidden = NO;
        }else{  //隐藏评价标题
            cell.commentTagView.hidden = YES;
        }
        
//        cell.separatorInset = UIEdgeInsetsMake(15, 0, 0, 0);
        
        return cell;
    }
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
