//
//  WMReplyMessageCell.m
//  WMDoctor
//
//  Created by xugq on 2018/3/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMReplyMessageCell.h"
#import "WMReplyMessage.h"
#define Title_Message_Font_Size 14
#define Name_Message_Font_Size 12
#define Test_Message_Font_Size 16


#define Title_Color @"333333"
#define Name_Color @"999999"
@implementation WMReplyMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {

    WMReplyMessage *message = (WMReplyMessage *)model.content;
    
    CGSize size = [WMReplyMessageCell getBubbleBackgroundViewSize:message];
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    if (model.isDisplayMessageTime==YES) {
        return CGSizeMake(kScreen_width, __messagecontentview_height);
    }
    else{
        return CGSizeMake(kScreen_width, __messagecontentview_height);
    }

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {

    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];

    //name
    self.replyObjNamLab = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.replyObjNamLab setFont:[UIFont systemFontOfSize:Title_Message_Font_Size]];

    self.replyObjNamLab.numberOfLines = 0;
    [self.replyObjNamLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.replyObjNamLab setTextAlignment:NSTextAlignmentLeft];
    [self.replyObjNamLab setTextColor: [UIColor colorWithHexString:Title_Color]];//colorFromHexRGB:Title_Color]];
    [self.bubbleBackgroundView addSubview:self.replyObjNamLab];

    //title
    self.replyQuestionLab=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.replyQuestionLab setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];

    self.replyQuestionLab.numberOfLines = 0;
    [self.replyQuestionLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.replyQuestionLab setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.replyQuestionLab];


    self.replyContentLab=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.replyContentLab setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];
    
    self.replyContentLab.numberOfLines = 0;
    [self.replyContentLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.replyContentLab setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.replyContentLab];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleLongPressGestures:)];
    longPressGes.minimumPressDuration = 1.5f;
    [self.bubbleBackgroundView addGestureRecognizer:longPressGes];
}

//长按手势
- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    if ([self.delegate respondsToSelector:@selector(didLongTouchMessageCell:inView:)]) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    [self setAutoLayout];
}

- (void)setAutoLayout {
    //创建控件
    WMReplyMessage *replyMessage = (WMReplyMessage *)self.model.content;
    if (replyMessage) {
        self.replyObjNamLab.text = replyMessage.targetName;
        self.replyQuestionLab.text = replyMessage.targetContent;
        self.replyContentLab.text = replyMessage.replyMessage;
    }
    //消息内容的View
    CGRect messageContentViewRect = self.messageContentView.frame;

    [self.lineView removeFromSuperview];
    [self.bottomLine removeFromSuperview];
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接收
        [self.replyObjNamLab setTextColor:[UIColor colorWithHexString:Name_Color]];
        [self.replyQuestionLab setTextColor: [UIColor colorWithHexString:Name_Color]];
        [self.replyContentLab setTextColor:[UIColor colorWithHexString:Name_Color]];

        CGSize questionSize = [[self class] getQuestionSize:replyMessage];
        CGSize replyContentSize = [[self class] getReplyContentSize:replyMessage];
        CGSize replyObjNameSize = [[self class] getQuestionObjNameSize:replyMessage];
        float width1 = questionSize.width > replyContentSize.width? questionSize.width : replyContentSize.width;
        float width = width1 > replyObjNameSize.width ? width1 : replyObjNameSize.width;
        
        //回复View上左侧竖线
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 16, 1, 15 + questionSize.height)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
        [self.bubbleBackgroundView addSubview:self.lineView];
        
        //提问者姓名的位置
        self.replyObjNamLab.frame = CGRectMake(self.lineView.right + 7, 12, messageContentViewRect.size.width, 20);
        self.replyObjNamLab.font = [UIFont systemFontOfSize:12];
        self.replyObjNamLab.textColor = [UIColor colorWithHexString:@"999999"];
        
        //提问的问题的位置
        self.replyQuestionLab.frame = CGRectMake(self.lineView.right + 7, 33, questionSize.width, questionSize.height);
        self.replyQuestionLab.font = [UIFont systemFontOfSize:14];
        self.replyQuestionLab.textColor = [UIColor colorWithHexString:@"333333"];
        
        //回复View上 问题 与 回答中间的线
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.replyQuestionLab.bottom + 10, width + 28, 1)];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
        [self.bubbleBackgroundView addSubview:self.bottomLine];
        
        //回复的内容的位置
        self.replyContentLab.frame = CGRectMake(18, self.bottomLine.bottom + 10, replyContentSize.width, replyContentSize.height);
        self.replyContentLab.font = [UIFont systemFontOfSize:16];
        self.replyContentLab.textColor = [UIColor colorWithHexString:@"333333"];
        

        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = width;
        messageContentViewRect.size.height = questionSize.height + replyContentSize.height + 32 + 22 + 12;
        messageContentViewRect.origin.x = HeadAndContentSpacing + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10;
        self.messageContentView.frame = messageContentViewRect;
        self.messageContentView.frame = CGRectMake(messageContentViewRect.origin.x, messageContentViewRect.origin.y, messageContentViewRect.size.width, messageContentViewRect.size.height);
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, width + 35, messageContentViewRect.size.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];

    } else {
        //自己发消息
        [self.replyObjNamLab setTextColor:[UIColor colorWithHexString:Title_Color]];
        [self.replyQuestionLab setTextColor: [UIColor colorWithHexString:Title_Color]];
        [self.replyContentLab setTextColor:[UIColor colorWithHexString:Title_Color]];


        CGSize questionSize = [[self class] getQuestionSize:replyMessage];
        CGSize replyContentSize = [[self class] getReplyContentSize:replyMessage];
        CGSize replyObjNameSize = [[self class] getQuestionObjNameSize:replyMessage];
        float width1 = questionSize.width > replyContentSize.width? questionSize.width : replyContentSize.width;
        float width = width1 > replyObjNameSize.width ? width1 : replyObjNameSize.width;
        
        //回复View上左侧竖线
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 16, 1, 15 + questionSize.height)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"9AC2DE"];
        [self.bubbleBackgroundView addSubview:self.lineView];
        
        //提问者姓名的位置
        self.replyObjNamLab.frame = CGRectMake(self.lineView.right + 7, 12, messageContentViewRect.size.width, 20);
        self.replyObjNamLab.font = [UIFont systemFontOfSize:12];
        self.replyObjNamLab.textColor = [UIColor colorWithHexString:@"759EB9"];
        //提问的问题的位置
        self.replyQuestionLab.frame = CGRectMake(self.lineView.right + 7, 33, questionSize.width, questionSize.height);
        self.replyQuestionLab.font = [UIFont systemFontOfSize:14];
        self.replyQuestionLab.textColor = [UIColor colorWithHexString:@"333333"];
        
        //回复View上 问题 与 回答中间的线
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.replyQuestionLab.bottom + 10, width + 28, 1)];
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"A7C3FF"];
        [self.bubbleBackgroundView addSubview:self.bottomLine];
        
        //回复的内容的位置
        self.replyContentLab.frame = CGRectMake(10, self.bottomLine.bottom + 10, replyContentSize.width, replyContentSize.height);
        self.replyContentLab.font = [UIFont systemFontOfSize:16];
        self.replyContentLab.textColor = [UIColor colorWithHexString:@"333333"];
        
        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = width;
        messageContentViewRect.size.height = questionSize.height + replyContentSize.height + 32 + 22 + 12;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        self.messageContentView.frame = CGRectMake(messageContentViewRect.origin.x - 17.5, messageContentViewRect.origin.y, messageContentViewRect.size.width, messageContentViewRect.size.height);
        self.bubbleBackgroundView.frame = CGRectMake(-17.5, 0, width + 35, questionSize.height + replyContentSize.height + 32 + 22 + 12);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
    }
}

+ (CGSize)getBubbleBackgroundViewSize:(WMReplyMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return textLabelSize;
}

+ (CGSize)getTextLabelSize:(WMReplyMessage *)message {
    if ([message.targetContent length] > 0 && [message.replyMessage length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.targetContent
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:Title_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        
        float maxWidth2 =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect2 = [message.replyMessage
                            boundingRectWithSize:CGSizeMake(maxWidth2, 8000)
                            options:(NSStringDrawingTruncatesLastVisibleLine |
                                     NSStringDrawingUsesLineFragmentOrigin |
                                     NSStringDrawingUsesFontLeading)
                            attributes:@{
                                         NSFontAttributeName :
                                             [UIFont systemFontOfSize:Test_Message_Font_Size]
                                         }
                            context:nil];
        textRect2.size.height = ceilf(textRect2.size.height);
        textRect2.size.width = ceilf(textRect2.size.width);
        
        float maxWidth3 =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect3 = [message.targetName
                            boundingRectWithSize:CGSizeMake(maxWidth3, 8000)
                            options:(NSStringDrawingTruncatesLastVisibleLine |
                                     NSStringDrawingUsesLineFragmentOrigin |
                                     NSStringDrawingUsesFontLeading)
                            attributes:@{
                                         NSFontAttributeName :
                                             [UIFont systemFontOfSize:Name_Message_Font_Size]
                                         }
                            context:nil];
        textRect2.size.height = ceilf(textRect2.size.height);
        textRect2.size.width = ceilf(textRect2.size.width);
        
        float width = textRect.size.width > textRect2.size.width? textRect.size.width : textRect2.size.width;
        float width2 = width > textRect3.size.width ? width : textRect3.size.width;
        return CGSizeMake(width2 + 35, textRect.size.height + textRect2.size.height + 32 + 22 + 12);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getQuestionSize:(WMReplyMessage *)message{
    if ([message.targetContent length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.targetContent
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:Title_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height);
    }
    return CGSizeZero;
}

+ (CGSize)getReplyContentSize:(WMReplyMessage *)message{
    if ([message.replyMessage length] > 0) {
        float maxWidth2 =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect2 = [message.replyMessage
                            boundingRectWithSize:CGSizeMake(maxWidth2, 8000)
                            options:(NSStringDrawingTruncatesLastVisibleLine |
                                     NSStringDrawingUsesLineFragmentOrigin |
                                     NSStringDrawingUsesFontLeading)
                            attributes:@{
                                         NSFontAttributeName :
                                             [UIFont systemFontOfSize:Test_Message_Font_Size]
                                         }
                            context:nil];
        textRect2.size.height = ceilf(textRect2.size.height);
        textRect2.size.width = ceilf(textRect2.size.width);
        return CGSizeMake(textRect2.size.width + 5, textRect2.size.height);
    }
    return CGSizeZero;
}

+ (CGSize)getQuestionObjNameSize:(WMReplyMessage *)message{
    if ([message.targetName length] > 0) {
        float maxWidth2 =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 - 35;
        CGRect textRect2 = [message.targetName
                            boundingRectWithSize:CGSizeMake(maxWidth2, 8000)
                            options:(NSStringDrawingTruncatesLastVisibleLine |
                                     NSStringDrawingUsesLineFragmentOrigin |
                                     NSStringDrawingUsesFontLeading)
                            attributes:@{
                                         NSFontAttributeName :
                                             [UIFont systemFontOfSize:Name_Message_Font_Size]
                                         }
                            context:nil];
        textRect2.size.height = ceilf(textRect2.size.height);
        textRect2.size.width = ceilf(textRect2.size.width);
        return CGSizeMake(textRect2.size.width + 5, textRect2.size.height);
    }
    return CGSizeZero;
}

@end
