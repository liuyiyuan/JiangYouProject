//
//  WMMessageTypeAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMessageTypeAPIManager.h"
#import "WMMessageTypeModel.h"
@implementation WMMessageTypeAPIManager
-(NSString *)methodName
{
    return URL_GET_MESSAGETYPE;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMMessageTypeModel class];
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
