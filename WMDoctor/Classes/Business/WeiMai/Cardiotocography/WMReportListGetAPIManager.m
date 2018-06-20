//
//  WMReportListGetAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportListGetAPIManager.h"
#import "WMReportListModel.h"

@implementation WMReportListGetAPIManager
-(NSString *)methodName
{
    return URL_GET_TAIXIN_REPORTLIST;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    return [WMReportListModels class];
}

@end
