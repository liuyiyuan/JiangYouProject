//
//  JYHomeBBSViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSViewController.h"
#import "JYHomeBBSHeader.h"
#import "JYHomeBBSTableViewCell.h"
#import "JYHomeBBSFooterView.h"
#import "JYHomeBBSHotManager.h"
#import "JYHomeBBSChooseManager.h"
@interface JYHomeBBSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYHomeBBSHeader *headerView;

@property (nonatomic, strong) JYHomeBBSFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation JYHomeBBSViewController
{
    NSInteger _page;
    NSDictionary *_userDict;
    
}
-(NSMutableArray *)tableArray{
    if(!_tableArray){
        _tableArray = [[NSMutableArray alloc]init];
    }
    return _tableArray;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    _userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"JYLoginUserInfo"];
    [self getBBSHot];
    [self BBSChoose];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYHomeBBSTableViewCell *cell = [[JYHomeBBSTableViewCell alloc]init];
    NSDictionary *dict = self.tableArray[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"tagIcon"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
    cell.titleLabel.text = dict[@"title"];
    cell.contentLabel.text = dict[@"introduction"];
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    if(isFollow == YES){
        cell.addButton.hidden = YES;
        cell.hasAddLabel.hidden = NO;
    }else{
        cell.addButton.hidden = NO;
        cell.hasAddLabel.hidden = YES;
    }
          
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(120);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView.dataArray = self.dataArray;
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pixelValue(522);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return pixelValue(100);
}


#pragma mark - 热门
-(void)getBBSHot{
    JYHomeBBSHotManager *BBSHot = [[JYHomeBBSHotManager alloc] init];
    [BBSHot loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    
        
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.dataArray addObject:dic[@"img"]];
        }
        
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}

#pragma mark - 精选推荐
-(void)BBSChoose{
    JYHomeBBSChooseManager *BBSChoose = [[JYHomeBBSChooseManager alloc] init];
    [BBSChoose loadDataWithParams:@{@"userId":_userDict[@"userId"]} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        for (NSDictionary *dic in [responseObject allObjects]) {
            [self.tableArray addObject:dic];
        }
        
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}

#pragma mark - 发现更多点击
-(void)click_findMoreButton{
    
}

#pragma mark - get方法
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(JYHomeBBSHeader *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeBBSHeader alloc]init];
    }
    return _headerView;
}
-(JYHomeBBSFooterView *)footerView{
    if(!_footerView){
        _footerView = [[JYHomeBBSFooterView alloc]init];
        [_footerView.findMoreButton addTarget:self action:@selector(click_findMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
