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
#import "JYMyWalletViewController.h"//我的钱包
#import "JYAboutUsViewController.h"//关于我们
#import "JYPersonalInformationViewController.h"//个人资料
#import "JYPersonEditInformationViewController.h"//个人信息编辑页
#import "JYFindPassWordViewController.h"//忘记密码
#import "JYFastLogInViewController.h"//快捷登录
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
    switch (indexPath.row) {
        case 0://我的钱包
        {
            JYMyWalletViewController *Wallet = [JYMyWalletViewController new];
            Wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Wallet animated:YES];
        }
            break;
         
        case 4://关于我们
        {
            JYAboutUsViewController *aboutUs = [JYAboutUsViewController new];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
            
        case 3://忘记密码
        {
            JYFindPassWordViewController *aboutUs = [JYFindPassWordViewController new];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 5://个人资料编辑
        {
            JYPersonEditInformationViewController *aboutUs = [JYPersonEditInformationViewController new];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            
            break;
        case 1://快捷登录
        {
            JYFastLogInViewController *aboutUs = [JYFastLogInViewController new];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            
            break;
        default:
            break;
    }
}

-(JYMeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYMeHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
        [_headerView.arrowButton addTarget:self action:@selector(click_arrowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
-(UITableView *)meTableView{
    if(!_meTableView){
        _meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UI_SCREEN_WIDTH, pixelValue(600))];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        _meTableView.backgroundColor = [UIColor whiteColor];
        _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _meTableView.showsVerticalScrollIndicator = NO;
        _meTableView.scrollEnabled = NO;
    }
    return _meTableView;
}

#pragma mark - 跳转个人资料
-(void)click_arrowButton{
    JYPersonalInformationViewController *personalInformation = [JYPersonalInformationViewController new];
    personalInformation.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalInformation animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.meTableView indexPathForSelectedRow];
    if(selected) [self.meTableView deselectRowAtIndexPath:selected animated:NO];
}

@end
