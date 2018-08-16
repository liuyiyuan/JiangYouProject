//
//  JYRedpacketItemsAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/16.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYRedpacketItemsAPIManager.h"

@implementation JYRedpacketItemsAPIManager

- (NSString *)methodName{
    return @"/red/shopRedPocketGet.jspx";
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
