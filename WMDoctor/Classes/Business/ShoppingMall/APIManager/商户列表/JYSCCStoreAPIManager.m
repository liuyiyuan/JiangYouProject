//
//  JYSCCStoreAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSCCStoreAPIManager.h"

@implementation JYSCCStoreAPIManager

- (NSString *)methodName{
    return @"/pro/getSelectedList.jspx";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeDefault;
}

- (HTTPPortType)portType{
    return Port_Jeecmsv;
}

@end
