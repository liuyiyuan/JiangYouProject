//
//  WMHomeModuleView.h
//  Micropulse
//
//  Created by airende on 2016/12/23.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMIndexDataModel.h"

@protocol WMHomeModuleDelegate <NSObject>

@optional
- (void)clickModule:(NSInteger)index;

@end

@interface WMHomeModuleView : UIView

@property(nonatomic, weak) id<WMHomeModuleDelegate> delegate;

- (void)setValueWithModelArray:(NSArray *)images andTitleArr:(NSArray *)titles;

@end
