//
//  WMCricleHomeAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/8/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCricleHomeAPIManager.h"
#import "WMCricleGroupModel.h"

@implementation WMCricleHomeAPIManager

- (NSString *)methodName{
    return @"/circle/circle_information";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

-(Class)classType{
    
    return [WMCricleHomePageModel class];
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
