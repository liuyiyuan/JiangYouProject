//
//  WMGroupInfoViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/3/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMGroupInfoViewController : WMBaseViewController
@property (nonatomic ,strong) NSString *groupID;//群组ID
@property (nonatomic, strong) NSMutableArray *groupMembers;
@end
