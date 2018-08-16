//
//  JYNewestStoreModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYStoreModel : WMJSONModel

@property(nonatomic, strong)NSString *merId;
@property(nonatomic, strong)NSString *merName;

@end

@protocol JYStoreModel;
@interface JYNewestStoreModel : WMJSONModel

@property(nonatomic, strong)JYStoreModel *merchant;

@end
