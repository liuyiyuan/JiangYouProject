//
//  WMDynamicModuleView.h
//  Micropulse
//
//  Created by airende on 2017/1/5.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMIndexDataModel.h"

@protocol WMDynamicModuleViewDelegate <NSObject>

@required

- (void)clickYingYongEntran:(HomeAppModel *)model;

@end


@interface WMDynamicModuleView : UIView

@property (nonatomic, weak) id<WMDynamicModuleViewDelegate> delegate;

@property (nonatomic, assign) CGFloat viewHeight;

- (void)moduleViewMakeViewWithArray:(NSArray *)modelArray;

@end
