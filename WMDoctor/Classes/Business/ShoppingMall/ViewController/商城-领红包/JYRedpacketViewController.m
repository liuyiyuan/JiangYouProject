//
//  JYRedpacketViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYRedpacketViewController.h"
#import "JYRedpacketBGCell.h"
#import "JYRedpacketItemCell.h"
#import "JYRedpacketItemViewController.h"

@interface JYRedpacketViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation JYRedpacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView{
    self.title = @"商户详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYRedpacketBGCell class]) bundle:nil] forCellReuseIdentifier:@"JYRedpacketBGCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYRedpacketItemCell class]) bundle:nil] forCellReuseIdentifier:@"JYRedpacketItemCell"];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYStoreCouponCell class]) bundle:nil] forCellReuseIdentifier:@"JYStoreCouponCell"];
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSetMealCell class]) bundle:nil] forCellReuseIdentifier:@"JYSetMealCell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYRedpacketBGCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYRedpacketBGCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1){
        JYRedpacketItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYRedpacketItemCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 566.f;
    } else if (indexPath.section == 1){
        return 156.f;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYRedpacketItemViewController *redpacketItemViewController = [[JYRedpacketItemViewController alloc] init];
    [self.navigationController pushViewController:redpacketItemViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
