//
//  WMGetPatientCommentsAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetPatientCommentsAPIManager.h"
#import "WMPatientCommentsModel.h"

@implementation WMGetPatientCommentsAPIManager
-(NSString *)methodName
{
    return @"/me/patient_comments";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

-(Class)classType{
    
    return [WMPatientCommentsNewModel class];
}

@end
