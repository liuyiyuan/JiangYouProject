//
//  WMMedicalCircleAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/5/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMMedicalCircleAPIManager.h"
#import "WMCricleGroupModel.h"

@implementation WMMedicalCircleAPIManager

- (NSString *)methodName{
    return @"/circle/doctor_patient_groups";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

-(Class)classType{
    
    return [WMMedicalCircleModel class];
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
