//
//  WMGuidePageViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@class WMGuidePageViewController;

@protocol selectDelegate <NSObject>
- (void)guideDoneClick:(WMGuidePageViewController *)selfVC;
@end

@interface WMGuidePageViewController : WMBaseViewController
@property (nonatomic, strong) UIImageView *btnEnter;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray * images;
// 版本信息判断
//- (BOOL)isShow;
@property (nonatomic, weak) id<selectDelegate> delegate;
@end
