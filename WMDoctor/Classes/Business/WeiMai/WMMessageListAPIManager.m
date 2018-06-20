//
//  WMMessageListAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMessageListAPIManager.h"
#import "WMMessageListModel.h"
@implementation WMMessageListAPIManager
-(NSString *)methodName
{
    return URL_GET_MESSAGELIST;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMMessageListModel class];
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
