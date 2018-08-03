//
//  JYSCCHeadlineModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


/**
 商家-精选-头条model
 */
@interface JYSCCHeadlineModel : WMJSONModel

@property(nonatomic, strong)NSString *image_info;
@property(nonatomic, strong)NSString *image_infoId;
@property(nonatomic, strong)NSString *image_url;

@end
