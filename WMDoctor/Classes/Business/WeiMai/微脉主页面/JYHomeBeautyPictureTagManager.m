//
//  JYHomeBeautyPictureTagManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPictureTagManager.h"

@implementation JYHomeBeautyPictureTagManager

- (NSString *)methodName{
    return @"/mobile/beautyPhoto/title";
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
