//
//  JYHomeBBSChooseManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSChooseManager.h"

@implementation JYHomeBBSChooseManager
- (NSString *)methodName{
    return @"/mobile/bbs/specialRecommend";
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
