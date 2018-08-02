//
//  JYStoreBannerTableViewCell.h
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBannerModel.h"

@interface JYStoreBannerTableViewCell : UITableViewCell


/**
 根据bannermodel设置banner

 @param bannerModel <#bannerModel description#>
 */
- (void)setValueWithBannerModel:(JYBannerModel *)bannerModel;

@end
