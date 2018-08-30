//
//  JYHomeSameCityViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCityViewController.h"
#import "JYHomeSameCItyHeaderView.h"
#import "JYHomeSameCityTableViewCell.h"
#import "JYHomeSameCitySecondHeaderView.h"
#import "JYHomeSameCityManager.h"
@interface JYHomeSameCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYHomeSameCItyHeaderView *headerView;

@property (nonatomic, strong) JYHomeSameCitySecondHeaderView *secondHeaderView;

@property (nonatomic, strong) NSArray *hotArray;

@property (nonatomic, strong) NSArray *homeArray;

@property (nonatomic, strong) NSMutableArray *fastListArray;//头部快捷数组

@property (nonatomic, strong) NSMutableArray *photoNavListArray;//三图数组

@property (nonatomic, strong) NSMutableArray *bigModuleListArray;//家庭服务和热门服务总数组

@end

@implementation JYHomeSameCityViewController

-(NSMutableArray *)bigModuleListArray{
    if(!_bigModuleListArray){
        _bigModuleListArray = [[NSMutableArray alloc]init];
    }
    return _bigModuleListArray;
}

-(NSMutableArray *)photoNavListArray{
    if(!_photoNavListArray){
        _photoNavListArray = [[NSMutableArray alloc]init];
    }
    return _photoNavListArray;
}

-(NSMutableArray *)fastListArray{
    if(!_fastListArray){
        _fastListArray = [[NSMutableArray alloc]init];
    }
    return _fastListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
   
    [self getSameCityList];
    
}

-(void)configUI{
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYHomeSameCityTableViewCell *cell = [[JYHomeSameCityTableViewCell alloc]init];
    
    if(indexPath.section == 0){
        NSArray *firstArray = self.bigModuleListArray[0][@"containModuleList"];
        cell.titleArray = firstArray;
    }else if(indexPath.section == 1){
        NSArray *secondArray = self.bigModuleListArray[1][@"containModuleList"];
        cell.titleArray = secondArray;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSArray *firstArray = self.bigModuleListArray[0][@"containModuleList"];
        CGFloat height = firstArray.count / 4;
        if(firstArray.count % 4 > 0){
            height += 1;
        }
        return height * pixelValue(70);
    }else if(indexPath.section == 1){
        NSArray *secondArray = self.bigModuleListArray[1][@"containModuleList"];
        CGFloat height = secondArray.count / 4;
        if(secondArray.count % 4 > 0){
            height += 1;
        }
        return height * pixelValue(70);
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        self.headerView.fastListArray = self.fastListArray;
        self.headerView.photoNavListArray = self.photoNavListArray;
        return self.headerView;
    }else if(section == 1){
        if(section == 0){
            NSString *titleString = self.bigModuleListArray[0][@"bigModuleTitle"];
            self.secondHeaderView.hotLabel.text = titleString;
        }else if(section == 1){
            NSString *titleString = self.bigModuleListArray[1][@"bigModuleTitle"];
            self.secondHeaderView.hotLabel.text = titleString;
        }
        return self.secondHeaderView;
    }
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return pixelValue(600);
    }else if(section == 1){
        return pixelValue(80);
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return pixelValue(1);
}


#pragma mark - 精选推荐
-(void)getSameCityList{
    JYHomeSameCityManager *sameCityManager = [[JYHomeSameCityManager alloc] init];
    [sameCityManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
            self.fastListArray = [NSMutableArray arrayWithArray:responseObject[@"fastList"]];
            self.photoNavListArray = [NSMutableArray arrayWithArray:responseObject[@"photoNavList"]];
            self.bigModuleListArray = [NSMutableArray arrayWithArray:responseObject[@"bigModuleList"]];
        [self configUI];
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
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

-(JYHomeSameCItyHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYHomeSameCItyHeaderView alloc]init];
    }
    return _headerView;
}
-(JYHomeSameCitySecondHeaderView *)secondHeaderView{
    if(!_secondHeaderView){
        _secondHeaderView = [[JYHomeSameCitySecondHeaderView alloc]init];
    }
    return _secondHeaderView;
}

@end
