//
//  WMAllReportGetPageParamModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMAllReportGetPageParamModel : WMJSONModel

@property (nonatomic,copy) NSString<Optional> * begin_date;

@property (nonatomic,copy) NSString<Optional> * end_date;

@property (nonatomic,copy) NSString<Optional> * p_uid;

@property (nonatomic,copy) NSString<Optional> * page_no;

@property (nonatomic,copy) NSString<Optional> * page_row;

@property (nonatomic,copy) NSString<Optional> * status;

@end
