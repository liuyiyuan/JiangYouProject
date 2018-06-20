//
//  WMPatientDataAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/8/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientDataAPIManager.h"

@implementation WMPatientDataAPIManager

- (NSString *)methodName{
    return @"/patient_user/patient_user_information";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

@end
