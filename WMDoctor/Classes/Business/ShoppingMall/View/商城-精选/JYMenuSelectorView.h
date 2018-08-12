//
//  JYMenuSelectorView.h
//  WMDoctor
//
//  Created by xugq on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYMenuSelectorViewDelegate <NSObject>

@optional
- (void)menuSelectorViewClick:(NSInteger)index;

@end

@interface JYMenuSelectorView : UIView

@property(nonatomic, assign)id<JYMenuSelectorViewDelegate> delegate;
- (void)setMenuWithArr:(NSArray *)arr;

@end
