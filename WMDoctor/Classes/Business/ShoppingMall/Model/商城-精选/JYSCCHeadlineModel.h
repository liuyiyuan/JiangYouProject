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

@property(nonatomic, strong)NSString *imageinfo;
@property(nonatomic, strong)NSString *imageinfoId;
@property(nonatomic, strong)NSString *imageurl;

@end
