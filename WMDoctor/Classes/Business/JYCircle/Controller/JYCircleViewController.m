//
//  JYCircleViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/7/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleViewController.h"
#import "HYBLoopScrollView.h"
#import "JYMeTableViewCell.h"
@interface JYCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HYBLoopScrollView *loopView;//轮播图

@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.title = @"圈子";
    
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.tableView];
    
    
    [self.tableViewHeaderView addSubview:self.loopView];
}



#pragma mark - UITableViewDelegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYMeTableViewCell *cell = [[JYMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYMeTableViewCell"];
    cell.lineView.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = [UIImage imageNamed:@"friend_dynamic"];
            cell.typeLabel.text = @"好友动态";
            break;
        case 1:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"my_near"];
            cell.typeLabel.text = @"我的附近";
        }
            break;
        case 2:
            cell.iconImageView.image = [UIImage imageNamed:@"Recent_visitors"];
            cell.typeLabel.text = @"最近访客";
            break;
        default:
            break;
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    cell.selectedBackgroundView = backView;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableViewHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return pixelValue(400);
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.frame.size.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }
    return _tableView;
}

-(UIView *)tableViewHeaderView{
    if(!_tableViewHeaderView){
        _tableViewHeaderView = [[UIView alloc]init];
    }
    return _tableViewHeaderView;
}


-(HYBLoopScrollView *)loopView{
    if(!_loopView){
        _loopView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(230)) imageUrls:nil timeInterval:5 didSelect:^(NSInteger atIndex) {
            
        } didScroll:^(NSInteger toIndex) {
            
        }];
    }
    return _loopView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:NO];
}

@end
