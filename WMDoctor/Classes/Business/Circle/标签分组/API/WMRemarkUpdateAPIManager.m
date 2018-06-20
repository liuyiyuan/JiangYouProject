//
//  WMRemarkUpdateAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMRemarkUpdateAPIManager.h"

@implementation WMRemarkUpdateAPIManager

- (NSString *)methodName{
    return @"/patient_user/remark";
}

- (HTTPMethodType)requestType{
    return Method_PUT;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
