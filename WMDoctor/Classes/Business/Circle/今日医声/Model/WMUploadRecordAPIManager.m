//
//  WMUploadRecordAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/10/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMUploadRecordAPIManager.h"

@implementation WMUploadRecordAPIManager
-(NSString *)methodName
{
    return @"/doctor_sound/preservation_record";
}

- (HTTPMethodType)requestType
{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
@end
