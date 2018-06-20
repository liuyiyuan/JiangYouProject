//
//  WMCostomAdviceModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

#import "WMReportDetailModel.h"



@interface WMCostomAdviceModel : WMJSONModel

@property (nonatomic,copy) NSString * desc;

@property (nonatomic,copy) NSString * mid;

@property (nonatomic,assign) int score;

@property (nonatomic,strong) WMReportDetailModelSc<Optional> * scdetail;

@end


@interface WMCostomAdviceModels : WMJSONModel

@property (nonatomic,strong) WMCostomAdviceModel * report;

@end
