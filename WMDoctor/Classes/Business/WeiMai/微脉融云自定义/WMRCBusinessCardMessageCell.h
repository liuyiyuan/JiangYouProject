//
//  WMRCBusinessCardMessageCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
/*!
 名片消息Cell
 */

@interface WMRCBusinessCardMessageCell : RCMessageCell
{
    CGFloat _CardWide;//名片宽度
    CGFloat _CardHigh;//名片高度
}
/*!
 title展示
 */
@property(strong, nonatomic) UILabel *titleLabel;
/*!
 hospital展示
 */
@property(strong, nonatomic) UILabel *hospitalLabel;
/*!
 name展示
 */
@property(strong, nonatomic) UILabel *nameLabel;
/*!
 科室展示
 */
@property(strong, nonatomic) UILabel *departmentLabel;
/*!
 card展示
 */
@property(strong, nonatomic) UILabel *cardLabel;


/*!
 图片展示
 */
@property(strong, nonatomic) UIImageView *headImageView;


/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
//+ (CGSize)getBubbleBackgroundViewSize:(WMRCRichMessage *)message;

@end
