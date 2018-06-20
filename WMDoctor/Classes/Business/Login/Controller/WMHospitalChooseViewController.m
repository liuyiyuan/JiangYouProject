//
//  WMHospitalChooseViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMHospitalChooseViewController.h"
#import "WMGetHospitalAPIManager.h"
#import "WMGetHospitalModel.h"
#import "WMSectionChooseViewController.h"

@interface WMHospitalChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _leftTableView;
    UITableView * _rightTableView;
    
    NSString * _yingsheBM;
}

@property (nonatomic,strong) NSMutableArray * leftListArray;

@property (nonatomic,strong) NSMutableArray * rightListArray;

@end

@implementation WMHospitalChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"医院";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupView];
    [self setupData];
    // Do any additional setup after loading the view.
}
-(void)setupData{
    [self loadNetwork];
  
}
-(void)loadNetwork{
    __weak typeof(self) weakself = self;
    WMGetHospitalAPIManager *getHospitalAPIManager=[[WMGetHospitalAPIManager alloc] init];
    //NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"",@"",@"", nil];
    [getHospitalAPIManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.leftListArray=[[NSMutableArray alloc]initWithCapacity:0];
        WMGetHospitalModel *hospitalModel=[[WMGetHospitalModel alloc] initWithDictionary:responseObject error:nil];
        for (WMGetHospitalDetailModel *model in hospitalModel.regionHospitalVoList) {
            
            [self.leftListArray addObject:model];
        }
        [_leftTableView reloadData];
        if (_leftListArray.count == 0) {
            
            //[weakself showZanWuBackgroundView];
            //[CommonUtil showBackgroundView:@"ic_zanwu" title:nil tableView:_leftTableView];
        }else{
            [weakself moren];
        }

        
        NSLog(@"responseObject==%@",responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
    
}

#pragma mark - View Layout
- (void)setupView
{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 157/375.0 * kScreen_width, kScreen_height-SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _leftTableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(157/375.0 * kScreen_width, 0, 218/375.0 * kScreen_width, kScreen_height-SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.separatorColor = [UIColor clearColor];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;
    //_rightTableView.tableHeaderView = [[UIView alloc]init];
    [self.view addSubview:_rightTableView];
    
    
    
}
#pragma mark - All Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTableView) {
        return [self.leftListArray count];
    }
    
    return [self.rightListArray count];
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
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView) {
        WMGetHospitalDetailModel *model=_leftListArray[indexPath.row];
        static  NSString  * identifier = @"cell";
        UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.text=model.name;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"3d93ea"];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView=[self leftCellBgView];
        
        return cell;
        
    }else{
        WMHospitalDetailModel *model=_rightListArray[indexPath.row];
        static  NSString  * identifier = @"cell";
        UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text=model.name;
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1f1f1f"];
        cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"3d93ea"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView=[self rightCellBgView];
        return cell;
        
    }
    
}
-(UIView *)rightCellBgView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, _rightTableView.frame.size.width, 50);
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
}
-(UIView *)leftCellBgView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, _leftTableView.frame.size.width, 50);
    view.backgroundColor=[UIColor whiteColor];
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_xuanzhong"]];
    image.frame=CGRectMake(5, 21, 8, 8);
    [view addSubview:image];
    return  view;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _leftTableView) {
        
        self.rightListArray=[[NSMutableArray alloc] initWithCapacity:0];
        WMGetHospitalDetailModel * hospitalDetailModel = _leftListArray[indexPath.row];
        
        for (WMHospitalDetailModel *model in hospitalDetailModel.hospitalVoList) {
            
            [_rightListArray addObject:model];
        }
        
        [_rightTableView reloadData];
    }
    if (tableView == _rightTableView) {
        
        
        WMHospitalDetailModel *model=_rightListArray[indexPath.row];
        
        WMSectionChooseViewController *sectionChooseVC=[[WMSectionChooseViewController alloc] init];
        sectionChooseVC.hosName=model.name;
        sectionChooseVC.organizationCode=model.organizationCode;
        sectionChooseVC.isInfo = self.isInfo;
        sectionChooseVC.save_model = self.save_model;
        [self.navigationController pushViewController:sectionChooseVC animated:YES];
        
    }
    
}

- (void)moren
{
    NSIndexPath  *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView selectRowAtIndexPath:indexP animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self tableView:_leftTableView didSelectRowAtIndexPath:indexP];
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
