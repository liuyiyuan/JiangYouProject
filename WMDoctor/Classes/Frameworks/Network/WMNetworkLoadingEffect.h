//
//  WMNetworkLoadingEffect.h
//  Micropulse
//
//  Created by zhangchaojie on 16/4/1.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMNetworkConfig.h"


/**
 * 网络loading控制类
 */
@interface WMNetworkLoadingEffect : NSObject

- (void)addLoadingEffectWith:(LoadingEffertType)type;

- (void)removeLoadingEffectWith:(LoadingEffertType)type;

@end
