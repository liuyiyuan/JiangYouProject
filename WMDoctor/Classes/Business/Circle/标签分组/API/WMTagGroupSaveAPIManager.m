//
//  WMTagGroupSaveAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/24.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagGroupSaveAPIManager.h"

@implementation WMTagGroupSaveAPIManager

- (NSString *)methodName{
    return @"/patient_user/tag";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
