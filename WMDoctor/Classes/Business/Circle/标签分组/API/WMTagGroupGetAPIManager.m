//
//  WMTagGroupGetAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/23.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagGroupGetAPIManager.h"

@implementation WMTagGroupGetAPIManager

- (NSString *)methodName{
    return @"/patient_user/tag";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
