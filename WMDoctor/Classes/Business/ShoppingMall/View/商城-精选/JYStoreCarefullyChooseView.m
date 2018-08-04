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
#import "JYStoreModuleCell.h"
#import "WMNewHotQuestionCell.h"
#import "JYSCCHeadlineCell.h"
#import "JYSCCGoodsCell.h"
#import "JYSCCGoodsAPIManager.h"
#import "JYSCCGoodsModel.h"

@interface JYStoreCarefullyChooseView()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
}

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)JYBannerModel *banner;
@property(nonatomic, strong)JYSCCHeadlineModel *headlineModel;
@property(nonatomic, assign)NSInteger pageNo;

@end

@implementation JYStoreCarefullyChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupView];
        [self loadBannerRequest];
        [self loadHeadlineRequest];
        [self loadGoodsRequest];
    }
    return self;
}

- (void)setupData{
    self.pageNo = 1;
    self.dataSource = [NSMutableArray array];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.width, self.height - 44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_tableView registerClass:[JYStoreBannerTableViewCell class] forCellReuseIdentifier:@"JYStoreBannerTableViewCell"];
    [_tableView registerClass:[JYStoreModuleCell class] forCellReuseIdentifier:@"JYStoreModuleCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSCCHeadlineCell class]) bundle:nil] forCellReuseIdentifier:@"JYSCCHeadlineCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSCCGoodsCell class]) bundle:nil] forCellReuseIdentifier:@"JYSCCGoodsCell"];
    
    
    [self addSubview:_tableView];
}

#pragma mark - All Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 3) {
        return 1;
    } else{
        return self.dataSource.count;
    }
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
    if (indexPath.section == 0) {
        return 147.f;
    } else if(indexPath.section == 1){
        return 69.f;
    } else if (indexPath.section == 2){
        return 46.f;
    } else{
        return 259.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        JYStoreBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreBannerTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.banner) {
            [cell setValueWithBannerModel:self.banner];
        }
        return cell;
    } else if (indexPath.section == 1){
        JYStoreModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreModuleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2){
        JYSCCHeadlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSCCHeadlineCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.headlineModel) {
            
        }
        return cell;
    } else if (indexPath.section == 3){
        JYSCCGoodsModel *goods = self.dataSource[indexPath.row];
        JYSCCGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSCCGoodsCell" forIndexPath:indexPath];
        [cell setValueWithGoodsModel:goods];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        self.headlineModel = [[JYSCCHeadlineModel alloc] initWithDictionary:responseObject error:nil];
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"headline error : %@", errorResult);
    }];
}

- (void)loadGoodsRequest{
    JYSCCGoodsAPIManager *goodsAPIManager = [[JYSCCGoodsAPIManager alloc] init];
    NSDictionary *param = @{
                            @"nowpagenum" : [NSString stringWithFormat:@"%ld", self.pageNo],
                            @"pagelimit" : @"10"
                            };
    [goodsAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"goods : %@", responseObject);
        for (NSDictionary *dic in responseObject) {
            JYSCCGoodsModel *goods = [[JYSCCGoodsModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:goods];
        }
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"goods error : %@", errorResult);
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
