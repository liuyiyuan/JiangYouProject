//
//  JYBannerModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYSomeOneBanner : WMJSONModel

@property (nonatomic,copy) NSString <Optional> *linkParam;//参数（id）
@property (nonatomic,copy) NSString <Optional> *linkType;//链接类型
@property (nonatomic,copy) NSString <Optional> *picUrl;//图片路径

@end


@protocol JYSomeOneBanner;

/**
 商家-精选-轮播图model
 */
@interface JYBannerModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYSomeOneBanner> *sowingMapArray;

@end
