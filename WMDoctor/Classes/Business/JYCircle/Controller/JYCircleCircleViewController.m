//
//  JYCircleDynamicViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleCircleViewController.h"
#import "JYCircleCircleTableViewCell.h"
@interface JYCircleCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JYCircleCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, pixelValue(10), UI_SCREEN_WIDTH, self.view.frame.size.height);
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = pixelValue(380);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYCircleCircleTableViewCell *cell = [[JYCircleCircleTableViewCell alloc]init];
    cell.focusButton.tag = indexPath.row;
    [cell.focusButton addTarget:self action:@selector(click_focusButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 关注按钮点击
-(void)click_focusButton:(UIButton*)button{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -60){
        NSLog(@"top*****");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CircleDynamicTop" object:nil];
    }else if(scrollView.contentOffset.y > 0){
        NSLog(@"bottom*****");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CircleDynamicUnTop" object:nil];
    }
}

@end
