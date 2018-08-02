//
//  JYStoreCarefullyChooseView.m
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreCarefullyChooseView.h"
#import "JYStoreBannerTableViewCell.h"
#import "JYStoreCarefullyChooseAPIManager.h"
#import "JYCarefullyChooseBannerAPIManager.h"
#import "JYBannerModel.h"
#import "JYSCCHeadlineAPIManager.h"
#import "JYSCCHeadlineModel.h"

@interface JYStoreCarefullyChooseView()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
}

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)JYBannerModel *banner;
@property(nonatomic, strong)JYSCCHeadlineModel *headlineModel;

@end

@implementation JYStoreCarefullyChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self loadBannerRequest];
        [self loadHeadlineRequest];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView registerClass:[JYStoreBannerTableViewCell class] forCellReuseIdentifier:@"JYStoreBannerTableViewCell"];
    
    [self addSubview:_tableView];
}

#pragma mark - All Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JYStoreBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreBannerTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.banner) {
            [cell setValueWithBannerModel:self.banner];
        }
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)loadStoreCarefullyChooseBannerRequest{
    
}

- (void)loadStoreCarefullyChooseRquest{
    JYStoreCarefullyChooseAPIManager *storeCarefullyChooseAPIManager = [[JYStoreCarefullyChooseAPIManager alloc] init];
    [storeCarefullyChooseAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"store carefullychoose request response : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"store carefullychoose request error : %@", errorResult);
    }];
}

- (void)loadBannerRequest{
    JYCarefullyChooseBannerAPIManager *bannerAPIManager = [[JYCarefullyChooseBannerAPIManager alloc] init];
    [bannerAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.banner = [[JYBannerModel alloc] initWithDictionary:responseObject error:nil];
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"banner error : %@", errorResult);
    }];
}

- (void)loadHeadlineRequest{
    JYSCCHeadlineAPIManager *headlineAPIManager = [[JYSCCHeadlineAPIManager alloc] init];
    [headlineAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"headline : %@", responseObject);
        JYSCCHeadlineModel *headlineModel = [[JYSCCHeadlineModel alloc] initWithDictionary:responseObject error:nil];
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"headline error : %@", errorResult);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
