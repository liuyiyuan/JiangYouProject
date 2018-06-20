//
//  UITableView+ListEmptyView.h
//  WMDoctor
//
//  Created by choice-ios1 on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ListEmptyView)

/**
 为tableview增加默认空视图<只有图>
 
 @param imgName 图片名字，必填
 */
- (void)showListEmptyView:(NSString *)imgName;

/**
 为tableview增加默认空视图<只有图文>

 @param imgName 图片名字，必填
 @param desc 文案内容，必填
 */
- (void)showListEmptyView:(NSString *)imgName
                    title:(NSString *)desc;


/**
 为tableview增加默认空视图<图文和引导页面跳转的按钮>

 @param imgName 图片名字，必填
 @param desc 文案内容，必填
 @param desc2 按钮文字，可为空
 @param block 点击事件回调，可为空，block内部不要出现self，需要用weak进行转换
 */
- (void)showListEmptyView:(NSString *)imgName
                    title:(NSString *)desc
              buttonTitle:(NSString *)desc2
               completion:(void(^)(UIButton* button))block;
/*
 __weak typeof(self) weakself = self;
 [self.tableView showListEmptyView:@"wm_im_xiaoxiquesheng" title:@"我是文案，最多支持两行" buttonTitle:@"点击页面跳转" completion:^(UIButton *button) {
 NSLog(@"跳转?=%@",button);
 
 }];
 */

/**
 移除默认的空视图

 @param needToChangeSeparator 是否改变分割线，默认传NO
 */
- (void)removeListEmptyViewForNeedToChangeSeparator:(BOOL)needToChangeSeparator;

@end
