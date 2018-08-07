//
//  JYWelfareView.m
//  WMDoctor
//
//  Created by xugq on 2018/8/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYWelfareView.h"
#import "JYSearchCell.h"
#import "JYWelfareCell.h"
#import "JYStoreBannerTableViewCell.h"
#import "JYStoreModuleCell.h"
#import "JYSCCHeadlineCell.h"
#import "JYWelfareListCell.h"

@interface JYWelfareView()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation JYWelfareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSearchCell class]) bundle:nil] forCellReuseIdentifier:@"JYSearchCell"];
    [_tableView registerClass:[JYWelfareCell class] forCellReuseIdentifier:@"JYWelfareCell"];
    [_tableView registerClass:[JYStoreBannerTableViewCell class] forCellReuseIdentifier:@"JYStoreBannerTableViewCell"];
    [_tableView registerClass:[JYStoreModuleCell class] forCellReuseIdentifier:@"JYStoreModuleCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSCCHeadlineCell class]) bundle:nil] forCellReuseIdentifier:@"JYSCCHeadlineCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYWelfareListCell class]) bundle:nil] forCellReuseIdentifier:@"JYWelfareListCell"];
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else if (section == 2){
        return 1;
    } else if (section == 3){
        return 1;
    } else if (section == 4){
        return 1;
    } else if (section == 5){
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSearchCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1){
        
        JYWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYWelfareCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 2){
        JYStoreBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreBannerTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3){
        JYStoreModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreModuleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 4){
        JYSCCHeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSCCHeadlineCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 5){
        JYWelfareListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYWelfareListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44.f;
    } else if (indexPath.section == 1){
        return 60.f;
    } else if (indexPath.section == 2){
        return 211.f;
    } else if (indexPath.section == 3){
        return 88.f;
    } else if (indexPath.section == 4){
        return 60.f;
    } else if (indexPath.section == 5){
        return 98.f;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
