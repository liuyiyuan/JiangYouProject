//
//  WMSchoolSelectViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMEducationCustomModel.h"

@interface WMSchoolSelectViewController : WMBaseViewController

@property (nonatomic,strong) WMEducationCustomModel * customModel;
@property (nonatomic,copy) NSString * areaStrCode;

@end
