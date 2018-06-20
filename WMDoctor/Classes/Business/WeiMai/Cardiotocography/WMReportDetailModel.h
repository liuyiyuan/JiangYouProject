//
//  WMReportDetailModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@protocol WMReportDetailModelDesc;
@interface WMReportDetailModelDesc : WMJSONModel

@property (nonatomic,copy) NSString * advice;   //医生医嘱

@property (nonatomic,copy) NSString<Optional> * doctor;   //医生姓名

@property (nonatomic,copy) NSString<Optional> * date;

@end


@interface WMReportDetailModelSc : WMJSONModel

@property (nonatomic,strong) NSArray<Optional> * sc4;

@property (nonatomic,copy) NSString<Optional> * scorer;

@end



@interface WMReportDetailModelData : WMJSONModel

@property (nonatomic,copy) NSString * begindate;

@property (nonatomic,strong) NSArray<WMReportDetailModelDesc,Optional> * desc;

@property (nonatomic,copy) NSString<Optional> * enquire;

@property (nonatomic,copy) NSString * fhrpath;

@property (nonatomic,copy) NSString * isshow;

@property (nonatomic,copy) NSString * mid;

@property (nonatomic,copy) NSString * pname;

@property (nonatomic,copy) NSString<Optional> * puid;

@property (nonatomic,strong) WMReportDetailModelSc<Optional> * sc;

@property (nonatomic,copy) NSString * score;

@property (nonatomic,copy) NSString * sort;

@property (nonatomic,copy) NSString * timelong;

@property (nonatomic,copy) NSString * uid;

@property (nonatomic,copy) NSString * uploaddate;

@property (nonatomic,copy) NSString * wavpath;


///
@property (nonatomic,copy) NSString * expectedDate;

@property (nonatomic,copy) NSString<Optional> * name;

@property (nonatomic,copy) NSString<Optional> * phone;

@property (nonatomic,copy) NSString<Optional> * scoringDetails;

@property (nonatomic,copy) NSString * sendTime;

@property (nonatomic,copy) NSString * age;

@property (nonatomic,copy) NSString<Optional> * medicalhistory;

@end

//@protocol WMReportDetailModelResult;
@interface WMReportDetailModelResult : WMJSONModel

@property (nonatomic,strong) WMReportDetailModelData * data;

@property (nonatomic,copy) NSString * errmsg;

@end

@interface WMReportDetailModel : WMJSONModel



@property (nonatomic,strong) WMReportDetailModelResult * detailsResult;



@end
