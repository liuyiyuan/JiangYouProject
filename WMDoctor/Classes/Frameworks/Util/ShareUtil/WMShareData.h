//
//  WMShareData.h
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUpgradecheckModel.h"

@interface WMShareData : NSObject

+ (WMShareData *)shareInstance;


/**
 * 升级用户model
 */
@property (nonatomic,copy) WMUpgradecheckModel * upgradeModel;

@end
