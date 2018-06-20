//
//  WMReportListModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@protocol WMReportListModel;
@interface WMReportListModel : WMJSONModel

@property (nonatomic,copy) NSString * age;

@property (nonatomic,copy) NSString * expectedDate;

@property (nonatomic,copy) NSString * name;

@property (nonatomic,copy) NSString * phone;

//@property (nonatomic,copy) NSString * reportId;

@property (nonatomic,copy) NSString * score;

@property (nonatomic,copy) NSString * sendTime;

//@property (nonatomic,copy) NSString * customerId;

@property (nonatomic,copy) NSString * mid;

@property (nonatomic,copy) NSString * scoringDetails;

@end


@interface WMReportListModels : WMJSONModel

@property (nonatomic,strong) NSArray<WMReportListModel> * reportList;

@end
