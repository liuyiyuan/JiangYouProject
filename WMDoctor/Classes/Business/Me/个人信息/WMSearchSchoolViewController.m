//
//  WMSearchSchoolViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSearchSchoolViewController.h"
#import "WMSearchWordAPIManager.h"
#import "WMSchoolModel.h"
#import "WMTimeSelectViewController.h"
#import "WMProSelectViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface WMSearchSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UISearchBar * _searchBar;
    UITableView * _tableView;
    NSMutableArray * _allArr;
}
@end

@implementation WMSearchSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.fd_prefersNavigationBarHidden = YES;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, kScreen_width, 44)];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-44) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _searchBar.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
    
    [_searchBar.layer addSublayer:[CommonUtil backgroundColorInView:_searchBar andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:_tableView];
    [_searchBar becomeFirstResponder];
    _searchBar.placeholder = @"请输入学校名称";
    
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.showsCancelButton = YES;
    //设置搜索框的背景颜色
    _searchBar.barTintColor = [UIColor colorWithHexString:@"f9f9f9"];
    //一下代码为修改placeholder字体的颜色和大小
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    //修改搜索字体颜色
    searchField.textColor = [UIColor whiteColor];
    
    
    [self.view.layer addSublayer:[CommonUtil backgroundColorInView:self.view andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(viewTapped)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    //设置返回按钮为白色
    _searchBar.barTintColor = [UIColor whiteColor];
    
}

- (void)setupData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArr.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    
    _customModel.schoolId = ((WMSchoolModel *)_allArr[indexPath.row]).schoolId;
    if (![_customModel.schoolGrade isEqualToString:@"5"]) { //不是大学都不去专业选择页面
        _customModel.specialtyId = @"";
        WMTimeSelectViewController * goVC = [[WMTimeSelectViewController alloc]init];
        goVC.customModel = self.customModel;
        goVC.schoolName = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
        [self.navigationController pushViewController:goVC animated:YES];
        return;
    }
    WMProSelectViewController * goVC = [[WMProSelectViewController alloc]init];
    goVC.customModel = self.customModel;
    goVC.schoolName = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
    [self.navigationController pushViewController:goVC animated:YES];
    
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    [UIView animateWithDuration:0.1 animations:^{} completion:^(BOOL finished) {
        [_searchBar becomeFirstResponder];
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 1) {
        if (_allArr) {
            [_allArr removeAllObjects];
        }else{
            _allArr = [NSMutableArray array];
        }
        _tableView.backgroundView = nil;
        WMSearchWordAPIManager * apiManager = [[WMSearchWordAPIManager alloc]init];
        [apiManager loadDataWithParams:@{@"schoolName":[CommonUtil utf8WithString:searchBar.text],@"schoolGrade":self.customModel.schoolGrade} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            WMSchoolsModel * models = (WMSchoolsModel *)responseObject;
            if (models.schools.count <= 0) {
                [self noneBackgroundView];
            }
            for (WMSchoolModel * model in models.schools) {
                [_allArr addObject:model];
            }
            [_tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }else if (searchText.length == 0){
        if (_allArr) {
            [_allArr removeAllObjects];
        }
        [_tableView reloadData];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    _tableView.backgroundView = nil;
    WMSearchWordAPIManager * apiManager = [[WMSearchWordAPIManager alloc]init];
    [apiManager loadDataWithParams:@{@"schoolName":[CommonUtil utf8WithString:searchBar.text],@"schoolGrade":self.customModel.schoolGrade} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        WMSchoolsModel * models = (WMSchoolsModel *)responseObject;
        if (models.schools.count <= 0) {
            [self noneBackgroundView];
        }
        for (WMSchoolModel * model in models.schools) {
            [_allArr addObject:model];
        }
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (id searchbuttons in [[searchBar subviews][0]subviews]) //只需在此处修改即可
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitle:@"返回"forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    return [touch.view isKindOfClass:_tableView.class];
    return YES;
}

#pragma mark - CosomFunction

- (void)noneBackgroundView{
    UIView * backView = [[UIView alloc]initWithFrame:_tableView.bounds];
    
    UIImageView * theImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
    theImage.center = CGPointMake(kScreen_width/2, 40+80+64);
    
    UILabel * theLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 20)];
    theLabel.center = CGPointMake(kScreen_width/2, 230+64);
    theLabel.textAlignment = NSTextAlignmentCenter;
    
    theLabel.font = [UIFont systemFontOfSize:14];
    theLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    
    theImage.image = [UIImage imageNamed:@"me_school_none"];
    theLabel.text = @"暂无学校信息";
    
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    
    _tableView.backgroundView = backView;
}

//点击tableView收起键盘
- (void)viewTapped{
    [_searchBar resignFirstResponder];
}

//滑动TableView收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
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
