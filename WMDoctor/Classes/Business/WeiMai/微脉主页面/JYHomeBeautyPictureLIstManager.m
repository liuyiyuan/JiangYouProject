//
//  JYHomeBeautyPictureLIstManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPictureLIstManager.h"

@implementation JYHomeBeautyPictureLIstManager
- (NSString *)methodName{
    return @"/mobile/beautyPhoto/list";
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
