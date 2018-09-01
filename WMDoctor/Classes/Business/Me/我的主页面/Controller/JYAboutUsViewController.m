//
//  JYAboutUsViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYAboutUsViewController.h"
#import "JYAboutUsHeaderView.h"
#import "JYAboutUsTableViewCell.h"
#import "JYMeAboutUsContentCollectionViewController.h"
@interface JYAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)JYAboutUsHeaderView *headerView;

@property(nonatomic,strong)UITableView *tablView;

@end

@implementation JYAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tablView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(250);
    }];
    
    [self.tablView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(self.view.height - 250);
    }];
}



#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYAboutUsTableViewCell *cell = [[JYAboutUsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYAboutUsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        case 0:
            cell.versionLabel.hidden = YES;
            cell.typeLabel.text = @"关于我们";
            break;
        case 1:
        {
            cell.versionLabel.hidden = YES;
            cell.typeLabel.text = @"联系我们";
        }
            break;
        case 2:
            cell.versionLabel.hidden = NO;
            cell.typeLabel.text = @"当前版本号";
            break;

        default:
            break;
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    cell.selectedBackgroundView = backView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        JYMeAboutUsContentCollectionViewController *AboutUsContent = [JYMeAboutUsContentCollectionViewController new];
        [self.navigationController pushViewController:AboutUsContent animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
}


-(JYAboutUsHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYAboutUsHeaderView alloc]init];
    }
    return _headerView;
}


-(UITableView *)tablView{
    if(!_tablView){
        _tablView = [[UITableView alloc]init];
        
        _tablView.delegate = self;
        _tablView.dataSource = self;
        _tablView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tablView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tablView.showsVerticalScrollIndicator = NO;
        _tablView.scrollEnabled = NO;
    }
    return _tablView;
}
@end
