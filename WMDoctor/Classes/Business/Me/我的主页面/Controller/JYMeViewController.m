//
//  JYMeViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMeViewController.h"
#import "JYMeHeaderView.h"
#import "JYMeTableViewCell.h"
@interface JYMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *meTableView;

@property(nonatomic,strong)JYMeHeaderView *headerView;

@end

@implementation JYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.meTableView];
    
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYMeTableViewCell *cell = [[JYMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYMeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = [UIImage imageNamed:@"my_wallet"];
            cell.typeLabel.text = @"我的钱包";
            break;
        case 1:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"my_shop_center"];
            cell.typeLabel.text = @"商户中心";
        }
            break;
        case 2:
            cell.iconImageView.image = [UIImage imageNamed:@"my_push"];
            cell.typeLabel.text = @"订阅中心";
            break;
        case 3:
            cell.iconImageView.image = [UIImage imageNamed:@"my_answer_online"];
            cell.typeLabel.text = @"在线客服";
            break;
        case 4:
            cell.iconImageView.image = [UIImage imageNamed:@"my_about_us"];
            cell.typeLabel.text = @"关于我们";
            break;
        case 5:
            cell.iconImageView.image = [UIImage imageNamed:@"my_log_out"];
            cell.typeLabel.text = @"退出登录";
            break;
        default:
            break;
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    cell.selectedBackgroundView = backView;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(JYMeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYMeHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    }
    return _headerView;
}
-(UITableView *)meTableView{
    if(!_meTableView){
        _meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UI_SCREEN_WIDTH, 240)];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        _meTableView.backgroundColor = [UIColor whiteColor];
        _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _meTableView.showsVerticalScrollIndicator = NO;
    }
    return _meTableView;
}




@end
