//
//  JYHomeBBSHotManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSHotManager.h"

@implementation JYHomeBBSHotManager

- (NSString *)methodName{
    return @"/mobile/bbs/hotRecommend";
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
