//
//  JYHomeBeautyPictureHotManager.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPictureHotManager.h"

@implementation JYHomeBeautyPictureHotManager
- (NSString *)methodName{
    return @"/mobile/beautyPhoto/hotRecommend";
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
