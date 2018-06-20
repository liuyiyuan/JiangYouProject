//
//  WMRecommendDocViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
/**
 * 向用户推荐医生的试图
 **/
@interface WMRecommendDocViewController : WMBaseViewController
//用于传递发送名片的对象。
@property (nonatomic ,copy)NSString *targetIdStr;
@property (nonatomic ,copy)NSString *officeId;
@property (nonatomic ,copy)NSString *titleName;
@property (nonatomic ,copy)NSString *dingdanhao;

@end
