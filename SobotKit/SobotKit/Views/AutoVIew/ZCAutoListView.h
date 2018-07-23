//
//  ZCAutoListView.h
//  SobotKit
//
//  Created by zhangxy on 2018/1/22.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZCAutoListView : UIView



+(ZCAutoListView *) getAutoListView;


@property(nonatomic,copy) void(^CellClick)(NSString * text) ;

-(void)showWithText:(NSString *) searchText rect:(CGRect) f ;

-(void)dissmiss;

@end
