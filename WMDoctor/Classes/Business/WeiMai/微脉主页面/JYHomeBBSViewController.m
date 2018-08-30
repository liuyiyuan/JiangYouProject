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

@interface JYHomeBBSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYHomeBBSHeader *headerView;

@property (nonatomic, strong) JYHomeBBSFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JYHomeBBSViewController

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
    [self getBBSHot];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYHomeBBSTableViewCell *cell = [[JYHomeBBSTableViewCell alloc]init];
    switch (indexPath.row) {
        case 0:
            cell.myImageView.image = [UIImage imageNamed:@"JY_BBS_talk"];
            cell.titleLabel.text = @"江油聊吧";
            cell.contentLabel.text = @"在这里讨论江油民生、新闻、生活话题";
            cell.addButton.hidden = NO;
            cell.hasAddLabel.hidden = YES;
            break;
        case 1:
            cell.myImageView.image = [UIImage imageNamed:@"JY_BBS_love"];
            cell.titleLabel.text = @"情感沙龙";
            cell.contentLabel.text = @"情感专区、心情、职场、婆媳、夫妻、杂谈等";
            cell.addButton.hidden = YES;
            cell.hasAddLabel.hidden = NO;
            break;
        case 2:
            cell.myImageView.image = [UIImage imageNamed:@"JY_BBS_show"];
            cell.titleLabel.text = @"达人秀场";
            cell.contentLabel.text = @"我拍我秀，将我自己秀起来...";
            cell.addButton.hidden = NO;
            cell.hasAddLabel.hidden = YES;
            break;
            
        default:
            break;
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
