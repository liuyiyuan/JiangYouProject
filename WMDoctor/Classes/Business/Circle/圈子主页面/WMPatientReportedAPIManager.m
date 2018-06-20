//
//  WMPatientReportedAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/26.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMPatientReportedAPIManager.h"
#import "WMPatientReportedModel.h"
@implementation WMPatientReportedAPIManager
-(NSString *)methodName
{
    return @"/circles/groups/patients";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMPatientReportedDataModel class];
}
@end
