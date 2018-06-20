//
//  WMReportDetailManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportDetailManager.h"
#import "WMReportDetailModel.h"

@implementation WMReportDetailManager
-(NSString *)methodName
{
    return URL_GET_TANXIN_REPORTDETAIL;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    return [WMReportDetailModel class];
}
@end
