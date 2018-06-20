//
//  WMStarView.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMStarView : UIView


/**
 星星的值（值在0至5之间。）
 */
@property (nonatomic,assign) float starValue;

/**
 开关显示值
 */
@property (nonatomic,assign) BOOL openValue;

@property (nonatomic,strong) UILabel * ValueLabel;

@end
