//
//  JYHomeRecommendedViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeRecommendedViewController.h"
#import "JYHomeRecommendedHeaderView.h"
#import "JYHomeRecommendedSinglePictureTableViewCell.h"//左侧单图
#import "JYHomeRecommendedUnPictureTableViewCell.h"//无图
#import "JYHomeRecommendedThreePictureTableViewCell.h"//三图
#import "JYHomeRecommendedBigPictureTableViewCell.h"//大图
@interface JYHomeRecommendedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYHomeRecommendedHeaderView *headerView;
@end

@implementation JYHomeRecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYHomeRecommendedSinglePictureTableViewCell *cell = [[JYHomeRecommendedSinglePictureTableViewCell alloc]init];
    JYHomeRecommendedUnPictureTableViewCell *unPictureCell = [[JYHomeRecommendedUnPictureTableViewCell alloc]init];
    JYHomeRecommendedThreePictureTableViewCell *threePictureCell = [[JYHomeRecommendedThreePictureTableViewCell alloc]init];
    JYHomeRecommendedBigPictureTableViewCell *bigPictureCell = [[JYHomeRecommendedBigPictureTableViewCell alloc]init];
    
    if(indexPath.row == 0){
        return cell;
    }else if(indexPath.row == 1){
        return threePictureCell;
    }else if(indexPath.row == 2){
        return bigPictureCell;
    }else{
        return unPictureCell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pixelValue(500);
}

#pragma mark - get方法
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = pixelValue(380);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(JYHomeRecommendedHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeRecommendedHeaderView alloc]init];
    }
    return _headerView;
}


@end
