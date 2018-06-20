//
//  UITableView+BackgroundView.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/21.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BackgroundTypeEmpty = 0,
    BackgroundTypeError,
    BackgroundTypeNetworkError,
    BackgroundTypeNOZiXun,
    BackgroundTypeNOTongZhi,
    BackgroundTypeNOTrade,
    BackgroundTypeNOPatient,
    BackgroundTypeNORecord,
    BackgroundTypeNODingdan,
    BackgroundTypeNOReport,
    BackgroundTypeNOUNReport,
    BackgroundTypeSearchNoPatient
} BackgroundType;

@interface UITableView (BackgroundView)
/*
 * 为tableview附加以下额外功能： 添加／删除空白背景、添加／删除错误背景、添加／删除无网络背景
 */
- (void)showBackgroundView:(NSString *)desc  type:(BackgroundType)backgroundType;
//设置Table背景图片
- (void)showBackgroundView:(NSString *)imgName title:(NSString *)desc;
- (void)removeBackgroundViewForNeedToChangeSeparator:(BOOL)needToChangeSeparator;
//以上功能提供footerView版，因为有的tableview 不合适
- (void)showFooterBackgroundView:(NSString *)desc type:(BackgroundType)backgroundType;
- (void)removeFooterBackgroundViewForTableView;

@end
