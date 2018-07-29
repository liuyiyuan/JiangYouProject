//
//  JYMineModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JYWorkModel : JSONModel

@property(nonatomic, strong)NSString *workId;
@property(nonatomic, strong)NSString *workName;

@end

@protocol JYWorkModel;
@interface JYMineModel : JSONModel

@property(nonatomic, strong)NSArray<JYWorkModel> *workId;

@end
