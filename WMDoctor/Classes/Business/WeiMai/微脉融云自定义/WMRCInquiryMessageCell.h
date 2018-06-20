//
//  WMRCInquiryMessageCell.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#define WMRCInquiryMessageCellIndex @"WMRCInquiryMessageCellIndex"

@interface WMRCInquiryMessageCell : RCMessageCell
{
    CGFloat _imageWide;//图片的宽度（以图片的宽来确定图片高）
    CGFloat _imageHigh;//图片的高度
    CGFloat _scale_wide_high;//图片宽高比
}
//文字展示视图 （宽高不一致）
@property (nonatomic ,strong)UIView *textMessageView;
//图片展示试图 （宽高不一致）
@property (nonatomic ,strong)UIView *pictureView;

@property (nonatomic ,strong)UILabel *acceptMessageLabel;
@property (nonatomic ,strong)UILabel *giveOutMessageLabel;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
@end
