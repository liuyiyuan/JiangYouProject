//
//  WMSearchPatientAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/5/24.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMSearchPatientAPIManager.h"

@implementation WMSearchPatientAPIManager

-(NSString *)methodName
{
    return @"/circle/patients_search";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMTagGroupModel class];
}
- (LoadingEffertType)loadingEffertType{
    
    return LoadingEffertTypeDefault;
    
}

@end
