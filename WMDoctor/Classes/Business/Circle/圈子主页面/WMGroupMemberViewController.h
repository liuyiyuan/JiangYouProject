//
//  WMGroupMemberViewController.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/19.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMGroupMemberViewController : WMBaseViewController
@property (nonatomic ,strong) NSString *groupID;//群组ID
@property (nonatomic, strong) NSMutableArray *groupMembers;
@end
