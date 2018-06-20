//
//  WMTagPatientAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/5/21.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagPatientAPIManager.h"

@implementation WMTagPatientAPIManager

- (NSString *)methodName{
    return @"/circle/tag_group_patients";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
