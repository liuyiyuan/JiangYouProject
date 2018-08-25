//
//  JYCircleDynamicViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleMessageViewController.h"
#import "JYMeTableViewCell.h"
@interface JYCircleMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JYCircleMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, pixelValue(10), UI_SCREEN_WIDTH, self.view.frame.size.height);
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
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
    return cell;
}



@end
