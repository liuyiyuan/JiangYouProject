//
//  ZCUIKeyboard.m
//  SobotKit
//
//  Created by zhangxy on 15/11/13.
//  Copyright © 2015年 zhichi. All rights reserved.
//

#import "ZCUIKeyboard.h"

#import "ZCLIbGlobalDefine.h"
#import "ZCUIColorsDefine.h"
#import "ZCUIImageTools.h"
#import "ZCStoreConfiguration.h"
#import "ZCSobotCore.h"

#import "ZCPlatformTools.h"

#import "ZCAutoListView.h"

#import "ZCUICore.h"

#define MoreViewHeight  216
#define EmojiViewHeight 216
#define MoreViewHorizontalHeight 120
#define EmojiViewHorizontalHeight 120

/**
 *  BottomButtonClickTag ENUM
 */
typedef NS_ENUM(NSInteger, BottomButtonClickTag) {
    /** 转人工 */
    BUTTON_CONNECT_USER   = 2,
    /** 相机相册 */
    BUTTON_ADDPHOTO       = 3,
    /** 录语音 */
    BUTTON_ADDVOICE       = 4,
    /** 转人工按钮的tag值（2中状态下的图标）*/
    BUTTON_ToKeyboard     = 5,
    /**  */
    BUTTON_RECORD         = 6,
    /** 新会话（原重新接入）*/
    BUTTON_RECONNECT_USER = 7,
    /** 满意度 */
    BUTTON_SATISFACTION   = 8,
    /** 留言 */
    BUTTON_LEAVEMESSAGE   = 9,
    /** 更多 */
    BUTTON_ADDMORE        = 10,
    /** 表情键盘 */ 
    BUTTON_ADDFACEVIEW    = 11,
};



@interface ZCUIKeyboard()<ZCUIRecordDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EmojiBoardDelegate,UIGestureRecognizerDelegate>{
    CGFloat navHeight;
}

@property (nonatomic , strong) UIView *ppView;


/** 语音事件 */
@property (nonatomic,strong) UIButton   *zc_voiceButton;

/** 留言按钮 */
@property (nonatomic,strong) UIButton   *zc_leaveMsgButton;

/** 图片按钮 */
@property (nonatomic,strong) UIButton   *zc_addMoreButton;

/** 录音按钮 */
@property (nonatomic,strong) UIButton   *zc_pressedButton;

/** 表情按钮 */
@property (nonatomic,strong) UIButton   *zc_faceButton;

/** 新会话按钮 */
@property (nonatomic,strong) UIButton   *zc_againAccessBtn;

/** 加载动画 */
@property (nonatomic,strong) UIActivityIndicatorView *zc_activityView;

/** 系统相册相机图片 */
@property (nonatomic,strong) UIImagePickerController *zc_imagepicker;

/** 聊天页中UITableView 用于界面键盘高度处理 */
@property (nonatomic,strong) UITableView *zc_listTable;

/** 键盘高度 */
@property (nonatomic,assign) CGFloat zc_keyBoardHeight;

/** 语音动画页面 */
@property (nonatomic,strong) ZCUIRecordView *zc_recordView;

/** emjoy布局view */
@property (nonatomic,strong) EmojiBoardView *zc_emojiView;

/** 添加留言背景View */
@property (nonatomic,strong) UIView   *zc_sessionBgView;


/** 添加相机的View */
@property (nonatomic,strong) UIView *zc_moreView;

/** (排队中...)Label */
@property (nonatomic,strong) UILabel *zc_waitLabel;

/** 获取用户传入的VC页面 */
@property (nonatomic,strong) UIView *zc_sourceView;

/** 技能组展示页面 */
@property (nonatomic,strong) ZCUISkillSetView *skillSetView;

/** 机器人语音按钮*/
@property (nonatomic,strong) UIButton * zc_robotVoiceBtn;

/** 机器人录音功能提示语*/
@property (nonatomic,strong) UILabel * vioceTipLabel;

@end


@implementation ZCUIKeyboard{
    // 页面点击事件
    UITapGestureRecognizer *tapRecognizer;
    
    ZCKeyboardViewStatus curKeyBoardStatus;
}


-(id)init{
    self=[super init];
    if(self){
        
    }
    return self;
}

-(ZCLibConfig *)getZCLibConfig{
    return [[ZCUICore getUICore] getLibConfig];
}


///////////////////////////////////////////////////////
#pragma mark -- 懒加载
- (UIView*)zc_bottomView{
    if (!_zc_bottomView) {
        CGFloat BY = [self getSourceViewHeight]-BottomHeight;
        if (ZC_iPhoneX) {
//            BY = [self getSourceViewHeight] - BottomHeight - 34;
        }
        _zc_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BY, [self getSourceViewWidth], BottomHeight)];
        [_zc_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        [_zc_bottomView setAutoresizesSubviews:YES];
        [_zc_bottomView setBackgroundColor:[ZCUITools zcgetBackgroundBottomColor]];
        _zc_bottomView.userInteractionEnabled=YES;
        _zc_bottomView.multipleTouchEnabled = YES;
        _zc_sourceView.userInteractionEnabled = YES;
        [self.zc_sourceView addSubview:_zc_bottomView];
    }
    return _zc_bottomView;
}




- (UITextView *)zc_chatTextView{
    if (!_zc_chatTextView) {
        _zc_chatTextView = [[UITextView alloc] init];
        if(ZC_iPhoneX){
            _zc_chatTextView.frame = CGRectMake(48, 10, [self getSourceViewWidth]-58, 35);
        }else{
            _zc_chatTextView.frame = CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-58, 35);
        }
        _zc_chatTextView.layer.cornerRadius                      = 3;
        _zc_chatTextView.layer.masksToBounds                     = YES;
        if (iOS7) {
            // 关闭UITextView 非连续布局属性
            _zc_chatTextView.layoutManager.allowsNonContiguousLayout = NO;
        }
        if (iOS7) {
            _zc_chatTextView.layer.borderWidth                       = 0.75f;
        }else{
            _zc_chatTextView.layer.borderWidth                       = 0.5f;
        }
        _zc_chatTextView.layer.borderWidth                       = 0.5f;
        _zc_chatTextView.font                                    = [ZCUITools zcgetListKitTitleFont];
        _zc_chatTextView.layer.borderColor                       = UIColorFromRGB(LineTextMenuColor).CGColor;
        _zc_chatTextView.returnKeyType                           = UIReturnKeySend;
        _zc_chatTextView.autoresizesSubviews                     = YES;
        _zc_chatTextView.delegate                                = self;
        _zc_chatTextView.textAlignment                           = NSTextAlignmentLeft;
        _zc_chatTextView.autoresizingMask                        = (UIViewAutoresizingFlexibleWidth);
        //    [_chatTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_zc_chatTextView setBackgroundColor:[UIColor whiteColor]];
        [_zc_bottomView addSubview:_zc_chatTextView];
    }
    return _zc_chatTextView;
}


- (UIButton *)zc_pressedButton{
    if (!_zc_pressedButton) {
        _zc_pressedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zc_pressedButton.userInteractionEnabled = YES;
        _zc_pressedButton.layer.cornerRadius     = 3;
        _zc_pressedButton.layer.masksToBounds    = YES;
        _zc_pressedButton.layer.borderWidth      = 0.75f;
        _zc_pressedButton.titleLabel.font        = [ZCUITools zcgetVoiceButtonFont];
        _zc_pressedButton.layer.borderColor      = [ZCUITools zcgetBackgroundBottomLineColor].CGColor;
        [_zc_pressedButton setTitle:ZCSTLocalString(@"按住 说话") forState:UIControlStateNormal];
        [_zc_pressedButton setTitleColor:UIColorFromRGB(TextMoreMenuColor) forState:UIControlStateNormal];
        [_zc_pressedButton setBackgroundImage:[ZCUIImageTools zcimageWithColor:UIColorFromRGB(recordingBtnSelectedColor)] forState:UIControlStateHighlighted];
//        [_zc_pressedButton setFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-48*3, 35)];
        [_zc_bottomView addSubview:_zc_pressedButton];
        [_zc_pressedButton setHidden:YES];
        _zc_pressedButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [_zc_pressedButton addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_zc_pressedButton addTarget:self action:@selector(btnTouchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        
        if (![self getZCLibConfig].isArtificial ) {
            if (![ZCUICore getUICore].kitInfo.isShowTansfer && ![ZCLibClient getZCLibClient].isShowTurnBtn) {
                // 不显示转人工的按钮
                [_zc_pressedButton setFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-58, 35)];
            }else{
                [_zc_pressedButton setFrame:CGRectMake(48 *2, (BottomHeight-35)/2, [self getSourceViewWidth]-48*3-5, 35)];
            }
        }else{
            [_zc_pressedButton setFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-48*3, 35)];
        }
        
    }
    return _zc_pressedButton;
}

- (UIButton *)zc_turnButton{
    if (!_zc_turnButton) {
        _zc_turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zc_turnButton setImage:[ZCUITools zcuiGetBundleImage:ZCSTLocalString(@"zcicon_manualWork_nol")] forState:UIControlStateNormal];
        [_zc_turnButton setImage:[ZCUITools zcuiGetBundleImage:ZCSTLocalString(@"zcicon_manualWork_pre")] forState:UIControlStateHighlighted];
        [_zc_turnButton setImageEdgeInsets:UIEdgeInsetsMake(10.5, 10, 10.5, 10)];
        [_zc_turnButton setFrame:CGRectMake(0, 0 , 48, 49)];
        [_zc_turnButton setBackgroundColor:[UIColor clearColor]];
        _zc_turnButton.tag                 = BUTTON_CONNECT_USER;
        [_zc_turnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _zc_turnButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_zc_bottomView addSubview:_zc_turnButton];
        _zc_turnButton.hidden = NO;
    }
    return _zc_turnButton;
}


-(UIButton *)zc_addMoreButton{
    if (!_zc_addMoreButton) {
        _zc_addMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zc_addMoreButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_add"] forState:UIControlStateNormal];
        [_zc_addMoreButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_add"] forState:UIControlStateHighlighted];
        [_zc_addMoreButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 5, 7.5, 10)];
        [_zc_addMoreButton setFrame:CGRectMake([self getSourceViewWidth]-48, 0 , 48, 49)];
        [_zc_addMoreButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_zc_addMoreButton setBackgroundColor:[UIColor clearColor]];
        _zc_addMoreButton.tag                 = BUTTON_ADDPHOTO;
        [_zc_addMoreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zc_bottomView addSubview:_zc_addMoreButton];
        [_zc_addMoreButton setHidden:YES];
        _zc_addMoreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    }
    return _zc_addMoreButton;
}

- (UIButton *)zc_faceButton{
    if (!_zc_faceButton) {
        _zc_faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_normal"] forState:UIControlStateNormal];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_pressed"] forState:UIControlStateHighlighted];
        [_zc_faceButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 10, 7.5, 5)];
        [_zc_faceButton setFrame:CGRectMake([self getSourceViewWidth] -48 - 48, 0 , 48, 49)];
        [_zc_faceButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_zc_faceButton setBackgroundColor:[UIColor clearColor]];
        _zc_faceButton.tag = BUTTON_ADDFACEVIEW;
        [_zc_faceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _zc_faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_zc_bottomView addSubview:_zc_faceButton];
        _zc_faceButton.hidden = YES;
    }
    return _zc_faceButton;
}

- (UIView *)zc_sessionBgView{
    if (!_zc_sessionBgView) {
        _zc_sessionBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, [self getSourceViewWidth], BottomHeight)];
        _zc_sessionBgView.backgroundColor = UIColorFromRGB(TextTopColor);
        [_zc_sessionBgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin];
        [_zc_bottomView addSubview:_zc_sessionBgView];
        _zc_sessionBgView.hidden = YES;
    }
    return _zc_sessionBgView;
}


- (UIActivityIndicatorView *)zc_activityView{
    if (!_zc_activityView) {
        _zc_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_zc_sessionBgView addSubview:_zc_activityView];
        _zc_activityView.center = _zc_sessionBgView.center;
        _zc_activityView.hidden=YES;
    }
    return _zc_activityView;
}

-(UILabel *)zc_waitLabel{
    if (!_zc_waitLabel) {
        _zc_waitLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-58-36, 35)];
        _zc_waitLabel.layer.cornerRadius = 3;
        _zc_waitLabel.layer.masksToBounds = YES;
        _zc_waitLabel.layer.borderWidth = 0.5f;
        if (iOS7) {
            _zc_waitLabel.layer.borderWidth = 0.75f;
        }
        _zc_waitLabel.layer.borderColor = [ZCUITools zcgetBackgroundBottomLineColor].CGColor;
        _zc_waitLabel.font = VoiceButtonFont;
        _zc_waitLabel.textAlignment                           = NSTextAlignmentCenter;
        _zc_waitLabel.autoresizingMask                        = (UIViewAutoresizingFlexibleWidth);
        [_zc_waitLabel setBackgroundColor:[UIColor clearColor]];
        _zc_waitLabel.text = ZCSTLocalString(@"排队中，请稍后");
        _zc_waitLabel.textColor = UIColorFromRGB(TextTimeColor);
        [_zc_bottomView addSubview:_zc_waitLabel];
        _zc_waitLabel.hidden = YES;
    }
    return _zc_waitLabel;
}

-(UIView *)zc_moreView{
    if(!_zc_moreView){
        //添加背景view（布置 图片、拍摄、满意度按钮）
        CGFloat moreHeight = MoreViewHeight;
        if ([self getSourceViewHeight] < [self getSourceViewWidth]) {
            moreHeight = MoreViewHorizontalHeight;
        }
        _zc_moreView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getSourceViewHeight], [self getSourceViewWidth], moreHeight)];
        [_zc_moreView setBackgroundColor:UIColorFromRGB(BgTextColor)];
        [_zc_moreView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        [_zc_moreView setAutoresizesSubviews:YES];
        [_zc_sourceView addSubview:_zc_moreView];
    }
    return _zc_moreView;
}


-(UIButton *)zc_voiceButton{
    if (!_zc_voiceButton) {
        _zc_voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
        [_zc_voiceButton setImageEdgeInsets:UIEdgeInsetsMake(10.5, 10, 10.5, 10)];
        [_zc_voiceButton setFrame:CGRectMake(48 * 2, 0 , 48, 49)];
        [_zc_voiceButton setBackgroundColor:[UIColor clearColor]];
        _zc_voiceButton.tag                 = BUTTON_ADDVOICE;
        [_zc_voiceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _zc_voiceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_zc_bottomView addSubview:_zc_voiceButton];
        _zc_voiceButton.hidden = YES;
    }
    return _zc_voiceButton;
}


-(UIView *)createVioceTipLabel{
    if (!_vioceTipLabel) {
        _vioceTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.zc_bottomView.frame) - CGRectGetHeight(self.zc_bottomView.frame) -40, CGRectGetWidth(self.zc_bottomView.frame), 40)];
        _vioceTipLabel.backgroundColor = UIColorFromRGBAlpha(0xa1a6b3, 0.9);
        _vioceTipLabel.textColor = UIColorFromRGB(0xffffff);
        _vioceTipLabel.font = [UIFont systemFontOfSize:14];
        _vioceTipLabel.textAlignment = NSTextAlignmentCenter;
        _vioceTipLabel.text = @"机器人咨询模式下，语音将自动转化为文字发送";
        [self.zc_sourceView addSubview:_vioceTipLabel];
        _vioceTipLabel.hidden = YES;
    }
    return _vioceTipLabel;
}

///////////////////////////////////////////////////////

#pragma mark -- 图片、拍摄、满意度 按钮模块
// （图片、拍摄、满意度 按钮模块）
- (void)createMoreView{
    
    if (self.zc_moreView != nil) {
        [_zc_moreView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:0];
    
    if (![self getZCLibConfig].isArtificial) {
        // 是否开启留言
        if ([self getZCLibConfig].msgFlag == 0) {
            titles = [NSMutableArray arrayWithObjects:ZCSTLocalString(@"评价"),ZCSTLocalString(@"留言"), nil];
            
            tags = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%zd",ZCKeyboardOnClickSatisfaction],
                    [NSString stringWithFormat:@"%zd",ZCKeyboardOnClickLeavePage],nil];
            
        }else{
            titles = [NSMutableArray arrayWithObjects:ZCSTLocalString(@"评价"), nil];
            
            tags = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%zd",ZCKeyboardOnClickSatisfaction],nil];
        }
    }else{
        titles = [NSMutableArray arrayWithObjects:ZCSTLocalString(@"图片"),ZCSTLocalString(@"拍摄"),ZCSTLocalString(@"评价"), nil];
        tags = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%zd",ZCKeyboardOnClickAddPhotoPicture],
                [NSString stringWithFormat:@"%zd",ZCKeyboardOnClickAddPhotoCamera],
                [NSString stringWithFormat:@"%zd",ZCKeyboardOnClickSatisfaction],nil];
        
        
    }
    [self creatButtonForArray:titles tags:tags];
    
    //    [_photoView addSubview:itemView];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    // 每次添加手势设置代理
    tapRecognizer.delegate  =self;
    _zc_sourceView.userInteractionEnabled=YES;
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self getSourceViewWidth], 0.5)];
    lineView2.backgroundColor = [ZCUITools zcgetBackgroundBottomLineColor];
    [_zc_moreView addSubview:lineView2];
}


#pragma mark -- 创建满意度、留言、相册、评价等按钮
- (void)creatButtonForArray:(NSArray *)titles tags:(NSArray *) tagValues{
    CGFloat itemH = 78;
    
    CGFloat mx =  ([self getSourceViewHeight] > [self getSourceViewWidth]) ?  25.0f*[self getSourceViewWidth]/375 : 25.0f*[self getSourceViewWidth]/667;
    CGFloat my = 15.0f;
    for (int i = 1; i< titles.count+1; i++) {
        int tag = [tagValues[i-1] intValue];
        UIButton * buttons = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [buttons setFrame:CGRectMake((i-1)*60+(i-1)*30, MoreViewHeight/2-itemH/2, 60, itemH)];
        [buttons setFrame:CGRectMake(mx, my, 60, itemH)];
        
        if(tag == ZCKeyboardOnClickSatisfaction){
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_satisfaction"] forState:UIControlStateNormal];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_satisfactionSelected"] forState:UIControlStateHighlighted];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_satisfactionSelected"] forState:UIControlStateSelected];
        }else if(tag == ZCKeyboardOnClickLeavePage){
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_leavewords_normal"] forState:UIControlStateNormal];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_leavewords_press"] forState:UIControlStateHighlighted];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_leavewords_press"] forState:UIControlStateSelected];
        }else if(tag == ZCKeyboardOnClickAddPhotoPicture){
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_sendpictures"] forState:UIControlStateNormal];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_sendpicturesSelected"] forState:UIControlStateHighlighted];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_sendpicturesSelected"] forState:UIControlStateSelected];
        }else if(tag == ZCKeyboardOnClickAddPhotoCamera){
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_takingpictures"] forState:UIControlStateNormal];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_takingpicturesSelected"] forState:UIControlStateHighlighted];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_takingpicturesSelected"] forState:UIControlStateSelected];
        }else if(tag == ZCKeyboardOnClickTurnUser){
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"ZCIcon_change_person"] forState:UIControlStateNormal];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"ZCIcon_change_person_press"] forState:UIControlStateHighlighted];
            [buttons setImage:[ZCUITools zcuiGetBundleImage:@"ZCIcon_change_person_press"] forState:UIControlStateSelected];
        }
        
        buttons.tag = tag;
        [buttons.titleLabel setBackgroundColor:[UIColor clearColor]];
        [buttons.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [buttons addTarget:self action:@selector(addResourcesAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 22, 0)];
        
        if(iOS7){
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, itemH-21, 60, 21)];
            [lbl setText:titles[i-1]];
            [lbl setFont:ListDetailFont];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setTextColor:UIColorFromRGB(TextMoreMenuColor)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [buttons addSubview:lbl];
        }else{
            CGFloat margin = (70- buttons.titleLabel.frame.size.width)/2;
            [buttons setTitleEdgeInsets:UIEdgeInsetsMake(67, -4*margin+20, 0, 0)];
            [buttons setTitle:titles[i-1] forState:UIControlStateNormal];
            [buttons.titleLabel setFont:ListDetailFont];
            [buttons setTitleColor:UIColorFromRGB(TextMoreMenuColor) forState:UIControlStateNormal];
        }
        
        [_zc_moreView addSubview:buttons];
        
        mx = mx + 60* [self getSourceViewWidth]/375 + 27* [self getSourceViewWidth]/375;
    }
    
}

#pragma mark -- 表情键盘
-(void)createEmojiView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加照相机、相册视图
        CGFloat emojiViewH = EmojiViewHeight;
        if ([self getSourceViewHeight] < [self getSourceViewWidth]) {
            emojiViewH = EmojiViewHorizontalHeight;
        }
        _zc_emojiView=[[EmojiBoardView alloc] initWithBoardHeight:emojiViewH pH:[self getSourceViewHeight] pW:[self getSourceViewWidth]];
        _zc_emojiView.delegate=self;
        [_zc_sourceView addSubview:_zc_emojiView];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self getSourceViewWidth], 0.5)];
        lineView2.backgroundColor = [ZCUITools zcgetBackgroundBottomLineColor];
        [_zc_emojiView addSubview:lineView2];
    });
}

/**
 *  表情键盘点击
 *
 *  @param faceTag 表情
 *  @param name    表情
 *  @param itemId  第几个
 */
-(void)onEmojiItemClick:(NSString *)faceTag faceName:(NSString *)name index:(NSInteger)itemId{
    _zc_chatTextView.text=[NSString stringWithFormat:@"%@%@",_zc_chatTextView.text,name];
    [self textChanged:_zc_chatTextView];
}

// 表情键盘执行删除
-(void)emojiAction:(EmojiBoardActionType)action{
    if(action==EmojiActionDel){
        NSString *text = _zc_chatTextView.text;
        NSInteger lenght=text.length;
        if(lenght>0){
            NSInteger end=-1;
            NSString *lastStr= [text substringWithRange:NSMakeRange(lenght-1, 1)];
            if([lastStr isEqualToString:@"]"]){
                NSRange range=[text rangeOfString:@"[" options:NSBackwardsSearch];
                end=range.location;
                NSString *faceStr = [text substringFromIndex:end];
                if([[[ZCUICore getUICore] allExpressionDict] objectForKey:faceStr]==nil){
                    end = lenght - 1;
                }
            }else{
                end=lenght-1;
            }
            
            text=[text substringToIndex:end];
            _zc_chatTextView.text=text;
            
            [self textChanged:_zc_chatTextView];
        }
    }else if(action==EmojiActionSend){
        [self doSendMessage:NO];
    }
}



#pragma mark -- 更多键盘中按钮点击事件
- (void)addResourcesAction:(UIButton *)btn{
    if(btn.tag == ZCKeyboardOnClickTurnUser){
        // 执行转人工操作
        [[ZCUICore getUICore] checkUserServiceWithObject:nil];
    }else if(btn.tag == ZCKeyboardOnClickSatisfaction){
        [[ZCUICore getUICore] keyboardOnClick:ZCShowStatusSatisfaction];
        // 满意度
        [[ZCUICore getUICore] keyboardOnClickSatisfacetion:NO];
    }else if(btn.tag == ZCKeyboardOnClickAddPhotoPicture){
        // 图片
        [self getPhotoByType:1];
        
    }else if(btn.tag == ZCKeyboardOnClickAddPhotoCamera){
        //  相机
        [self getPhotoByType:2];
        
    }else if(btn.tag == ZCKeyboardOnClickLeavePage){
        [self hideKeyboard];
//        [self removeKeyboardObserver];
        // 去留言界面
        [self leaveMsgBtnAction:2];
    }
}


#pragma mark 页面点击事件 button
// 按钮事件
-(IBAction)buttonClick:(UIButton *)sender{
    if(sender.tag==BUTTON_CONNECT_USER){
        // 执行转人工操作
        [[ZCUICore getUICore] checkUserServiceWithObject:nil];
        
        // 此处回收键盘处理UI刷新
        [self hideKeyboard];
    } else if(sender.tag==BUTTON_ADDPHOTO){
        
        [self showMoreKeyboard:BUTTON_ADDPHOTO];
        _zc_addMoreButton.tag = BUTTON_ADDMORE;
        
        // ios9 弹出层会被键盘遮挡
        [_zc_chatTextView resignFirstResponder];
    }else if(sender.tag == BUTTON_ADDFACEVIEW){
        
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_keyboard_normal"] forState:UIControlStateNormal];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_keyboard_pressed"] forState:UIControlStateHighlighted];
        _zc_faceButton.tag = BUTTON_ToKeyboard;
        
        
        _zc_voiceButton.tag       = BUTTON_ADDVOICE;
        _zc_pressedButton.hidden = YES;
        _zc_chatTextView.hidden  = NO;
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
        
        // ios9 弹出层会被键盘遮挡
        [_zc_chatTextView resignFirstResponder];
        
        [self showMoreKeyboard:BUTTON_ADDFACEVIEW];
    }else if(sender.tag == BUTTON_ToKeyboard){
        _zc_pressedButton.hidden = YES;
        _zc_chatTextView.hidden  = NO;
        _zc_voiceButton.tag       = BUTTON_ADDVOICE;
        _zc_faceButton.tag       = BUTTON_ADDFACEVIEW;
        
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_normal"] forState:UIControlStateNormal];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_pressed"] forState:UIControlStateHighlighted];
        
        [_zc_chatTextView becomeFirstResponder];
        self.vioceTipLabel.hidden = YES;
        [self textChanged:_zc_chatTextView];
    }else if(sender.tag == BUTTON_ADDVOICE){
        // 隐藏所有键盘
        [self hideKeyboard];
        
        _zc_pressedButton.hidden = NO;
        _zc_chatTextView.hidden  = YES;
        _zc_voiceButton.tag       = BUTTON_ToKeyboard;
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_keyboard_normal"] forState:UIControlStateNormal];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_keyboard_pressed"] forState:UIControlStateHighlighted];
        
    
        _zc_faceButton.tag       = BUTTON_ADDFACEVIEW;
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_normal"] forState:UIControlStateNormal];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_pressed"] forState:UIControlStateHighlighted];
        if (![self getZCLibConfig].isArtificial) {
            self.vioceTipLabel.hidden = NO;
            
            // 当前是否是仅人工排队   2. 当前是否开启 机器人语音转文字
            if ([self getZCLibConfig].type == 2 && [ZCUICore getUICore].kitInfo.isOpenRobotVoice && curKeyBoardStatus == WAITSTATUS) {
                self.zc_waitLabel.hidden = YES;
            }
        }
        
    }else if (sender.tag == BUTTON_LEAVEMESSAGE){
        // 点击底部键盘上的留言按钮不直接退出SDK
        [self hideKeyboard];

        [self leaveMsgBtnActionType:LeaveExitTypeISNOCOLSE];
        
    }else if (sender.tag == BUTTON_SATISFACTION){
        // 满意度
        if ([ZCUICore getUICore].delegate  && [[ZCUICore getUICore].delegate respondsToSelector:@selector(onPageStatusChanged: message: obj:)]) {
            [[ZCUICore getUICore].delegate onPageStatusChanged:ZCShowStatusSatisfaction message:@"" obj:nil];
        }
    }else if (sender.tag == BUTTON_ADDMORE){
        _zc_addMoreButton.tag = BUTTON_ADDPHOTO;
        [self hideKeyboard];
    }
}



-(ZCKeyboardViewStatus) getKeyBoardViewStatus{
    return curKeyBoardStatus;
}


-(id)initConfigView:(UIView *)unitView table:(UITableView *)listTable{
    self = [self init];
    if(self){
        _zc_sourceView      = unitView;
        _zc_listTable       = listTable;
        
        [self zc_bottomView];
        // 顶部线条
        UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self getSourceViewWidth], 0.75f)];
        lineView.backgroundColor = [ZCUITools zcgetBackgroundBottomLineColor];
        [lineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        [_zc_sourceView addSubview:lineView];
        
        [self zc_chatTextView];
        [self zc_turnButton];
        [self zc_pressedButton];
        
        //    [self zc_leaveMsgBtn];
        
        [self zc_turnButton];
        
        [self zc_voiceButton];
        
        [self zc_addMoreButton];
        
        [self zc_faceButton];
        
        /** 添加满意度的背景View */
        [self zc_sessionBgView];
        
        /** 加载动画小菊花 */
        [self zc_activityView];
        
        // 排队中
        [self zc_waitLabel];
        
        
        // 创建表情键盘
        [self createEmojiView];
        
        
        // 创建机器人提示语View
        [self createVioceTipLabel];
    }
    return self;
}

-(void)setInitConfig:(ZCLibConfig *)config{
    
    if (config.type != 2) {
        self.zc_bottomView.hidden = NO;
    }
    
    if(config.isArtificial){
        [self setKeyBoardStatus:ZCKeyboardStatusUser];
        
        return;
    }
    
    // 被拉黑，不能点击转人工,仅机器人，不是转人工，是留言 [ZCIMChat getZCIMChat].waitMessage!=nil
    if((config.isblack && config.type > 1) || [[ZCPlatformTools sharedInstance] getPlatformInfo].waitintMessage!=nil){
        if (config.type == 2) {
            if ([[ZCPlatformTools sharedInstance] getPlatformInfo].waitintMessage!=nil) {
                [self setKeyBoardStatus:ZCKeyboardStatusWaiting];
                self.zc_bottomView.hidden = NO;
            }else{
                [self setKeyBoardStatus:ZCKeyboardStatusNewSession];
            }
            
        }else{
            [self setKeyBoardStatus:ZCKeyboardStatusRobot];
        }
        return;
    }
    
    // 仅机器人模式
    if (config.type == 1) {
        
        _zc_chatTextView.hidden  = NO;
        _zc_turnButton.hidden  = YES;
        _zc_pressedButton.hidden = YES;
        _zc_addMoreButton.hidden   = NO;
        
        if ([self getZCLibConfig].msgFlag == 0) {
            [_zc_chatTextView setFrame:CGRectMake(10, (BottomHeight-35)/2, [self getSourceViewWidth]-48-10, 35)];
        }else{
            _zc_leaveMsgButton.hidden = YES;
            [_zc_chatTextView setFrame:CGRectMake(10, (BottomHeight-35)/2, [self getSourceViewWidth]-58, 35)];
        }
        
        [self createMoreView];
        [[ZCUICore getUICore] keyboardOnClickAddRobotHelloWolrd];

        curKeyBoardStatus = ZCKeyboardStatusRobot;
        _zc_sessionBgView.hidden = YES;
    }
    if (config.type == 3) {// 3.智能客服-机器人优先    // && self.isShowConnectedButton == 0  isShowTurnBtn记录在会话保持的状态下是否之前显示转人工按钮（一次有效会话之内）

        [self setKeyBoardStatus:ZCKeyboardStatusRobot];
        if (![ZCUICore getUICore].kitInfo.isShowTansfer && ![ZCLibClient getZCLibClient].isShowTurnBtn) {
            // 设置textview的frame
            [_zc_chatTextView setFrame:CGRectMake(10, (BottomHeight-35)/2, [self getSourceViewWidth]-68, 35)];
            
            // 开启语音的功能   机器人开启语音识别
            if ([ZCUITools zcgetOpenRecord] && [ZCUICore getUICore].kitInfo.isOpenRobotVoice) {
                
                [_zc_chatTextView setFrame:CGRectMake(48 , (BottomHeight-35)/2, [self getSourceViewWidth]-48*2-5, 35)];
                // 显示语音按钮
                _zc_voiceButton.frame = CGRectMake(0, 0, 48, 49);
                
                _zc_voiceButton.hidden = NO;
            }
            
            //设置按钮显示
            _zc_turnButton.hidden    = YES;
            _zc_chatTextView.hidden  = NO;
            _zc_pressedButton.hidden = YES;
            _zc_addMoreButton.hidden   = NO;
            _zc_leaveMsgButton.hidden   = YES;
        }
    }
    if(config.type==4 || config.type==2 || config.ustatus == 1 || ([ZCLibClient getZCLibClient].libInitInfo.serviceMode!=1 && config.ustatus == -2)){
        // 人工优先，直接执行转人工,  ##2 仅人工   ,ustatus，说明断线后用户还在线  //仅机器人模式排队不在去执行转人工操作
        // 如果显示在线或者排队中，自动转接到人工
        if(config.ustatus == 1|| config.ustatus == -2){
//            if(_delegate && [_delegate respondsToSelector:@selector(keyboardItemClick:object:)]){
//                [_delegate keyboardItemClick:ZCKeyboardOnClickTurnUser object:@"isinitiativeTurn"];
//            }
            [ZCUICore getUICore].isShowForm = YES;
            [[ZCUICore getUICore] checkUserServiceWithObject:@"isinitiativeTurn"];
        }else{
            [[ZCUICore getUICore] checkUserServiceWithObject:nil];
        }
    }
    //
    _zc_activityView.hidden = YES;
    [_zc_activityView stopAnimating];

}


#pragma mark -- 设置键盘样式
-(void)setKeyBoardStatus:(ZCKeyboardViewStatus)status{
    // 设置键盘时设置默认状态
    _zc_faceButton.hidden     = YES;
    _zc_waitLabel.hidden      = YES;
    [_zc_activityView stopAnimating];
    _zc_addMoreButton.hidden    = YES;
    _zc_turnButton.hidden     = YES;
    _zc_pressedButton.hidden  = YES;
    _zc_chatTextView.hidden   = YES;
    _zc_sessionBgView.hidden  = YES;
    _zc_voiceButton.hidden  = YES;
    
    curKeyBoardStatus = status;
    
    
    _zc_voiceButton.tag       = BUTTON_ADDVOICE;
    _zc_faceButton.tag       = BUTTON_ADDFACEVIEW;
    [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
    [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
    [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_normal"] forState:UIControlStateNormal];
    [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_pressed"] forState:UIControlStateHighlighted];
    
    switch (status) {
#pragma mark -- 人工 ***************************************************************************************
        case SERVERV_KEYBOARD_STATUS:
            _zc_chatTextView.hidden   = NO;
            _zc_addMoreButton.hidden  = NO;
            _vioceTipLabel.hidden = YES;
            // 是否显示表情按钮
            CGFloat buttonX = 48;
            if([ZCUITools allExpressionArray] && [ZCUITools allExpressionArray].count > 0){
                buttonX = 48 * 2;
                _zc_faceButton.hidden     = NO;
            }
            
            // 是否显示语音按钮
            if([ZCUITools zcgetOpenRecord]){
                //                 设置按钮未转键盘
                _zc_voiceButton.tag = BUTTON_ADDVOICE;
                [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
                [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
                _zc_voiceButton.hidden     = NO;
                
                
                if(ZC_iPhoneX){
                    [_zc_chatTextView setFrame:CGRectMake(48, 10, [self getSourceViewWidth]-buttonX - 48, 35)];
                }else{
                    [_zc_chatTextView setFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-buttonX - 48, 35)];
                }
                
                CGRect voiceF = _zc_voiceButton.frame;
                voiceF.origin.x = 0;
                [_zc_voiceButton setFrame:voiceF];
            }else{
                _zc_voiceButton.hidden     = YES;
                
                if(ZC_iPhoneX){
                    [_zc_chatTextView setFrame:CGRectMake(48, 10, [self getSourceViewWidth]-buttonX - 48, 35)];
                }else{
                    [_zc_chatTextView setFrame:CGRectMake(48, (BottomHeight-35)/2, [self getSourceViewWidth]-buttonX - 48, 35)];
                }
            }
            // 重新设定 “按住 说话” 的frame
            [_zc_pressedButton setFrame:_zc_chatTextView.frame];
            
            // 从新设置更多的键盘中按钮的样式
            [self createMoreView];
            break;
            
        case NEWSESSION_KEYBOARD_STATUS:
#pragma mark -- 新会话  ***************************************************************************************
            [self hideKeyboard];
            [_zc_chatTextView setText:@""];
            [self textChanged:_zc_chatTextView];
            // 开始新会话
            [self showStatusView];
            _zc_againAccessBtn.hidden = NO;
            _zc_sessionBgView.hidden  = NO;
            
            break;
        case WAITSTATUS:
#pragma metk -- 排队中  ***************************************************************************************
            
            [_zc_chatTextView setText:@""];
            [self textChanged:_zc_chatTextView];
            // 排队键盘样式
            _zc_addMoreButton.hidden    = NO;
            _zc_turnButton.hidden       = NO;
            _zc_waitLabel.hidden        = NO;
            break;
        case ROBOT_KEYBOARD_STATUS:
#pragma mark -- 机器人 ***************************************************************************************
            
            // 从新设置更多的键盘中按钮的样式
            [self createMoreView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 当新会话按钮出现的时候 键盘回收
                [self hideKeyboard];
            });
            
            // 设置textview的frame 默认值
            if(ZC_iPhoneX){
                    [_zc_chatTextView setFrame:CGRectMake(48 * 2,10, [self getSourceViewWidth]-48*3-5, 35)];
            }else{
                [_zc_chatTextView setFrame:CGRectMake(48 * 2, (BottomHeight-35)/2, [self getSourceViewWidth]-48*3-5, 35)];
            }
            
            _zc_voiceButton.frame = CGRectMake(48, 0, 48, 49);
            _zc_voiceButton.hidden = NO;
            
            [_zc_turnButton setImageEdgeInsets:UIEdgeInsetsMake(10.5, 15, 10.5, 5)];
            
            // 开启语音的功能   机器人开启语音识别  TODO ![self getZCLibConfig].isOpenRobotVoice
            if (![ZCUITools zcgetOpenRecord] ||![ZCUICore getUICore].kitInfo.isOpenRobotVoice ) {
                
                [_zc_turnButton setImageEdgeInsets:UIEdgeInsetsMake(10.5, 10, 10.5, 10)];
                if(ZC_iPhoneX){
                    [_zc_chatTextView setFrame:CGRectMake(48 , 10, [self getSourceViewWidth]-48*2-5, 35)];
                }else{
                    [_zc_chatTextView setFrame:CGRectMake(48 , (BottomHeight-35)/2, [self getSourceViewWidth]-48*2-5, 35)];
                }
                
                // 显示语音按钮
                _zc_voiceButton.hidden = YES;
            }
            
            // 重新设定 “按住 说话” 的frame
            [_zc_pressedButton setFrame:_zc_chatTextView.frame];
            
            //设置按钮显示
            _zc_turnButton.hidden     = NO;
            _zc_chatTextView.hidden   = NO;
            _zc_addMoreButton.hidden    = NO;
            break;
    }
    
    
}

-(void)setZCChatNavHeight:(CGFloat)height{
    navHeight = height;
}


-(ZCPlatformInfo *) getPlatformInfo{
    return [[ZCPlatformTools sharedInstance] getPlatformInfo];
}


#pragma mark 发送监听 UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        //        [textView resignFirstResponder];
        
        [self doSendMessage:NO];
        return NO;
    }
    
//    [ZCLogUtils logHeader:LogHeader debug:@"%@",[[UITextInputMode currentInputMode]primaryLanguage]];
    // 不输入Emoji
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    
    if([text length]==0){
        if(range.length<1){
            return YES;
        }else{
            [self textChanged:_zc_chatTextView];
        }
    }
    
    return YES;
}

#pragma mark textChanged
-(void)textChanged:(id) sender{
    [self textViewDidChange:_zc_chatTextView];
    
}

//
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(![textView.window isKeyWindow]){
        [textView.window makeKeyAndVisible];
    }
    //    WSLog(@"键盘开始输入=====");
    
    // 当textview开始编辑的时候 影藏 _phototView
    [UIView animateWithDuration:0.25 animations:^{
        
    } completion:^(BOOL finished) {
        CGFloat moreHeight = MoreViewHeight;
        CGFloat emojiViewHeight = EmojiViewHeight;
        if ([self getSourceViewHeight] < [self getSourceViewWidth]) {
            moreHeight = MoreViewHorizontalHeight;
            emojiViewHeight = EmojiViewHorizontalHeight;
        }
        // 恢复原始值
        _zc_moreView.frame = CGRectMake(0, [self getSourceViewHeight], [self getSourceViewWidth], moreHeight);
        _zc_emojiView.frame = CGRectMake(0, [self getSourceViewHeight], [self getSourceViewWidth], emojiViewHeight);
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isEnableAutoTips"] && ![self getZCLibConfig].isArtificial && _zc_chatTextView.text.length>0) {
            [UIView animateWithDuration:0.3 animations:^{
                [[ZCAutoListView getAutoListView] showWithText:_zc_chatTextView.text rect:_zc_bottomView.frame];
                [ZCAutoListView getAutoListView].CellClick = ^(NSString *text) {
                    [self sendMessageOrFile:text type:ZCMessageTypeText duration:@""];
                    [_zc_chatTextView setText:@""];
                    [self textChanged:_zc_chatTextView];
                };
            }];
        }
        
    }];
    _zc_addMoreButton.tag = BUTTON_ADDPHOTO;
    _zc_faceButton.tag  = BUTTON_ADDFACEVIEW;
}
-(void)textViewDidChange:(UITextView *)textView{

    CGFloat textContentSizeHeight=_zc_chatTextView.contentSize.height;
    if (iOS7) {
        CGRect textFrame=[[_zc_chatTextView layoutManager]usedRectForTextContainer:[_zc_chatTextView textContainer]];
        textContentSizeHeight = textFrame.size.height;
        textContentSizeHeight=textContentSizeHeight+10;
    }
    //发送完成重置
    if(_zc_chatTextView.text==nil || [@"" isEqual:_zc_chatTextView.text]){
        textContentSizeHeight=35;
        [_zc_chatTextView setContentOffset:CGPointMake(0, 0)];
    }
    
    // 判断文字过小
    if(textContentSizeHeight<35){
        textContentSizeHeight=35;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isEnableAutoTips"] && ![self getZCLibConfig].isArtificial) {
        [[ZCAutoListView getAutoListView] showWithText:_zc_chatTextView.text rect:_zc_bottomView.frame];
        [ZCAutoListView getAutoListView].CellClick = ^(NSString *text) {
            [self sendMessageOrFile:text type:ZCMessageTypeText duration:@""];
            [_zc_chatTextView setText:@""];
            [self textChanged:_zc_chatTextView];
        };
    }
    
    
    // 已经最大行高了
    if (textContentSizeHeight > [self getTextMaxHeiht] && _zc_chatTextView.frame.size.height >= [self getTextMaxHeiht]) {
        [_zc_chatTextView setContentOffset:CGPointMake(0, textContentSizeHeight-_zc_chatTextView.frame.size.height)];
        return;
    }
    
    
    CGRect footFrame = _zc_bottomView.frame;
    CGRect textFrame = _zc_chatTextView.frame;
   
    
    footFrame.origin.y = [self getSourceViewHeight] - _zc_keyBoardHeight - BottomHeight ;
    footFrame.size.height = BottomHeight;
    CGFloat lastHeight = textFrame.size.height;
    textFrame.size.height = 35;
    
    // 计算应该改变多少行高
    if(textContentSizeHeight>35){
        float x=textContentSizeHeight-35;
        if(textContentSizeHeight>[self getTextMaxHeiht]){
            x = [self getTextMaxHeiht] - 35;
        }
        footFrame.origin.y=footFrame.origin.y-x;
        footFrame.size.height=footFrame.size.height+x;
        textFrame.size.height = textFrame.size.height+x;
    }
    
    // 已经更改过了
    if(lastHeight == textFrame.size.height){
        return;
    }
    
    // 必须是animated YES
    [_zc_chatTextView setContentOffset:CGPointMake(0,textContentSizeHeight-textFrame.size.height) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        [ZCUICore getUICore].isUpFrame = YES;
        _zc_bottomView.frame = footFrame;
        _zc_chatTextView.frame = textFrame;
        
        CGFloat ch=_zc_listTable.contentSize.height;
        CGFloat h=_zc_listTable.bounds.size.height;
//        [ZCLogUtils logHeader:LogHeader debug:@"当前滚动的高度：%f,%f",ch,h];
        CGRect tf         = _zc_listTable.frame;
        CGFloat x=tf.size.height-_zc_listTable.contentSize.height;
        if(x > 0){
            if(x<_zc_keyBoardHeight){
                tf.origin.y = NavBarHeight - (_zc_keyBoardHeight - x);
            }
        }else{
            tf.origin.y   = NavBarHeight - _zc_keyBoardHeight;
        }
        _zc_listTable.frame  = tf;
        if(ch > h){
            [_zc_listTable setContentOffset:CGPointMake(0,(_zc_chatTextView.frame.size.height-35)+ ch-h) animated:NO];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isEnableAutoTips"] && ![self getZCLibConfig].isArtificial) {
            [[ZCAutoListView getAutoListView] showWithText:_zc_chatTextView.text rect:_zc_bottomView.frame];
            [ZCAutoListView getAutoListView].CellClick = ^(NSString *text) {
                [self sendMessageOrFile:text type:ZCMessageTypeText duration:@""];
                [_zc_chatTextView setText:@""];
                [self textChanged:_zc_chatTextView];
            };
        }
    }];
}

-(int)getTextLines{
    CGSize lineSize = [_zc_chatTextView.text sizeWithFont:_zc_chatTextView.font];
    return ceil(_zc_chatTextView.contentSize.height/lineSize.height);
}

-(CGFloat) getTextMaxHeiht{
    CGSize lineSize = [_zc_chatTextView.text sizeWithFont:_zc_chatTextView.font];
    return lineSize.height*6+12;
}

#pragma mark 键盘隐藏 keyboard notification
-(void)hideKeyboard{
    _zc_addMoreButton.tag = BUTTON_ADDPHOTO;
    
//    [_zc_listTable removeGestureRecognizer:tapRecognizer];
    [UIView animateWithDuration:0.25 animations:^{
        [_zc_chatTextView resignFirstResponder];
        
        _zc_keyBoardHeight = 0;
        
        CGRect pf         = _zc_moreView.frame;
        pf.origin.y       = [self getSourceViewHeight];
        _zc_moreView.frame  = pf;
        
        CGRect ff         = _zc_emojiView.frame;
        ff.origin.y       = [self getSourceViewHeight];
        _zc_emojiView.frame  = ff;
        
        CGRect bf         = _zc_bottomView.frame;
        CGFloat botttomHight = 0;
        if (ZC_iPhoneX) {
            CGFloat sbh = SysScreenHeight - [self getSourceViewHeight]-_zc_sourceView.frame.origin.y;
            if(sbh < 34){
                botttomHight = 34;
            }
        }
        
        bf.origin.y       = [self getSourceViewHeight]-bf.size.height- (iOS7?0:20)  - botttomHight;

        _zc_bottomView.frame = bf;
        
        CGRect tf         = _zc_listTable.frame;
        tf.origin.y = _zc_sourceView.frame.size.height - BottomHeight - tf.size.height;
        _zc_listTable.frame  = tf;
    
        if (!_vioceTipLabel.hidden) {
            CGRect TF = _vioceTipLabel.frame;
            TF.origin.y =  _zc_bottomView.frame.origin.y - _vioceTipLabel.frame.size.height;
            _vioceTipLabel.frame = TF;
        }
        
        [[ZCAutoListView getAutoListView] dissmiss];
    }];

    
    
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 横屏需要添加 keyboardFrameDidChange监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];

    tapRecognizer.delegate  =self;
    _zc_sourceView.userInteractionEnabled=YES;
}

#pragma mark 手势代理 冲突的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view superclass]) isEqualToString:@"UIResponder"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"ZCMLEmojiLabel"]) {
        [self performSelector:@selector(hideKeyboard) withObject:nil afterDelay:0.35];
        return NO;
    }

    return YES;
}


-(void)removeKeyboardObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(CGFloat) getSourceViewHeight{
    return _zc_sourceView.frame.size.height;
}

-(CGFloat) getSourceViewWidth{
    return _zc_sourceView.frame.size.width;
}


-(void)keyboardFrameDidChange:(NSNotification*)notice{
    NSDictionary * userInfo = notice.userInfo;
    NSValue * endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameValue.CGRectValue;
    NSLog(@"%@",NSStringFromCGRect(endFrame));
}

//键盘显示
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    _zc_keyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    // 根据控件的位置，判断键盘的高度
//    CGFloat sbh = SysScreenHeight - [self getSourceViewHeight]-_zc_sourceView.frame.origin.y;
//    if(sbh > 0){
//        if(sbh < _zc_keyBoardHeight){
//            _zc_keyBoardHeight = _zc_keyBoardHeight - sbh;
//        }else{
//            _zc_keyBoardHeight = 0;
//        }
//    }
    
    // 还原表情和更多按钮样式
    if ([self getZCLibConfig].isArtificial) {
        _zc_voiceButton.tag       = BUTTON_ADDVOICE;
        _zc_faceButton.tag       = BUTTON_ADDFACEVIEW;
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_normal"] forState:UIControlStateNormal];
        [_zc_voiceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_voice_pressed"] forState:UIControlStateHighlighted];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_normal"] forState:UIControlStateNormal];
        [_zc_faceButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_expression_pressed"] forState:UIControlStateHighlighted];
    }
    
    // 根据控件的位置，判断键盘的高度
//    CGFloat sybh = SysScreenHeight - [self getSourceViewHeight]-_zc_sourceView.frame.origin.y;
//    if(sybh > 0){
//        if(sybh < _zc_keyBoardHeight){
//            _zc_keyBoardHeight = _zc_keyBoardHeight - sybh;
//        }else{
//            _zc_keyBoardHeight = 0;
//        }
//    }
    
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    // get a rect for the view frame
    
    {
        CGFloat bh         = BottomHeight + (_zc_chatTextView.frame.size.height-35);
        CGRect tf          = _zc_listTable.frame;
        
        CGFloat x = tf.size.height - _zc_listTable.contentSize.height;
        CGFloat SH = StatusBarHeight;
        CGFloat bottomH = 0;
        if (ZC_iPhoneX ) {
            SH = 0;
            bottomH = 34;
        }
        if(x > 0){
            if(x<_zc_keyBoardHeight){
                tf.origin.y = navHeight - (_zc_keyBoardHeight - x)-(bh-BottomHeight) ;
            }
        }else{
            tf.origin.y   = navHeight - _zc_keyBoardHeight-(bh-BottomHeight -bottomH);
        }
        
        _zc_listTable.frame  = tf;
        CGRect bf         = _zc_bottomView.frame;
        
        bf.origin.y       = [self getSourceViewHeight] - bh - _zc_keyBoardHeight - SH;
        bf.size.height    = bh;
        _zc_bottomView.frame = bf;
        
    }
    
    // commit animations
    [UIView commitAnimations];
    [_zc_listTable addGestureRecognizer:tapRecognizer];
}

//屏幕点击事件
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self hideKeyboard];
}


//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _zc_keyBoardHeight = 0;
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.25 animations:^{
        if(_zc_addMoreButton.tag != BUTTON_ADDMORE && _zc_faceButton.tag != BUTTON_ToKeyboard){
            CGRect tf         = _zc_listTable.frame;
            tf.origin.y       = navHeight-(_zc_bottomView.frame.size.height-BottomHeight);
            _zc_listTable.frame  = tf;
            
            
            CGRect bf         = _zc_bottomView.frame;
            bf.origin.y       = [self getSourceViewHeight] - bf.size.height - StatusBarHeight;
            _zc_bottomView.frame = bf;
        }
    }];
    
//    [_zc_listTable removeGestureRecognizer:tapRecognizer];
}


#pragma mark 发送图片相关
/**
 *  选择获取图片方式代理
 *
 *  @param buttonIndex 选择的index
 *  @param tag         当前的控件tag
 */
-(void)didClickOnButtonIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    [self getPhotoByType:buttonIndex];
}

// 系统选择图片代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self getPhotoByType:buttonIndex];
}

/**
 *  根据类型获取图片
 *
 *  @param buttonIndex 2，来源照相机，1来源相册
 */
-(void)getPhotoByType:(NSInteger) buttonIndex{
    _zc_imagepicker = nil;
    _zc_imagepicker = [[UIImagePickerController alloc]init];
    _zc_imagepicker.delegate = self;
    [ZCSobotCore getPhotoByType:buttonIndex byUIImagePickerController:_zc_imagepicker Delegate:[self getCurrentVC]];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_zc_imagepicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    __weak  ZCUIKeyboard *keyboardSelf  = self;
    [ZCSobotCore imagePickerController:_zc_imagepicker didFinishPickingMediaWithInfo:info WithView:_zc_sourceView Delegate:_ppView.window.rootViewController block:^(NSString *filePath, ZCMessageType type, NSString *duration) {
        [keyboardSelf sendMessageOrFile:filePath type:type duration:duration];
    }];
}

// 解决ios7调用系统的相册时出现的导航栏透明的情况
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma 录音相关事件触发
-(void)btnTouchDown:(id)sender{
    
    [ZCLogUtils logHeader:LogHeader debug:@"按下了"];
    
    
    if (![ZCUITools isOpenVoicePermissions]) {
        NSString *meg = @"";
        NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
        if (AppName != nil) {
//            meg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-麦克风”选项中，允许%@访问你的麦克风",AppName];
            meg = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:ZCSTLocalString(@"请在iPhone的“设置-隐私-麦克风”选项中，允许%@访问你的麦克风"),AppName]];
        }else{
            meg = ZCSTLocalString(@"请在iPhone的“设置-隐私-麦克风”选项中，允许访问你的麦克风");
        }
       
        [[[UIAlertView alloc] initWithTitle:ZCSTLocalString(@"麦克风被禁用") message:meg delegate:nil cancelButtonTitle:ZCSTLocalString(@"好") otherButtonTitles:nil] show];
        return;
    }

    if(_zc_recordView!=nil){
        return;
    }
    if(_zc_recordView==nil){
        _zc_recordView=[[ZCUIRecordView alloc] initRecordView:self cView:_zc_sourceView];
        [_zc_recordView showInView:_zc_sourceView];
    }
    
    [_zc_recordView didChangeState:RecordStart];
    
    [_zc_pressedButton setBackgroundColor:UIColorFromRGB(BgTextEditColor)];
    
    [_zc_pressedButton setTitle:ZCSTLocalString(@"松开 发送") forState:UIControlStateNormal];
    [_zc_pressedButton.layer setBorderWidth:0.0f];
    
    _zc_voiceButton.enabled=NO;
    _zc_addMoreButton.enabled=NO;
    _zc_faceButton.enabled = NO;

}
-(void)btnTouchDownRepeat:(id)sender{
    
    [ZCLogUtils logHeader:LogHeader debug:@"按下了,重复了"];
}
-(void)btnTouchMoved:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit
            
            [ZCLogUtils logHeader:LogHeader debug:@"拖出了"];
            
            // 暂停，抬起就取消
            [_zc_recordView didChangeState:RecordPause];
            [_zc_pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
            
            [_zc_pressedButton setTitle:ZCSTLocalString(@"松开手指，取消发送") forState:UIControlStateNormal];
        } else {
            // UIControlEventTouchDragOutside
            
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
            
            [ZCLogUtils logHeader:LogHeader debug:@"拖入"];
            
            // 接着录音
            [_zc_recordView didChangeState:RecordStart];
            
            [_zc_pressedButton setBackgroundColor:UIColorFromRGB(BgTextEditColor)];
            
            [_zc_pressedButton setTitle:ZCSTLocalString(@"松开 发送") forState:UIControlStateNormal];
        } else {
            // UIControlEventTouchDragInside
        }
    }
}


-(void)btnTouchCancel:(UIButton *)sender{
    
    [ZCLogUtils logHeader:LogHeader debug:@"取消"];
    if(_zc_recordView){
        // 取消发送
        [_zc_recordView didChangeState:RecordCancel];
        
        //停止录音
        [self closeRecord:sender];
    }
}
-(void)btnTouchEnd:(UIButton *)sender withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
        [ZCLogUtils logHeader:LogHeader debug:@"取消ccc"];
        
        if(_zc_recordView){
            // 取消发送
            [_zc_recordView didChangeState:RecordCancel];
            [self closeRecord:sender];
        }
    } else {
        // UIControlEventTouchUpInside
        [ZCLogUtils logHeader:LogHeader debug:@"结束了"];
        
        // 发送
        [_zc_recordView didChangeState:RecordComplete];
        [self closeRecord:sender];
    }
}

-(void)closeRecord:(UIButton *) sender{
    //停止录音
    
    int duration = (int)_zc_recordView.currentTime;
    [_zc_recordView dismissRecordView];
    _zc_recordView = nil;
    
    [_zc_pressedButton setBackgroundColor:[UIColor clearColor]];
    [_zc_pressedButton setTitle:ZCSTLocalString(@"按住 说话") forState:UIControlStateNormal];
    // 设置_pressedButton边界宽度
    _zc_pressedButton.layer.borderWidth = 0.75f;
    _zc_voiceButton.enabled=YES;
    _zc_addMoreButton.enabled=YES;
    _zc_faceButton.enabled = YES;
    if(duration<1){
        
        [ZCLogUtils logHeader:LogHeader debug:@"当前的时长：%d",duration];
        
        sender.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
    }
}


#pragma mark 录音完成，上传录音
-(void)recordComplete:(NSString *)filePath videoDuration:(CGFloat)duration{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:duration];
    NSString *time=zcLibDateTransformString(@"mm:ss", date);
    [self sendMessageOrFile:filePath type:ZCMessageTypeSound duration:time];
}


- (void)recordCompleteType:(RecordState )type videoDuration:(CGFloat)duration{
    if (type == RecordStart) {
           [[ZCUICore getUICore] sendMessage:@"" questionId:@"" type:ZCMessagetypeStartSound duration:[NSString stringWithFormat:@"%zd",duration]];
        }else if(type == RecordCancel){
            [[ZCUICore getUICore] sendMessage:@"" questionId:@"" type:ZCMessagetypeCancelSound duration:[NSString stringWithFormat:@"%zd",duration]];
        }
}


#pragma mark -- 发送文本消息
-(void)doSendMessage:(BOOL) isReSend{
    NSString *text = _zc_chatTextView.text;
    // 过滤Emoji表情
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if(substring.length==2){
            _zc_chatTextView.text=[_zc_chatTextView.text stringByReplacingOccurrencesOfString:substring withString:@""];
        }else{
            // 特殊Emoji，如搜狗输入法中的
            const unichar hs = [substring characterAtIndex:0];
            BOOL returnValue=NO;
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
            
            if(returnValue){
                _zc_chatTextView.text=[_zc_chatTextView.text stringByReplacingOccurrencesOfString:substring withString:@""];
            }
        }
    }];
   //  可能过滤了Emoji，所以重新赋值
    text=_zc_chatTextView.text;
    
    // 过滤空格
    text = zcLibTrimString(text);
    if([@"" isEqual:zcLibConvertToString(text)]){
        [_zc_chatTextView setText:@""];
        [self textChanged:_zc_chatTextView];
        return;
    }
    
    if(_isConnectioning){
        return;
    }
    
    [self sendMessageOrFile:text type:ZCMessageTypeText duration:@""];
    
    [_zc_chatTextView setText:@""];
    [self textChanged:_zc_chatTextView];
}

-(void) sendMessageOrFile:(NSString *)filePath type:(ZCMessageType) type duration:(NSString *)duration{

    if (curKeyBoardStatus == NEWSESSION_KEYBOARD_STATUS) {
        // 发送提示消息“本次会话已结束”
        [[ZCUICore getUICore] addTipsListenerMessage:ZCKeyboardOnClickAddOverMsgTipCell];
        return;
    }
    [[ZCUICore getUICore]  sendMessage:filePath questionId:@"" type:type duration:duration];
}



#pragma mark -- 显示表情 和 更多
// 点击更多时的键盘样式
- (void)showMoreKeyboard:(BottomButtonClickTag) type{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //隐藏键盘
        [_zc_chatTextView resignFirstResponder];
        CGRect pf        = _zc_moreView.frame;
        CGRect bf        = _zc_bottomView.frame;
        CGRect tf        = _zc_listTable.frame;
        CGRect ff        = _zc_emojiView.frame;
        
        int bh           = 0;
        
        //显示表情
        if(type==BUTTON_ADDFACEVIEW){
            CGFloat emojiViewH = EmojiViewHeight;
            if ([self getSourceViewHeight] < [self getSourceViewWidth]) {
                emojiViewH = EmojiViewHorizontalHeight;
            }
            bh = emojiViewH;
            
            ff.origin.x=0;
            ff.origin.y=[self getSourceViewHeight]-bh;
            _zc_emojiView.frame=ff;
            
            pf.origin.y=[self getSourceViewHeight];
            _zc_moreView.frame=pf;
        }else if(type==BUTTON_ADDPHOTO){
            //显示更多
            CGFloat moreHeight = MoreViewHeight;
            if ([self getSourceViewHeight] < [self getSourceViewWidth]) {
                moreHeight = MoreViewHorizontalHeight;
            }
            bh = moreHeight;
            
            ff.origin.y=[self getSourceViewHeight];
            _zc_emojiView.frame=ff;
            
            pf.origin.y=[self getSourceViewHeight]-bh;
            _zc_moreView.frame=pf;
        }
        
        
        _zc_keyBoardHeight    = bh;
        
        bh         = BottomHeight + (_zc_chatTextView.frame.size.height-35);
        CGFloat x = tf.size.height-_zc_listTable.contentSize.height;
        if(x > 0){
            if(x<_zc_keyBoardHeight){
                tf.origin.y = navHeight - (_zc_keyBoardHeight - x)-(bh-BottomHeight);
            }
        }else{
            tf.origin.y   = navHeight - _zc_keyBoardHeight-(bh-BottomHeight);
        }
        _zc_listTable.frame  = tf;
        
        CGFloat SH = StatusBarHeight;
        if (ZC_iPhoneX) {
            SH = 0;
        }
        bf.origin.y       = [self getSourceViewHeight] - bh - _zc_keyBoardHeight - SH;// - StatusBarHeight
        bf.size.height    = bh;
        _zc_bottomView.frame = bf;
        
        if (!_vioceTipLabel.hidden) {
            CGRect TF = _vioceTipLabel.frame;
            TF.origin.y =  _zc_bottomView.frame.origin.y - _vioceTipLabel.frame.size.height;
            _vioceTipLabel.frame = TF;
        }

    } completion:^(BOOL finished) {
        // 回收键盘的手势记得要添加
        [_zc_listTable addGestureRecognizer:tapRecognizer];
    }];
}



/**
 显示 评价、新会话、留言状态View
 */
-(void)showStatusView{
    [_zc_sessionBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 当前页面使用自己添加的数据，不从接口方法中获取，（预留接口，后期有变动在添加）
    // 标题和tag
    NSMutableArray * titleArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * tagArr = [NSMutableArray arrayWithCapacity:0];
    
    // 是否添加满意度的按钮，是否成功转人工成功过
    if ([self getZCLibConfig].type ==2 && ![self getZCLibConfig].isArtificial) {
        // 仅人工，没有转成功人工不能评价
    }else{
        [titleArray  addObject:@"评价"];
        [tagArr addObject:[NSString stringWithFormat:@"%zd",BUTTON_SATISFACTION]];
    }
    
    [titleArray addObject:@"新会话"];
    [tagArr addObject:[NSString stringWithFormat:@"%zd",BUTTON_RECONNECT_USER]];
    
    // 开启留言
    if ([self getZCLibConfig].msgFlag == 0) {
        [titleArray addObject:@"留言"];
        [tagArr addObject:[NSString stringWithFormat:@"%zd",BUTTON_LEAVEMESSAGE]];
    }
    
    [self creatNewAgainBtnForArray: titleArray tags: tagArr];
}


#pragma mark -- 创建新会话键盘样式
-(void)creatNewAgainBtnForArray:(NSMutableArray*)titleArr tags:(NSMutableArray *)tags{
    
    CGFloat itemH = 42;
    CGFloat itemW = 60;
    CGFloat itemY = 3;
    
    CGFloat itemX = 0;
    
    for (int i = 0; i< titleArr.count; i++) {
        int tag = [tags[i] intValue];
        
        itemX = ([self getSourceViewWidth]/titleArr.count)/2 + i*([self getSourceViewWidth]/titleArr.count) - itemW/2;
        
        ZCButton * zcbtns = [ZCButton buttonWithType:UIButtonTypeCustom];
        zcbtns.frame = CGRectMake(itemX, itemY, itemW, itemH);
        if (tag == BUTTON_SATISFACTION) {
            [zcbtns setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_bottombar_satisfaction"] forState:UIControlStateNormal];
        }else if (tag == BUTTON_RECONNECT_USER){
            [zcbtns setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_bottombar_conversation"] forState:UIControlStateNormal];
        }else if (tag == BUTTON_LEAVEMESSAGE){
            [zcbtns setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_bottombar_message"] forState:UIControlStateNormal];
            
        }
        
        [zcbtns setTitle:titleArr[i] forState:UIControlStateNormal];
        zcbtns.titleLabel.font = [UIFont systemFontOfSize:12];
        zcbtns.tag = tag;
        [zcbtns addTarget:self action:@selector(btnClickForNewAgain:) forControlEvents:UIControlEventTouchUpInside];
        [zcbtns setTitleColor:UIColorFromRGB(0x838486) forState:UIControlStateNormal];
        zcbtns.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleLeftMargin;
        zcbtns.layer.cornerRadius = 4;
        zcbtns.layer.masksToBounds = YES;
        [_zc_sessionBgView addSubview:zcbtns];
    }
    
}

#pragma mark -- 执行 评价 满意度
-(void)btnClickForNewAgain:(ZCButton *)sender{
    if (sender.tag == BUTTON_SATISFACTION) {
        // 调评价页面
        [[ZCUICore getUICore] keyboardOnClickSatisfacetion:NO];
    }else if (sender.tag == BUTTON_RECONNECT_USER){
        [_zc_activityView startAnimating];
         //  要去初始化啊
        [[ZCUICore getUICore] initConfigData:YES IsNewChat:YES];
    }else if (sender.tag == BUTTON_LEAVEMESSAGE){
        [self hideKeyboard];
//        [self removeKeyboardObserver];
        // 点击bottom上的留言按钮 跳转到留言并提交 不直接退出SDK
        [self leaveMsgBtnAction:LeaveExitTypeISNOCOLSE];
    }
}

#pragma mark -- 留言事件

- (void)leaveMsgBtnActionType:(NSInteger) type {
    [self hideKeyboard];
//    [self removeKeyboardObserver];
    // 点击bottom上的留言按钮 跳转到留言并提交 不直接退出SDK
    [self leaveMsgBtnAction:LeaveExitTypeISNOCOLSE];
}

- (void)leaveMsgBtnAction:(LeaveExitType ) exitType {
    // 留言
    if ([ZCUICore getUICore].delegate && [[ZCUICore getUICore].delegate respondsToSelector:@selector(onPageStatusChanged: message: obj:)]) {
        [[ZCUICore getUICore].delegate onPageStatusChanged:ZCShowStatusLeaveMsgPage message:@"" obj:[NSString stringWithFormat:@"%zd",exitType]];
    }
    [self hideKeyboard];
}

- (void)dealloc{
//    NSLog(@"键盘被清理掉了");
    [self removeKeyboardObserver];
}

#pragma mark -- 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}




@end
