//
//  WMReplyMessageCell.h
//  WMDoctor
//
//  Created by xugq on 2018/3/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface WMReplyMessageCell : RCMessageCell
{
    CGFloat _imageWide;//图片的宽度（以图片的宽来确定图片高）
    CGFloat _imageHigh;//图片的高度
    CGFloat _scale_wide_high;//图片宽高比
}

/*!
 回复对象姓名
 */
@property(strong, nonatomic) UILabel *replyObjNamLab;

/*!
 回复问题
 */
@property(strong, nonatomic) UILabel *replyQuestionLab;

/*!
 回复内容
 */
@property(strong, nonatomic) UILabel *replyContentLab;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIView *bottomLine;

@end
