//
//  WMAllReportListModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMAllReportListModelItems;
@interface WMAllReportListModelItems : WMJSONModel

@property (nonatomic,copy) NSString * advice;

@property (nonatomic,copy) NSString * age;

@property (nonatomic,copy) NSString * bdate;

@property (nonatomic,copy) NSString * bluenum;

@property (nonatomic,copy) NSString * enquire;

@property (nonatomic,copy) NSString * fname;

@property (nonatomic,copy) NSString * mid;

@property (nonatomic,copy) NSString * page;

@property (nonatomic,copy) NSString * pdate;

@property (nonatomic,copy) NSString * pname;

@property (nonatomic,copy) NSString * ppid;

@property (nonatomic,copy) NSString * score;

@property (nonatomic,copy) NSString * tlong;

@property (nonatomic,copy) NSString * tname;

@property (nonatomic,copy) NSString * udate;

@property (nonatomic,copy) NSString * uid;

@end

@protocol WMAllReportListModel;
@interface WMAllReportListModels : WMJSONModel

@property (nonatomic,copy) NSString * errmsg;

@property (nonatomic,strong) NSArray<WMAllReportListModelItems,Optional> * items;

@property (nonatomic,copy) NSString * pagecount;

@property (nonatomic,copy) NSString * records;

@end

@interface WMAllReportListModel : WMJSONModel

@property (nonatomic,strong) WMAllReportListModels<Optional> * allReportsResult;

@end
