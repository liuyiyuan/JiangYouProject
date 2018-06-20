//
//  WMRCInquiryMessageCell.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMRCInquiryMessageCell.h"
#import <UIImageView+WebCache.h>
#import "WMRCInquiryMessage.h"

#define Test_Message_Font_Size 16


#define WMRCIMAGEMESSAGE_TAG 100
#define kBubbleSharp 10 //气泡尖尖的宽度
@implementation WMRCInquiryMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    
    
    //由于名片的高度，宽度一定 所以 下面这句代码是没有用途的
    WMRCInquiryMessage *inquiryMessage = (WMRCInquiryMessage *)model.content;
    
    /**
     *
     *  根据消息的具体内容来判断消息的宽高 kScreen_width一定 高 实时获取
     *  根据文字消息计算
     *  根据图片消息计算
     */
    //由于名片的高度，宽度一定 所以可以直接返回固定高度 50 是从文档那看到的之和10+20+10+10
    
    CGSize MessageSize=[WMRCInquiryMessageCell countHeightWithTextMessage:inquiryMessage];
    
    CGSize pictureSizee=[WMRCInquiryMessageCell countHeightWithPictureMessage:inquiryMessage];
    CGFloat commentHeight;
    if (MessageSize.height+pictureSizee.height+55<100.0) {
        commentHeight=100.00;
    }
    else{
        commentHeight=MessageSize.height+pictureSizee.height+55;
    }
    CGFloat messagecontentview_height =commentHeight;
    messagecontentview_height += extraHeight;
    
    return CGSizeMake(kScreen_width, messagecontentview_height);
    
}
/**
 *判断机型分辨率
 */
+(NSString*)getMainScreen
{
    UIScreen *MainScreen=[UIScreen mainScreen];
    CGSize size=[MainScreen bounds].size;
    if(size.height > 700)
    {
        return @"6p";
    }
    else if (size.height>650)
    {
        return @"6";
    }
    else if(size.height>500)
    {
        return @"5";
    }
    else
    {
        return @"4";
    }
    return @"5";
    
}
#pragma mark--根据文字消息计算高度
+(CGSize )countHeightWithTextMessage:(WMRCInquiryMessage *)inquiryMessage{
    
    CGSize  textSize=[WMRCInquiryMessageCell getTextLabelSize:inquiryMessage];
    
    NSString *string=[WMRCInquiryMessageCell getMainScreen];
    if ([string isEqualToString:@"4"]) {
        return CGSizeMake(textSize.width+22, textSize.height+8);
    }
    else if ([string isEqualToString:@"5"]) {
        return CGSizeMake(textSize.width+22, textSize.height+8);
    }
    else if ([string isEqualToString:@"6"]){
        return CGSizeMake(textSize.width+15, textSize.height+8);
    }
    else{
        return CGSizeMake(textSize.width+20, textSize.height+8);
    }
    
}
#pragma mark--根据图片消息计算高度
+(CGSize )countHeightWithPictureMessage:(WMRCInquiryMessage *)inquiryMessage{
    
    if (inquiryMessage.inquiryPictureArr.count==0) {
        CGSize pictureSize;
        pictureSize.height=0;
        pictureSize.width=0;
        
        
        return pictureSize;
    }
    else if(inquiryMessage.inquiryPictureArr.count<4) {
        CGSize pictureSize;
        pictureSize.height=(kScreen_width/5.00-10.00)*1.00 +10;
        pictureSize.width=(kScreen_width/5.00-10.00) *inquiryMessage.inquiryPictureArr.count+5*inquiryMessage.inquiryPictureArr.count;
        
        
        return pictureSize;
    }
    else if(inquiryMessage.inquiryPictureArr.count<7) {
        CGSize pictureSize;
        pictureSize.height= ((kScreen_width/5.00-10.00)*1.00)*2+10*2;
        pictureSize.width=(kScreen_width/5.00-10.00)*3+15;
        
        return pictureSize;
    }
    else{
        CGSize pictureSize;
        pictureSize.height=0;
        pictureSize.width=0;
        
        
        return pictureSize;
    }
}
+ (CGSize)getTextLabelSize:(WMRCInquiryMessage *)inquiryMessage {
    if ([inquiryMessage.inquiryTextMsg length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [inquiryMessage.inquiryTextMsg
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
    
    _imageWide=kScreen_width/5.00-10;
    _scale_wide_high=1.00;
    _imageHigh=_imageWide/_scale_wide_high;
    
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //[self.messageContentView 是底层的View
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    //self.messageContentView.backgroundColor=[UIColor greenColor];
    //消息
    self.textMessageView=[[UIView alloc]init];
    //self.textMessageView.backgroundColor=[UIColor purpleColor];
    
    
    [self.bubbleBackgroundView addSubview:self.textMessageView];
    
    _acceptMessageLabel=[[UILabel alloc]init];
    _acceptMessageLabel.numberOfLines=0;
    _acceptMessageLabel.font=[UIFont systemFontOfSize:Test_Message_Font_Size];
    
    _giveOutMessageLabel=[[UILabel alloc]init];
    _giveOutMessageLabel.numberOfLines=0;
    _giveOutMessageLabel.font=[UIFont systemFontOfSize:Test_Message_Font_Size];
    
    
    //图片
    
    
    
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
   
}
//长按事件 
- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    //创建控件
    WMRCInquiryMessage *inquiryMessage = (WMRCInquiryMessage *)self.model.content;
    //获取文字消息的size
    //CGSize textLabelSize = [[self class] getTextLabelSize:testMessage];
    //大背景的size(单纯的按照 textLabelSize 是不对的)
    
    CGSize textSize= [WMRCInquiryMessageCell countHeightWithTextMessage:inquiryMessage];
    CGSize pictureSize=[WMRCInquiryMessageCell countHeightWithPictureMessage:inquiryMessage];
    CGSize bubbleBackgroundViewSize;
    if (textSize.width>pictureSize.width) {
        bubbleBackgroundViewSize=CGSizeMake(textSize.width, pictureSize.height+textSize.height);
    }
    else{
        bubbleBackgroundViewSize =CGSizeMake(pictureSize.width, pictureSize.height+textSize.height);
    }
    
    //消息内容的View
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {//接受
        
        
        if (inquiryMessage) {
            
            [self.pictureView removeFromSuperview];
            self.pictureView=[[UIView alloc]init];
            //self.pictureView.backgroundColor=[UIColor yellowColor];
            [self.bubbleBackgroundView addSubview:self.pictureView];

            //视图上要有一个label。
            self.textMessageView.frame=CGRectMake(10, 0, bubbleBackgroundViewSize.width-10, textSize.height);
            self.pictureView.frame=CGRectMake(10, self.textMessageView.frame.origin.y+self.textMessageView.frame.size.height+5, bubbleBackgroundViewSize.width-10, pictureSize.height);
            _acceptMessageLabel.text=inquiryMessage.inquiryTextMsg;
            _acceptMessageLabel.frame=CGRectMake(5, 5, self.textMessageView.frame.size.width-10, self.textMessageView.frame.size.height-10);
            [self.textMessageView addSubview:_acceptMessageLabel];
            for (int i=0;i<inquiryMessage.inquiryPictureArr.count; i++) {
                
                int x= i%3;//(取余  0 1 2)
                int y=i/3;//(取除数 0 1 )
                UIImageView * pictureImage=[[UIImageView alloc]init];
                pictureImage.tag=WMRCIMAGEMESSAGE_TAG+i;
                pictureImage.contentMode=UIViewContentModeScaleAspectFill;
                pictureImage.layer.cornerRadius=4;
                pictureImage.layer.masksToBounds=YES;
                pictureImage.frame=CGRectMake(5+(_imageWide)*x, (_imageHigh+5)*y,_imageWide-5, _imageHigh);
                NSURL *url=[NSURL URLWithString:inquiryMessage.inquiryPictureArr[i]];
                
                 [pictureImage sd_setImageWithURL:url placeholderImage: [self createImageWithColor:[UIColor colorWithHexString:@"cccccc"]]];
                UITapGestureRecognizer *pictureMessageTap = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(tapPictureMessage:)];
                pictureMessageTap.numberOfTapsRequired = 1;
                pictureMessageTap.numberOfTouchesRequired = 1;
                [pictureImage addGestureRecognizer:pictureMessageTap];
                pictureImage.userInteractionEnabled = YES;
                self.pictureView.userInteractionEnabled=YES;
                [self.pictureView addSubview:pictureImage];
                /*
                 UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                 button.tag=WMRCIMAGEMESSAGE_TAG+i;
                 
                 button.frame=CGRectMake(5+(_imageWide)*x, (_imageHigh+5)*y,_imageWide-5, _imageHigh);
                 
                 button.titleLabel.font=[UIFont systemFontOfSize:14];
                 [button setTitle:[NSString stringWithFormat:@"button%d",i] forState:UIControlStateNormal];
                 
                 button.backgroundColor=[UIColor redColor];
                 [self.pictureView addSubview:button];
                 */
            }
            
        }
        
        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        //大泡泡背景 赋值
        self.messageContentView.frame = messageContentViewRect;
        
        
        
        /**
         * self.bubbleBackgroundView 是泡泡的
         * 泡泡的高度是两个view的高度之和
         * 泡泡的宽度是两个view的宽度的宽的那一标准
         **/
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
        if (inquiryMessage) {
            [self.pictureView removeFromSuperview];
            self.pictureView=[[UIView alloc]init];
            //self.pictureView.backgroundColor=[UIColor yellowColor];
            [self.bubbleBackgroundView addSubview:self.pictureView];

            //视图上要有一个label。
            self.textMessageView.frame=CGRectMake(0, 0, bubbleBackgroundViewSize.width-10, textSize.height);
            self.pictureView.frame=CGRectMake(0, self.textMessageView.frame.origin.y+self.textMessageView.frame.size.height+5, bubbleBackgroundViewSize.width-10, pictureSize.height);
           
            _giveOutMessageLabel.text=inquiryMessage.inquiryTextMsg;
            _giveOutMessageLabel.frame=CGRectMake(5, 5, self.textMessageView.frame.size.width-10, self.textMessageView.frame.size.height-10);
            [self.textMessageView addSubview:_giveOutMessageLabel];
            for (int i=0;i<inquiryMessage.inquiryPictureArr.count; i++) {
                
                int x= i%3;//(取余  0 1 2)
                int y=i/3;//(取除数 0 1 )
                
                UIImageView * pictureImage=[[UIImageView alloc]init];
                pictureImage.tag=WMRCIMAGEMESSAGE_TAG+i;
                pictureImage.frame=CGRectMake(5+(_imageWide)*x, (_imageHigh+5)*y,_imageWide-5, _imageHigh);
                pictureImage.layer.cornerRadius=4;
                pictureImage.layer.masksToBounds=YES;
                pictureImage.contentMode=UIViewContentModeScaleAspectFill;
                NSURL *url=[NSURL URLWithString:inquiryMessage.inquiryPictureArr[i]];
                
                [pictureImage sd_setImageWithURL:url placeholderImage: [self createImageWithColor:[UIColor colorWithHexString:@"cccccc"]]];
                
                
                UITapGestureRecognizer *pictureMessageTap = [[UITapGestureRecognizer alloc]
                                                             initWithTarget:self
                                                             action:@selector(tapPictureMessage:)];
                pictureMessageTap.numberOfTapsRequired = 1;
                pictureMessageTap.numberOfTouchesRequired = 1;
                [pictureImage addGestureRecognizer:pictureMessageTap];
                pictureImage.userInteractionEnabled = YES;
                self.pictureView.userInteractionEnabled=YES;
                [self.pictureView addSubview:pictureImage];
                
                
                /*
                 UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                 button.tag=WMRCIMAGEMESSAGE_TAG+i;
                 button.frame=CGRectMake(5+(_imageWide)*x, (_imageHigh+5)*y,_imageWide-5, _imageHigh);
                 [button setTitle:[NSString stringWithFormat:@"button%d",i] forState:UIControlStateNormal];
                 button.backgroundColor=[UIColor redColor];
                 button.titleLabel.font=[UIFont systemFontOfSize:14];
                 [button addTarget:self action:@selector(tapTextMessageActoin:) forControlEvents:UIControlEventTouchUpInside];
                 [self.pictureView addSubview:button];
                 */
                
            }
            
        }
        
        //消息内容的View的宽 赋值
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         [RCIM sharedRCIM].globalMessagePortraitSize.width + kBubbleSharp);
        
        
        
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

#

#pragma mark--出去的delegate
- (void)tapPictureMessage:(UIGestureRecognizer *)gestureRecognizer {
    
     int  pictureTag=(int)gestureRecognizer.view.tag;
    NSLog(@"tapNumbwer=%d",pictureTag);
    int  arrayIndex=pictureTag-WMRCIMAGEMESSAGE_TAG ;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",arrayIndex] forKey:WMRCInquiryMessageCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
