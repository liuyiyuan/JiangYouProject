//
//  JYRedpacketDetailAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/16.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYRedpacketDetailAPIManager.h"

@implementation JYRedpacketDetailAPIManager

- (NSString *)methodName{
    return @"/pro/redPocketDetail.jspx";
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
