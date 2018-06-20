//
//  WMRCBusinessCardMessageCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCBusinessCardMessageCell.h"
#import "WMRCBusinessCardMessage.h"
#import <UIImageView+WebCache.h>
#define Title_Message_Font_Size 14
#define Name_Message_Font_Size 12
#define Test_Message_Font_Size 16


#define Title_Color @"333333"
#define Name_Color @"999999"

@implementation WMRCBusinessCardMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    WMRCBusinessCardMessage *message = (WMRCBusinessCardMessage *)model.content;
    /*
     if (stringIsEmpty(message.urlString)) {
     
     }
     else{
     
     }
     */
    CGSize size = [WMRCBusinessCardMessageCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(kScreen_width, 60+100);
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
    
    _CardWide=kScreen_width*0.6;
    _CardHigh=100;
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    //name
    self.nameLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.nameLabel setFont:[UIFont systemFontOfSize:Title_Message_Font_Size]];
    
    self.nameLabel.numberOfLines = 0;
    [self.nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nameLabel setTextColor: [UIColor colorWithHexString:Title_Color]];//colorFromHexRGB:Title_Color]];
    [self.bubbleBackgroundView addSubview:self.nameLabel];
    
    //title
    self.titleLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.titleLabel setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];
    
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    
    
    self.departmentLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.departmentLabel setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];
    
    self.departmentLabel.numberOfLines = 0;
    [self.departmentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.departmentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.departmentLabel];
    
    //hospital
    self.hospitalLabel=[[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    [self.hospitalLabel setFont:[UIFont systemFontOfSize:Name_Message_Font_Size]];
    
    self.hospitalLabel.numberOfLines = 0;
    [self.hospitalLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.hospitalLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.hospitalLabel];
    
    //图片
    self.headImageView=[[UIImageView alloc]init];
    _headImageView.layer.cornerRadius=20;
    _headImageView.layer.masksToBounds=YES;
    [self.bubbleBackgroundView addSubview:self.headImageView];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pictureMessageTap = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(tapPictureMessage:)];
    pictureMessageTap.numberOfTapsRequired = 1;
    pictureMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:pictureMessageTap];
    
    
    
    
    //[self.textLabel addGestureRecognizer:textMessageTap];
    //self.textLabel.userInteractionEnabled = YES;
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
    WMRCBusinessCardMessage *businessCardMessage = (WMRCBusinessCardMessage *)self.model.content;
    if (businessCardMessage) {
        self.nameLabel.text = businessCardMessage.name;
        self.hospitalLabel.text=businessCardMessage.hospital;
        self.departmentLabel.text=businessCardMessage.department;
        self.titleLabel.text=businessCardMessage.title;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:businessCardMessage.headUrl] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
        
    }
    //获取文字消息的size
    //CGSize textLabelSize = [[self class] getTextLabelSize:businessCardMessage];
    //大背景的size(单纯的按照 textLabelSize 是不对的)
    CGSize bubbleBackgroundViewSize = CGSizeMake(_CardWide, _CardHigh);
    //消息内容的View
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接受
        [self.titleLabel setTextColor:[UIColor colorWithHexString:Name_Color]];
        [self.departmentLabel setTextColor: [UIColor colorWithHexString:Name_Color]];
        [self.hospitalLabel setTextColor:[UIColor colorWithHexString:Name_Color]];
        
        
        //title的位置
        self.nameLabel.frame =
        CGRectMake(74,12, _CardWide-74-15,20);
        //name的位置
        self.hospitalLabel.frame =
        CGRectMake(74,33,  _CardWide-74-15,18);
        //hospital的位置
        self.departmentLabel.frame =
        CGRectMake(74,52, _CardWide-74-15,18);
        self.titleLabel.frame =
        CGRectMake(74,71, _CardWide-74-15,18);
        
        //图片的位置
        self.headImageView.frame=CGRectMake(19, 15, 40, 40);
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
        [self.departmentLabel setTextColor: [UIColor colorWithHexString:Title_Color]];
        [self.hospitalLabel setTextColor:[UIColor colorWithHexString:Title_Color]];
        
        
        //title的位置
        self.nameLabel.frame =
        CGRectMake(69,12, _CardWide-69-15,20);
        //name的位置
        self.hospitalLabel.frame =
        CGRectMake(69,33,  _CardWide-69-15,18);
        //hospital的位置
        self.departmentLabel.frame =
        CGRectMake(69,52, _CardWide-69-15,18);
        self.titleLabel.frame =
        CGRectMake(69,71, _CardWide-69-15,18);
        
        //图片的位置
        self.headImageView.frame=CGRectMake(15, 15, 40, 40);
        
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


+ (CGSize)getTextLabelSize:(WMRCBusinessCardMessage *)message {
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

+ (CGSize)getBubbleBackgroundViewSize:(WMRCBusinessCardMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize withUrl:message.headUrl];
}
/*
 -(CGSize)accordingArrayCount{
 CGSize pictureSize;
 if (self.pictureArray.count<=3) {
 pictureSize.width=100;
 pictureSize.height=60;
 }
 else{
 pictureSize.width=100;
 pictureSize.height=60*2;
 }
 
 return pictureSize;
 }
 
 */
@end
