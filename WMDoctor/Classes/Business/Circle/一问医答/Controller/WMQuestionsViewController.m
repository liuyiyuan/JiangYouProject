//
//  WMQuestionsViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/11/20.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionsViewController.h"
#import "WMQuestionsAPIManager.h"
#import "WMQuestionsCell.h"
#import "WMIntegralDetailViewController.h"
#import "WMQuestionStateAPIManager.h"
#import "WMQuestionDetailViewController.h"
#import "WMQuestionsSettingViewController.h"

@interface WMQuestionsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageNo;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation WMQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //iOS11 适配
    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//        self.additionalSafeAreaInsets = UIEdgeInsetsMake(88, 0, 0, 0);
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self setupData];
    [self setupView];
}

- (void)setupData{
    _pageNo = 1;
    self.dataSource = [NSMutableArray new];
    //通知 评价成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerSuccess:) name:@"answerSuccess" object:nil];
}

//立即解答
- (void)answerBtnClickAction:(UIButton *)button{
    WMQuestionModel *question = [self.dataSource objectAtIndex:button.tag];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
    WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
    questionDetailViewController.question = question;
    questionDetailViewController.hidesBottomBarWhenPushed = YES;
    questionDetailViewController.backTitle = @"返回";
    [self.navigationController pushViewController:questionDetailViewController animated:YES];
}

- (void)setupView{
    self.title = @"一问医答";
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0, 0, 80, 25);
    [rightBarBtn setTitle:@"消息提醒" forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBarBtn addTarget:self action:@selector(rightBarItemClickAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBarBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-SafeAreaTopHeight) style:UITableViewStyleGrouped];

    _tableView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMQuestionsCell class]) bundle:nil] forCellReuseIdentifier:@"WMQuestionsCell"];
    //刷新
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshData)];
    [_tableView.mj_header beginRefreshing];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadQuestionsData];
    }];
    _tableView.mj_footer = footer;
}

//明细
- (void)rightBarItemClickAction{
    
    WMQuestionsSettingViewController *questionsSettingViewController = [[WMQuestionsSettingViewController alloc] init];
    questionsSettingViewController.backTitle = @"";
    questionsSettingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:questionsSettingViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMQuestionModel *question = [self.dataSource objectAtIndex:indexPath.row];
    WMQuestionsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMQuestionsCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.answer.tag = indexPath.row;
    [cell.answer addTarget:self action:@selector(answerBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setValueWithQuestion:question];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMQuestionModel *question = [self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"question : %@", question);
    WMQuestionStateAPIManager *questionStateAPIManager = [[WMQuestionStateAPIManager alloc] init];
    NSDictionary *param = @{
                            @"questionId" : question.questionId
                            };
    [questionStateAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject != nil) {
            question.state = [responseObject objectForKey:@"state"];
        }
        if ([question.state intValue] == 2) {
            //被抢答
//            [WMHUDUntil showMessage:@"该问题已被其他医生抢答" toView:self.view];
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
            WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
            questionDetailViewController.question = question;
            questionDetailViewController.hidesBottomBarWhenPushed = YES;
            questionDetailViewController.backTitle = @"返回";
            [self.navigationController pushViewController:questionDetailViewController animated:YES];
        } else if ([question.state intValue] == 4){
            //已关闭
            [WMHUDUntil showMessage:@"该问题已过有效期，无法回答" toView:self.view];
        } else if ([question.state intValue] == 5){
            //抢答中
            [WMHUDUntil showMessage:@"该提问正在被其他医生抢答" toView:self.view];
        } else{
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
            WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
            questionDetailViewController.question = question;
            questionDetailViewController.hidesBottomBarWhenPushed = YES;
            questionDetailViewController.backTitle = @"返回";
            [self.navigationController pushViewController:questionDetailViewController animated:YES];
        }
        WMQuestionsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setValueWithQuestion:question];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"问题状态error ： %@", errorResult);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)headerRefreshData{
    _pageNo = 1;
    [self loadQuestionsData];
}

- (void)loadQuestionsData{
    WMQuestionsAPIManager *questionsAPIManager = [[WMQuestionsAPIManager alloc] init];
    NSDictionary *param = @{
                            @"pageNum" : [NSString stringWithFormat:@"%ld", _pageNo],
                            @"pageSize" : @"10"
                            };
    [questionsAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"一问医答数据 = %@", responseObject);
        if (_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        _pageNo ++;
        NSArray *list = [responseObject objectForKey:@"doctorAnswerVos"];
        for (NSDictionary *dic in list) {
            WMQuestionModel *question = [[WMQuestionModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:question];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([list count] < 10) {
            self.tableView.mj_footer = nil;
        }
        if ([self.dataSource count] == 0) {
            [self.tableView showListEmptyView:@"noQuestions" title:@"暂无提问"];
        }
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"一问医答error = %@", errorResult);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)answerSuccess:(NSNotification *)text{
    [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerSuccess" object:nil];
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
