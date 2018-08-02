//
//  JYCarefullyChooseBannerAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCarefullyChooseBannerAPIManager.h"

@implementation JYCarefullyChooseBannerAPIManager

- (NSString *)methodName{
    return @"/adv/mGetSowingImages.jspx";
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
