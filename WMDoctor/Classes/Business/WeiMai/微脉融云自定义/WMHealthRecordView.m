//
//  WMHealthRecordView.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMHealthRecordView.h"
#import "WMHealthRecordCell.h"
#import "WMPatientsHealthAPIManager.h"
#import "WMPatientsHealthParamModel.h"
#import "WMPatientsHealthModel.h"
@implementation WMHealthRecordView

- (id)initWithFrame:(CGRect)frame withDingdanhao:(NSString *)dingdanhao{
    self=[super initWithFrame:frame];
    if (self) {
        [self setupViewWithFrame:frame];
        [self setupData];
        [self loadDefaultDataWithDingdanhao:dingdanhao];
    }
    return self;
}
-(void)setupViewWithFrame:(CGRect)frame{
    self.tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.tableView];
    
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMPatientsHealthDetailModel *patientsHealthDetailModel=self.dataSource[indexPath.row];
    WMHealthRecordCell *newInfoMessag=(WMHealthRecordCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!newInfoMessag) {
        newInfoMessag=[[[NSBundle mainBundle]loadNibNamed:@"WMHealthRecordCell" owner:self options:Nil] lastObject];
    }
    [newInfoMessag setSelectionStyle:UITableViewCellSelectionStyleNone];
    [newInfoMessag setupViewWithDetailModel:patientsHealthDetailModel];
    return newInfoMessag;
    
    
    
}

-(void)loadDefaultDataWithDingdanhao:(NSString  *)dingdanhao{
    
    WMPatientsHealthParamModel *patientsHealthParamModel=[[WMPatientsHealthParamModel alloc]init];
    patientsHealthParamModel.dingdanhao=dingdanhao;
    //patientsHealthParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    //patientsHealthParamModel.pageSize=kPAGEROW;
    
    WMPatientsHealthAPIManager *patientsHealthAPIManager=[[WMPatientsHealthAPIManager alloc]init];
    
    [WMHUDUntil showWhiteLoadingToView:self];
    
    [patientsHealthAPIManager loadDataWithParams:patientsHealthParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [WMHUDUntil hideHUDForView:self];
        NSLog(@"responseObject=%@",responseObject);
        WMPatientsHealthModel *messageTypeModel=(WMPatientsHealthModel *)responseObject;
        
        
        [_dataSource removeAllObjects];
        
        [self.dataSource addObjectsFromArray:messageTypeModel.health];
        if (_dataSource.count == 0) {
            NSLog(@"最后一页");
            _tableView.mj_footer.hidden = YES;
            [_tableView showBackgroundView:@"暂无数据" type:BackgroundTypeEmpty];
        }
        
        else {
            _tableView.backgroundView = nil;
        }
        [_tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
        [WMHUDUntil hideHUDForView:self];
        if (_dataSource.count<=0) {
            [_tableView showBackgroundView:@"暂无数据" type:BackgroundTypeEmpty];
            //_loadingFailView.loadingLable.text=[error errorDescription];
            //[_loadingFailView showInView:self.view];
            
        }else{
            //[WMHUDUntil showFailWithMessage:[error errorDescription] toView:self.view.window];
        }
        
        
        
        
    }];
    
}
-(void)setupData{
    self.dataSource=[[NSMutableArray  alloc]initWithCapacity:0];
    
}

#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     动态判断cell 高度。
     WMNotificationMessageModel *notModel=self.dateSoureArr[indexPath.row];
     float  detailHeight=[UILabel heightForLabelWithText:notModel.ZHAIYAONR width:kScreen_width-50 font:[UIFont systemFontOfSize:14]];
     if (detailHeight<20) {
     
     return 315.f;
     
     }
     else {
     
     return 335.f;
     }
     */
    
    return 175;
}



@end
