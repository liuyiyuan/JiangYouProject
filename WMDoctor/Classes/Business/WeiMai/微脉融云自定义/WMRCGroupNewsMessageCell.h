//
//  WMRCGroupNewsMessageCell.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
/**
 * 该cell用于展示群组的 咨询 活动 专题
 **/
@interface WMRCGroupNewsMessageCell : RCMessageCell
{
    CGFloat _CardWide;//名片宽度
    CGFloat _CardHigh;//名片高度
    
    CGFloat title_height;//title高度
    CGFloat detail_height;//detailLabel高度
}
/*!
 title
 */
@property(strong, nonatomic) UILabel *titleLabel;
/*!
 card展示
 */
@property(strong, nonatomic) UILabel *detailLabel;


/*!
 图片展示
 */
@property(strong, nonatomic) UIImageView *showImageView;


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
