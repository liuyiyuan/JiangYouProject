//
//  JYHomeVideoLunBoManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeVideoLunBoManager.h"

@implementation JYHomeVideoLunBoManager

- (NSString *)methodName{
    return @"/mobile/video/lunBo";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

- (HTTPPortType)portType{
    return Port_Jyqss;
}

@end
