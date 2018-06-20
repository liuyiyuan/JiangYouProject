//
//  WMUpgradecheckModel.h
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMUpgradecheckModel : WMJSONModel

@property (nonatomic,copy) NSString *minVersion;
@property (nonatomic,copy) NSString *upgradeInfo;
@property (nonatomic,copy) NSString *currVersion;
@property (nonatomic,copy) NSString *downloadUrl;

@end
