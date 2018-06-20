//
//  WMIMGroupModel.h
//  WMDoctor
//
//  Created by xugq on 2017/8/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WMIMGroupModel : JSONModel

@property(nonatomic, copy)NSString *groupName;
@property(nonatomic, copy)NSString *groupPicture;

@end
