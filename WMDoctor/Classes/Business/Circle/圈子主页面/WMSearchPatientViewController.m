//
//  WMSearchPatientViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/5/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMSearchPatientViewController.h"
#import "WMSearchPatientCell.h"
#import "UISearchBar+WMLeftPlaceholder.h"
#import "WMSearchPatientAPIManager.h"
#import "WMRCDataManager.h"
#import "WMRCConversationViewController.h"
#import "WMPatientDataViewController.h"

@interface WMSearchPatientViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    UITableView  *_tableView;
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, assign) NSInteger pageNo;
@property(nonatomic, strong) WMTagGroupModel *patientGroupModel;
@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WMSearchPatientViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if (_searchBar) {
        [self.navigationController.view addSubview:_searchBar];
    }
    if (_tableView) {
        [_tableView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"18A2FF"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_searchBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self setupData];
    [self initHeaderView];
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self setupView];
}

- (void)setupData{
    self.pageNo = 1;
    self.dataSource = [NSMutableArray new];
}

- (void)initHeaderView{
    
    self.view.backgroundColor = [UIColor redColor];
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, SafeAreaTopHeight - 34, kScreen_width - 58 - 15, 27)];
    _searchBar.delegate= self;
    _searchBar.barTintColor = [UIColor whiteColor];//外色
    [_searchBar setLeftPlaceholder:@"输入关键词搜索患者"];
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.layer.cornerRadius = _searchBar.height/2.0;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setImage:[UIImage imageNamed:@"ic_sousuo"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected|UIControlStateNormal];
    [_searchBar.layer setBorderWidth:0.8];
    [_searchBar.layer setBorderColor:[UIColor colorWithHexString:@"dedede"].CGColor];
    [_searchBar becomeFirstResponder];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"F3F5F9"];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithHexString:@"f3f5f9"];
    [self.navigationController.view addSubview:_searchBar];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(rightNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = cancelBtnItem;
    
    UIButton *backBtn = [[UIButton alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupView{
        
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreen_width, kScreen_height - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorColor=[UIColor colorWithHexString:@"E8E8E8"];
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    _tableView.mj_footer = footer;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMPatientModel *patient = self.dataSource[indexPath.row];
    WMSearchPatientCell *patientCell = (WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!patientCell) {
        patientCell = [[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
    }
    [patientCell searchPaitentVCSetValueWithWMPatientModel:patient andSearchKeyWord:_searchBar.text];
    return patientCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMPatientModel *patient = self.dataSource[indexPath.row];
    //跳转到患者资料页
    WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
    patientDataViewController.userId = [NSString stringWithFormat:@"%@", patient.weimaihao];
    patientDataViewController.tagPatientModel = patient;
    [self.navigationController pushViewController:patientDataViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)rightNavBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

//注意：如果View controller-based status bar appearance为YES。则[UIApplication sharedApplication].statusBarStyle 无效。需重写此方法
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.pageNo = 1;
    [self loadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

- (void)loadData{
    [_searchBar resignFirstResponder];
    if (stringIsEmpty(_searchBar.text)) {
        return;
    }
    WMSearchPatientAPIManager *searchPatientAPIManager = [[WMSearchPatientAPIManager alloc] init];
    NSDictionary *param = @{
                            @"keywords" : _searchBar.text,
                            @"pageNum"  : [NSString stringWithFormat:@"%ld", self.pageNo],
                            @"pageSize" : @"10"
                            };
    [searchPatientAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.patientGroupModel = (WMTagGroupModel *)responseObject;
        if (self.pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        [self.dataSource addObjectsFromArray:self.patientGroupModel.patients];
        if (self.dataSource.count == 0) {
            [_tableView showBackgroundView:@"没有相关患者" type:BackgroundTypeSearchNoPatient];
            _tableView.mj_footer.hidden = YES;
        }
        if (self.patientGroupModel.patients.count < 10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.pageNo ++;
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"搜索患者error : %@", errorResult);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
