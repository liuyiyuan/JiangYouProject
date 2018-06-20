//
//  WMRCGroupNewsMessageCell.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMRCGroupNewsMessageCell.h"
#import "WMRCGroupNewsMessage.h"
#import <UIImageView+WebCache.h>
#define Title_Message_Font_Size 14
#define Name_Message_Font_Size 12
#define Test_Message_Font_Size 16


#define Title_Color @"333333"
#define Name_Color @"999999"
@implementation WMRCGroupNewsMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    WMRCGroupNewsMessage *message = (WMRCGroupNewsMessage *)model.content;
    CGSize size = [WMRCGroupNewsMessageCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(kScreen_width, 60+130);
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
    
    //title
    self.titleLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.titleLabel setFont:[UIFont systemFontOfSize:Test_Message_Font_Size]];

    self.titleLabel.numberOfLines = 0;
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self.bubbleBackgroundView addSubview:self.titleLabel];
    
    
    //hospital
    self.detailLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.detailLabel setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];

    self.detailLabel.numberOfLines = 0;
    [self.detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.detailLabel setTextAlignment:NSTextAlignmentLeft];
    self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self.bubbleBackgroundView addSubview:self.detailLabel];
    
    //图片
    self.showImageView=[[UIImageView alloc]init];
    [self.bubbleBackgroundView addSubview:self.showImageView];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pictureMessageTap = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(tapPictureMessage:)];
    pictureMessageTap.numberOfTapsRequired = 1;
    pictureMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:pictureMessageTap];
    
}
- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    //创建控件
    WMRCGroupNewsMessage *businessCardMessage = (WMRCGroupNewsMessage *)self.model.content;
    
    _CardWide=kScreen_width*0.6;
    title_height = [CommonUtil heightForLabelWithText:businessCardMessage.title width:(_CardWide-15-10) font:[UIFont systemFontOfSize:Test_Message_Font_Size]];
    detail_height = [CommonUtil heightForLabelWithText:businessCardMessage.detailLabel width:(_CardWide-15-15-10-45) font:[UIFont systemFontOfSize:Name_Message_Font_Size]];
    
    

    if (title_height>40) {
        title_height=40;
    }
    if (detail_height>30) {
        detail_height=30;
    }
    //这里的高度是自定义的
    _CardHigh=116-40+title_height;
    
        if (businessCardMessage) {
        self.detailLabel.text=businessCardMessage.detailLabel;
        self.titleLabel.text=businessCardMessage.title;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:businessCardMessage.showUrl] placeholderImage:[UIImage imageNamed:@"doctor_man"] options:SDWebImageAllowInvalidSSLCertificates];
        
    }
    //获取文字消息的size
    //大背景的size(单纯的按照 textLabelSize 是不对的)
    CGSize bubbleBackgroundViewSize = CGSizeMake(_CardWide, _CardHigh);
    //消息内容的View
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接受
        [self.titleLabel setTextColor:[UIColor colorWithHexString:Title_Color]];
        [self.detailLabel setTextColor: [UIColor colorWithHexString:Name_Color]];
        
        
        //title的位置
        self.titleLabel.frame =
        CGRectMake(15+5,11, _CardWide-15-10,title_height);
        //detailLabel的位置
        self.detailLabel.frame =
        CGRectMake(15+5,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, _CardWide-15-70,detail_height);
        
        
        //图片的位置
        self.showImageView.frame=CGRectMake(_CardWide-45-15, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 45, 45);
        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        
        //大泡泡背景 赋值
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(
                                                     0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.8,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.2)];
    } else {
        //自己发消息
        [self.titleLabel setTextColor:[UIColor colorWithHexString:Title_Color]];
        [self.detailLabel setTextColor: [UIColor colorWithHexString:Name_Color]];
        //title的位置
        self.titleLabel.frame =
        CGRectMake(10,11, _CardWide-15-10,title_height);
        //name的位置
        self.detailLabel.frame =
        CGRectMake(10,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, _CardWide-15-10-15-45-5,detail_height);
        
        
        //图片的位置
        self.showImageView.frame=CGRectMake(_CardWide-45-15-5,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 45, 45);
        
        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(
                                                     0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
    }
}
#pragma mark--出去的delegate
- (void)tapPictureMessage:(UIGestureRecognizer *)gestureRecognizer {
    
    
    
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}


+ (CGSize)getTextLabelSize:(WMRCGroupNewsMessage *)message {
    if ([message.title length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.title
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:Test_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize withUrl:(NSString *)urlString {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    //据研究发现这个地方加东西可以改变整个cell的高度 包括后面阴影的高度 2016.11.08 记录 例如下面的120
    
    if (bubbleSize.width + 12 + 20 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 20;
    } else {
        //宽最小保证40
        bubbleSize.width = 50;
    }
    if (stringIsEmpty(urlString)) {
        if (bubbleSize.height + 7 + 7 > 40) {
            bubbleSize.height = bubbleSize.height + 7 + 7;
        } else {
            //高最小保证40
            bubbleSize.height = 40;
        }
        
    }else{
        if (bubbleSize.height + 7 + 7 > 40) {
            bubbleSize.height = bubbleSize.height + 7 + 7+40;
        } else {
            //高最小保证40
            bubbleSize.height = 40+40;
        }
        
        
    }
    
    
    return bubbleSize;
}

+ (CGSize)getBubbleBackgroundViewSize:(WMRCGroupNewsMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize withUrl:message.showUrl];
}

@end
