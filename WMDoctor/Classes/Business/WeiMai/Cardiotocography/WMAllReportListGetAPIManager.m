//
//  WMAllReportListGetAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllReportListGetAPIManager.h"
#import "WMAllReportListModel.h"

@implementation WMAllReportListGetAPIManager
-(NSString *)methodName
{
    return URL_GET_TANXIN_ALLREPORT;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    return [WMAllReportListModel class];
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}
@end
