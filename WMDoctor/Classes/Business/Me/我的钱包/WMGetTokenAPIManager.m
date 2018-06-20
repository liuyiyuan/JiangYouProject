//
//  WMGetTokenAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetTokenAPIManager.h"
#import "WMTokenModel.h"

@implementation WMGetTokenAPIManager
-(NSString *)methodName
{
    return @"/me/pay";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

-(Class)classType{
    
    return [WMTokenModel class];
}
@end
