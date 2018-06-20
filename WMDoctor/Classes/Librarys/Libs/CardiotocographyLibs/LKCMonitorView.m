//
//  LKCMonitorView.m  监控界面
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-4.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//
#import "LKCMonitorView.h"
#import "UIView+Toast.h"
//#import "LKCBluetoothManager.h"
#import <AVFoundation/AVFoundation.h>
#import "LKCHeart.h"
#import "LKCOneRecord.h"
#import "NSString+LKC.h"
#import "STKAudioPlayer.h"
#import "LKCHistoryManager.h"
#import "UIAlertView+Blocks.h"
//#import "LKCFetalSet.h"
#import <MediaPlayer/MPVolumeView.h>
#import "AZSoundManager.h"
#import "LKCWrapper.h"
//#import "UpdataViewController.h"
//#import "LKCReplayViewController.h"

#import "TOCOTimeBgImg.h"

#define kHistoryScreen        @"HistoryScreen"
#define UserDefaults                        [NSUserDefaults standardUserDefaults]


@interface LKCMonitorView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) AZSoundManager *manager;
@property (nonatomic, strong) AZSoundItem *item;

@property (strong, nonatomic) IBOutlet UILabel *label1;             // 胎动文字
@property (strong, nonatomic) IBOutlet UILabel *label2;             // 胎心率文字
@property (strong, nonatomic) IBOutlet UILabel *label3;             //宫缩文字
@property (strong, nonatomic) IBOutlet UILabel *label4;             //录制和开始文字

@property (strong, nonatomic) UILabel * totalTime;  //总检测时间

@property (strong, nonatomic) IBOutlet UIImageView *voluemImage;    // 音量图片,喇叭
@property (strong, nonatomic) IBOutlet UIImageView *colock;         // 时钟图片
@property (strong, nonatomic) UIScrollView *subviewWrapper; //整个区域,包括数字区域和曲线区域,会把一些小控件加在上面
@property (strong, nonatomic) IBOutlet UIImageView *chartBG;//曲线背景，就是那个表格


@property (nonatomic, strong) LKCWrapper *wrapper; //弹出对话框

@property (nonatomic, assign) NSInteger totaltime;
@property (assign, nonatomic) int countL2N;
@property (assign, nonatomic) int counttest;


@property (assign, nonatomic) NSInteger tmpTocoOrNot;
@property (nonatomic , strong) NSString    *strWavepath;

@property (nonatomic , strong) NSMutableArray * bgImageArr;

@end

#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UI_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define ToastCenter [NSValue valueWithCGPoint:CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT/2)]
#define kScreen_height [[UIScreen mainScreen] bounds].size.height
#define kScreen_width [[UIScreen mainScreen] bounds].size.width

#define viewWidth(x)([[UIScreen mainScreen] bounds].size.width*x/750)
#define viewScaleWidth(x) (([[UIScreen mainScreen] bounds].size.width*x*1.0)/320)
#define viewScaleHeight(x) (([[UIScreen mainScreen] bounds].size.height*x*1.0)/568)

#define IS_IPHONE ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
#define IS_IPHONE_4 ( IS_IPHONE ? CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)) ? YES : NO : NO )

@implementation LKCMonitorView

/**
 * 如果手动创建了一个视图，分配了任何内存，存储了任何对象的应用，都要释放资源，必须实现dealloc方法。
 * 当某个对象的应用计数为0时，系统会调用其dealloc方法，去释放对象资源。不要自己调用哦！！！
 */
- (void)deallocMonitorView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [LKCPlayManager setDelegate:nil];
    
    [UserDefaults removeObjectForKey:@"lkcIsToCo"];
    [UserDefaults removeObjectForKey:@"isReplyMonitor"];
    [UserDefaults removeObjectForKey:@"FMcount"];
    
    [UserDefaults removeObjectForKey:@"zoomScale"] ;
    
    
}
-(void)dealloc{
    
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, (__bridge void *)self); //回放会有崩溃
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc %@",self.class);

}



//应用程序起来之后调用一次
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bgImageArr = [[NSMutableArray alloc] init];
        [UserDefaults setObject:@"4" forKey:@"zoomScale"];
        
        _tmpTocoOrNot = 1;
        
        [self createSubviewWithIsToCo:nil];//将所有小控件加到subviewWrapper中
        [self setupView];
        
        
        
        
        [LKCPlayManager setDelegate:self];
        /*这个非常重要，设置LKCPlayManager的方法，这样LKCPlayManager中的方法就可以在LKCMonitorView中实现了，有以下方法：
         - (void)currentPlaybackTimeChanged:(NSTimeInterval)currentTime;
         - (void)totalPlaybackTimeChanged:(NSTimeInterval)totalTime;
         - (void)playingStateChanged:(BOOL)playing;
         - (void)playerStoped:(BOOL)manual;
         - (void)audioDidFinishPlaying;
         */
        
    }
    return self;
}


//每进入一次记录就会调用一次
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

// 更改系统音量，setupView中设置监听
void volumeListenerCallback (
                             void                     *inClientData,
                             AudioSessionPropertyID   inID,
                             UInt32                   inDataSize,
                             const void               *inData
                             ){
    LKCMonitorView *THIS = (__bridge LKCMonitorView *)inClientData;
    const float*volumePointer = inData;
    float volume= *volumePointer * 100;
    
    if (THIS) {
        [THIS changeVolumeVolue:volume];
    }
}
-(void) changeVolumeVolue:(float) volume{
    self.volume.text = [NSString stringWithFormat:@"%d", (int)volume];
}

//initWithFrame中调用，将所有小控件加到subviewWrapper中
//下面的CGRectMake中的x,y值是没有用的，height跟width是有用的,x,y在layoutSubviews中设置
- (void)createSubviewWithIsToCo:(int)a
{
    CGFloat width = CGRectGetWidth(self.bounds);//320
    
    [self addSubview:self.vcBg];
    
    self.subviewWrapper = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, UI_SCREEN_HEIGHT +50)];
    self.subviewWrapper.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.subviewWrapper.contentSize = CGSizeMake(width, UI_SCREEN_HEIGHT + 50);
    self.subviewWrapper.delaysContentTouches = NO;//关闭“在一定事件内没有滑动scrollview，则响应内部控件”
    [self addSubview:self.subviewWrapper];
    
//    self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(150-5-160, 300, 120, 40)];
//    self.label4.textAlignment = NSTextAlignmentCenter;
//    self.label4.backgroundColor = [UIColor clearColor];
//    self.label4.textColor = [UIColor whiteColor];
    

    
//    self.colock = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 24)];
//    self.colock.image = [UIImage imageNamed:@"time"];
//    [self.subviewWrapper addSubview:self.colock];

    //新添内容开始

    //带宫缩
    self.img_bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 319, 155)];
    self.img_bg1.image = [UIImage imageNamed:@"bg_h1"];
    
        
    [self.subviewWrapper addSubview:self.img_bg1];
    
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    self.label1.backgroundColor = [UIColor clearColor];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.textColor = RGBA(234, 115, 172, 1);
    self.label1.text = @"胎动";
    [self.subviewWrapper addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 25)];
    self.label2.backgroundColor = [UIColor clearColor];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = RGBA(234, 115, 172, 1);
    self.label2.text = @"胎心率";
    [self.subviewWrapper addSubview:self.label2];
    
    //带宫缩
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    self.label3.backgroundColor = [UIColor clearColor];
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.textColor =RGBA(234, 115, 172, 1);
    self.label3.text = @"宫缩（10)";
    [self.subviewWrapper addSubview:self.label3];
    
    
    self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(150-5-160, 400-3, 120, 40)];
    self.label4.textAlignment = NSTextAlignmentCenter;
    self.label4.backgroundColor = [UIColor clearColor];
    self.label4.textColor = [UIColor whiteColor];
    
    //    if(_tmpTocoOrNot || isToco != 0){ 无宫缩时，无宫缩复位图标
//    self.tocoResetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    //        [self.subviewWrapper addSubview:self.tocoResetButton];
    //    }
    self.voluemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    self.voluemImage.image = [UIImage imageNamed:@"volume"];
    self.voluemImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.subviewWrapper addSubview:self.voluemImage];
    
    self.volume = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 21)];
    self.volume.backgroundColor = [UIColor clearColor];
    self.volume.textColor = [UIColor colorWithRed:0.945 green:0.557 blue:0.498 alpha:1.000];
    self.volume.font = [UIFont systemFontOfSize:17];
    [self.subviewWrapper addSubview:self.volume];
    
    self.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(272, 32, 28, 26)];
    self.heartImageView.image = [UIImage imageNamed:@"heart"];
    
    
    [self.subviewWrapper addSubview:self.heartImageView];
    
    //fm
    if (IS_IPHONE_4) {
        self.heartMove = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 55)];
        self.heartMove.font = [UIFont systemFontOfSize:38];
    } else {
        self.heartMove = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 55)];
        self.heartMove.font = [UIFont systemFontOfSize:35];
    }
    self.heartMove.backgroundColor = [UIColor clearColor];
    self.heartMove.textAlignment = NSTextAlignmentCenter;
    self.heartMove.textColor = [UIColor colorWithRed:0.945 green:0.557 blue:0.498 alpha:1.000];
    [self.subviewWrapper addSubview:self.heartMove];
    
    //toco
    
    if (IS_IPHONE_4) {
        self.tocoValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 55)];
        self.tocoValue.font = [UIFont systemFontOfSize:38];
    } else {
        self.tocoValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 55)];
        self.tocoValue.font = [UIFont systemFontOfSize:35];
    }
    self.tocoValue.backgroundColor = [UIColor clearColor];
    self.tocoValue.textAlignment = NSTextAlignmentCenter;
    self.tocoValue.textColor = [UIColor colorWithRed:0.945 green:0.557 blue:0.498 alpha:1.000];
    [self.subviewWrapper addSubview:self.tocoValue];
    
    //fhr
    if (IS_IPHONE_4) {
        self.heartRate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 75)];
        self.heartRate.font = [UIFont systemFontOfSize:38];
    } else {
        self.heartRate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 84)];
        self.heartRate.font = [UIFont systemFontOfSize:35];
    }
    
    self.heartRate.backgroundColor = [UIColor clearColor];
    self.heartRate.textAlignment = NSTextAlignmentCenter;
    self.heartRate.textColor = [UIColor colorWithRed:0.945 green:0.557 blue:0.498 alpha:1.000];
    [self.subviewWrapper addSubview:self.heartRate];
    
    self.heartAlarm = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 54)];
    self.heartAlarm.font = [UIFont systemFontOfSize:16];
    self.heartAlarm.backgroundColor = [UIColor clearColor];
    self.heartAlarm.textAlignment = NSTextAlignmentCenter;
    self.heartAlarm.textColor = [UIColor clearColor];
    [self.subviewWrapper addSubview:self.heartAlarm];
    
    
    self.colock = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 24)];
    self.colock.image = [UIImage imageNamed:@"time"];
    [self.subviewWrapper addSubview:self.colock];
    
    self.batteryValue = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 30)];
    self.batteryValue.image = [UIImage imageNamed:@"battery0"];
    [self.subviewWrapper addSubview:self.batteryValue];
    
    //新添内容结束
    
    // 心率曲线背景图
    /**************************************************************/
    //带宫缩
    
    self.chartBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 226, 319, 236)];
    self.chartBG.image = [UIImage imageNamed:@"chart_bg_v_toco"];

    self.chartBG.contentMode = UIViewContentModeScaleToFill;
    [self.subviewWrapper addSubview:self.chartBG];
    
    
    
    self.duration = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    self.duration.backgroundColor = [UIColor clearColor];
    self.duration.font = [UIFont systemFontOfSize:17];
    self.duration.textAlignment = NSTextAlignmentRight;
    self.duration.textColor = [UIColor colorWithRed:0.701 green:0.292 blue:0.420 alpha:1.000];
    self.duration.text = @"00:00";
    [self.subviewWrapper addSubview:self.duration];
    
    
    self.totalTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 21)];
    self.totalTime.backgroundColor = [UIColor clearColor];
    self.totalTime.font = [UIFont systemFontOfSize:17 ];
    self.totalTime.textAlignment = NSTextAlignmentLeft;
    self.totalTime.textColor = [UIColor colorWithRed:0.701 green:0.292 blue:0.420 alpha:1.000];
    [self.subviewWrapper addSubview:self.totalTime];
    
    
    self.offsetLine = [[UIView alloc] initWithFrame:CGRectMake(119, 236, 1, 250)];
    self.offsetLine.backgroundColor = RGBA(73, 179, 246, 1);
    [self  addSubview:self.offsetLine];
    
    // 心率曲线层
    self.drawWrapper = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 340, width, 250)];
    [self.subviewWrapper addSubview:self.drawWrapper];
    
    
    
    CGFloat imageW = 120;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = viewScaleHeight(250);
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    NSInteger totalCount = 120;
    //    /**************************************************************/
    //带宫缩
    int ratio = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 1;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 2;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio = 4;
    }
    
    //背景图
    for (int i = 0; i < totalCount; i++) {
        
        CGFloat imageX = i * imageW;
     TOCOTimeBgImg *  bgImageView = [[TOCOTimeBgImg alloc] initWithFrame: CGRectMake(imageX , imageY, imageW, imageH)];
        int j = 0 ;
        
        if (i %2 == 0 ) {
            j = 0;
        } else {
            j = 1;
        }
        
        bgImageView.timeLable.text = [NSString stringWithFormat:@"%d'",i*ratio] ;
        
        bgImageView.tag = 100 +i;
        [_bgImageArr addObject:bgImageView];
        bgImageView.image = [UIImage  imageNamed: [NSString stringWithFormat:@"img_0%d", j + 1]];
        [self.drawWrapper addSubview:bgImageView];
        
    }  ;
        

    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.drawWrapper.contentSize = CGSizeMake(contentW, 0);
    self.drawWrapper.showsHorizontalScrollIndicator = NO;
    self.drawWrapper.delegate = self;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]      initWithTarget:self action:@selector(scaGesture:)];
    [pinchRecognizer setDelegate:self];
    [self.drawWrapper addGestureRecognizer:pinchRecognizer];
    
    self.drawLayer = [[LKCDrawLayer alloc] initWithFrame:CGRectMake(0, 0, width, viewScaleHeight(250))];//[320 190]

    [self.drawWrapper addSubview:self.drawLayer];
    
    if (_isUpdateMonitor) {

        self.btnStartMonitor = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.subviewWrapper addSubview:self.btnStartMonitor];
        [self.btnStartMonitor setImage:[UIImage imageNamed:@"updateMonitorStart"] forState:UIControlStateNormal];
        
        
    } else {
        self.btnStartMonitor = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 60, 60)];
        [self.subviewWrapper addSubview:self.btnStartMonitor];
        
    }
    [self.subviewWrapper bringSubviewToFront: self.btnStartMonitor];


    self.btnStartMonitor.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    
    [self.subviewWrapper addSubview:self.label4];
    
    
    self.recordeDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 20)];
    self.recordeDate.textColor = [UIColor colorWithRed:0.701 green:0.292 blue:0.420 alpha:1.000];
    self.recordeDate.backgroundColor = [UIColor clearColor];
    self.recordeDate.font = [UIFont systemFontOfSize:13];
    
    self.recordeDate.textAlignment = NSTextAlignmentRight;
    [self.subviewWrapper addSubview:self.recordeDate];
    
    
    
}

//!重放
-(void)scaGesture:(id)sender {
    
    CGFloat scale =  [(UIPinchGestureRecognizer*)sender scale];
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if (scale > 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            BOOL state = [LKCPlayManager getPlayState];
            if (state) {
                [LKCPlayManager stop];
            }
            [UserDefaults setObject:@"2" forKey:@"zoomScale"];
            //            [self createSubviewWithIsToCo:1];此句导致缩放时内存激增，反复几次后 会闪退
            [self changeValueAbortBgView];
            [self setReplayRecord: _replayRecord ];
            [self setupView];
            [self makeToast:@"X2" duration:1.5 position:ToastCenter];
            
        } else if (scale > 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
            BOOL state = [LKCPlayManager getPlayState];
            if (state) {
                [LKCPlayManager stop];
            }
            
            [UserDefaults setObject:@"4" forKey:@"zoomScale"];
            //            [self createSubviewWithIsToCo:1];
            [self changeValueAbortBgView];
            [self setReplayRecord: _replayRecord ];
            [self setupView];
            
            [self makeToast:@"X4" duration:1.5 position:ToastCenter];
            
            
        } else if (scale > 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
            [self makeToast:@"已是最大比例" duration:1.5 position:ToastCenter];
            
        } else if (scale < 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            [self makeToast:@"已是最小比例" duration:1.5 position:ToastCenter];
            
        } else if (scale < 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
            BOOL state = [LKCPlayManager getPlayState];
            if (state) {
                [LKCPlayManager stop];
            }
            
            [UserDefaults setObject:@"1" forKey:@"zoomScale"];
            //            [self createSubviewWithIsToCo:1];
            [self changeValueAbortBgView];
            [self setReplayRecord: _replayRecord ];
            [self setupView];
            
            [self makeToast:@"X1" duration:1.5 position:ToastCenter];
            
            
        }else if (scale < 1 && [[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
            
            BOOL state = [LKCPlayManager getPlayState];
            if (state) {
                [LKCPlayManager stop];
            }
            
            
            [UserDefaults setObject:@"2" forKey:@"zoomScale"];
            //            [self createSubviewWithIsToCo:1];
            [self changeValueAbortBgView];
            [self setReplayRecord: _replayRecord ];
            [self setupView];
            
            [self makeToast:@"X2" duration:1.5 position:ToastCenter];
            
            
        }
    }

}

//!重放后续
-(void)changeValueAbortBgView{
    
    for (int i = 0; i < 120; i ++) {
        TOCOTimeBgImg * img = [ _bgImageArr objectAtIndex:i];
        
        //带宫缩
        int ratio = 0;
        if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
            ratio = 1;
        } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
            ratio = 2;
        }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            ratio = 4;
        }

        img.timeLable.text = [NSString stringWithFormat:@"%d'",i*ratio] ;
       
    }
//    DLog(@".......... ..... %ld",(long)_bgImageView.tag) ;
}

//initWithFrame和awakeFromNib中调用
- (void)setupView
{
    // setup
    self.recordeDate.text = @"";
    
    self.btnStartMonitor.tag = 100;//在处理事件回调函数中需要用到
    
    if (_isUpdateMonitor) {
        [self.btnStartMonitor setImage:[UIImage imageNamed:@"updateMonitorStart"] forState:UIControlStateNormal];
    } else {
        [self.btnStartMonitor setImage:[UIImage imageNamed:@"train_gray"] forState:UIControlStateNormal];
    }
    
    //设置处理事件
    [self.btnStartMonitor addTarget:self action:@selector(onButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.drawWrapper.delegate = self;
    self.drawWrapper.bounces = NO;
    self.drawWrapper.showsHorizontalScrollIndicator = NO;//滚动条不显示
    self.drawWrapper.showsVerticalScrollIndicator = NO;
    
    
    // 获取系统音量
    Float32 volume;
    UInt32 dataSize = sizeof(Float32);
    AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume, &dataSize, &volume);
    volume *= 100;
    self.volume.text = [NSString stringWithFormat:@"%d", (int)volume];
    
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback,  (__bridge void *)(self));
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMonitorStartEvent:) name:LKCBluetoothManagerNotificationStartMonitor object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMonitorStopEvent:) name:@"LKCBluetoothManagerNotificationStopMonitor" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBluetoothDisConnected:) name:LKCBluetoothManagerBluetoothDisconnected object:nil];
    
    
    
}
- (IBAction)volumeSliderChanged:(id)sender
{
    
    UISlider *slider = (UISlider*)sender;
    self.manager.volume = slider.value;
}

//重写view的layoutSubviews方法，调用完initWithFrame（初始化各个控件的尺寸）之后就调用了这里
/*
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat width = CGRectGetWidth(self.bounds);  //kScreen_width
    CGFloat height = CGRectGetHeight(self.bounds); //（kScreen_height－64）
    NSLog(@"monitor | w[%f], h[%f]", width, height);
    
    self.offsetLine.hidden = NO;
    

        CGRect newFrame = self.subviewWrapper.frame;
        newFrame.origin.y = 0;
        newFrame.size.width = width;  //4s:320
        newFrame.size.height = height;//4s:320
        self.subviewWrapper.frame = newFrame;
        self.subviewWrapper.contentSize = CGSizeMake(width, height);
        
        newFrame = self.vcBg.frame;
        newFrame.size.width = width;
        newFrame.size.height = height;
        self.vcBg.frame = newFrame;
        
        //!三个格子的视图
        newFrame = self.img_bg1.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = 0;
        newFrame.size.width = self.drawWrapper.frame.size.width;
        newFrame.size.height = viewScaleHeight(155);
        self.img_bg1.image = [UIImage imageNamed:@"bg_h1"];
        self.img_bg1.frame = newFrame;
        //!电池电量

    
        //!喇叭
        newFrame = self.voluemImage.frame;
        newFrame.origin.x = kScreen_width - newFrame.size.width - viewScaleWidth(90);
        newFrame.origin.y = viewScaleHeight(155)- newFrame.size.height - viewScaleHeight(13);
        self.voluemImage.frame = newFrame;
        //!音量值
        newFrame = self.volume.frame;
        newFrame.origin.x = _voluemImage.frame.origin.x+28;
        newFrame.origin.y = _voluemImage.frame.origin.y;
        
        self.volume.frame = newFrame;
    
        
        //!心脏图片
        newFrame = self.heartImageView.frame;
        newFrame.size.width = viewScaleWidth(20);
        newFrame.size.height = viewScaleWidth(20);
        newFrame.origin.x = kScreen_width*2/3-viewScaleWidth(20)-10;
        newFrame.origin.y = viewScaleHeight(12);
        self.heartImageView.frame = newFrame;
        //! 心率数值
        newFrame = self.heartRate.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.size.height = viewScaleHeight(50);
        newFrame.origin.x = kScreen_width/3.0;
        newFrame.origin.y = viewScaleHeight(23);//80;
        self.heartRate.frame = newFrame;
        self.heartRate.text = @"---";
        //! 信号强度

    
        //!` 胎心高(不知道什么时候显示)

        
        //!"胎心率"三个字
        newFrame = self.label2.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.origin.x = kScreen_width/3.0;//10;
        newFrame.origin.y = self.heartRate.frame.origin.y+self.heartRate.frame.size.height+viewScaleHeight(10);//0;
        self.label2.frame = newFrame;
        //! 宫缩数值
        newFrame = self.tocoValue.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.size.height = viewScaleHeight(50);
        newFrame.origin.x = kScreen_width*2/3.0;
        if (IS_IPHONE_4) {
            newFrame.origin.y = _label3.frame.origin.y + _label3.frame.size.height -5 ;
        } else {
            newFrame.origin.y = viewScaleHeight(23);
        }
        self.tocoValue.frame = newFrame;
        self.tocoValue.text = @"---";
    
        //!"宫缩"两个字
        newFrame = self.label3.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.origin.x = kScreen_width*2/3;
        if (IS_IPHONE_4) {
            newFrame.origin.y = 0;
        } else {
            newFrame.origin.y = self.tocoValue.frame.origin.y+self.tocoValue.frame.size.height + viewScaleHeight(10);
        }
        self.label3.frame = newFrame;
    
        //!宫缩复位图标

    
        //! 胎动数值
        newFrame = self.heartMove.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.size.height = viewScaleHeight(50);
        
        newFrame.origin.x = 0;//190;
        if (IS_IPHONE_4) {
            newFrame.origin.y = _label1.frame.origin.y + _label1.frame.size.height + 5;
        } else {
            newFrame.origin.y = viewScaleHeight(23);
        }
        self.heartMove.frame = newFrame;

        //! 胎动数值
        newFrame = self.heartMove.frame;
        newFrame.size.width = kScreen_width/3.0;
        newFrame.size.height = viewScaleHeight(50);
        
        newFrame.origin.x = 0;//190;
        if (IS_IPHONE_4) {
            newFrame.origin.y = _label1.frame.origin.y + _label1.frame.size.height + 5;
        } else {
            newFrame.origin.y = viewScaleHeight(23);
        }
        self.heartMove.frame = newFrame;
        self.heartMove.text = @"---";
        //!"胎动"两个字
        newFrame = self.label1.frame;
        newFrame.size.width = kScreen_width/3.0;
        
        if (IS_IPHONE_4) {
            newFrame.origin.y = 30;
        } else {
            newFrame.origin.y = self.heartMove.frame.origin.y+self.heartMove.frame.size.height + viewScaleHeight(10);
        }
        self.label1.frame = newFrame;
    
        //! 手动添加胎动按钮


    
        //! 时间图片(钟图片)
        newFrame = self.colock.frame;
        newFrame.origin.x = 15;
        newFrame.origin.y = viewScaleHeight(155)- newFrame.size.height - viewScaleHeight(10);
//        newFrame.origin.y = 15;
        self.colock.frame = newFrame;
        self.colock.hidden= NO;
        
        //! 时间文字
        newFrame = self.duration.frame;
        newFrame.origin.x = _colock.frame.origin.x+25;
        newFrame.origin.y = _colock.frame.origin.y;
//        newFrame.origin.y = _colock.frame.origin.y;
        self.duration.frame = newFrame;
        //self.duration.backgroundColor = [UIColor blackColor];
        
        newFrame = self.totalTime.frame;
        newFrame.origin.x = _colock.frame.origin.x + 83;
        newFrame.origin.y = _colock.frame.origin.y ;
        self.totalTime.frame = newFrame;
        
        //!绘图区域 ---------图？
        newFrame = self.drawWrapper.frame;
        BOOL isHToV = NO;
        if (newFrame.size.width >= 500) {
            // 从横屏旋转到竖屏
            isHToV = YES;
        }
        newFrame.origin.x = 0;
        newFrame.origin.y = viewScaleHeight(155)+20;
//        newFrame.origin.y = 50;
    
        newFrame.size.width = width;
        newFrame.size.height = viewScaleHeight(250);
        self.drawWrapper.frame = newFrame;//[0 245 320 190]
        
        
        
        //!录制、播放文字
        newFrame = self.label4.frame;
        newFrame.origin.x = kScreen_width/2-newFrame.size.width/2;
        newFrame.origin.y = self.subviewWrapper.frame.size.height - newFrame.size.height - viewScaleHeight(15);


        self.label4.text = @"播放";
    
        self.label4.frame = newFrame;
        
        //!波动画的线
        newFrame = self.drawLayer.frame;
        
        if (isHToV) {
            newFrame.size.width -= 80;
            self.drawLayer.frame = newFrame;
            self.drawLayer.tocoOrNot = 1;
            [self.drawLayer setNeedsDisplay];
        }
        
        CGSize contentSize = self.drawWrapper.contentSize;
        contentSize.width = newFrame.size.width;
        self.drawWrapper.contentSize = contentSize;
        
        //! 心率曲线背景图 (绘图的背景图)
        newFrame = self.chartBG.frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = viewScaleHeight(155)+20;
//        newFrame.origin.y = 50;
        newFrame.size.width = viewScaleWidth(319);
        newFrame.size.height = 700;
        self.chartBG.frame = newFrame;
        
        //!时间轴：播放显示
        newFrame = self.offsetLine.frame;
        newFrame.size.height = viewScaleHeight(250);
        newFrame.origin.x = viewScaleWidth(119);

        
        newFrame.origin.y = CGRectGetMinY(_chartBG.frame);
        self.offsetLine.frame = newFrame;
        
        
        if (_isUpdateMonitor) {
            newFrame = self.btnStartMonitor.frame;
            newFrame.origin.x = 5;
            newFrame.origin.y = CGRectGetMaxY(self.drawWrapper.frame) - newFrame.size.height;
            newFrame.size.width = 60;
            newFrame.size.height = 60;
            self.btnStartMonitor.frame = newFrame;
            self.btnStartMonitor.layer.cornerRadius = 30.f;
            self.btnStartMonitor.clipsToBounds = YES;
            [self.btnStartMonitor setImage:[UIImage imageNamed:@"updateMonitorStart"] forState:UIControlStateNormal];

            
        } else {
            //!直接设置中点
            
//            self.btnStartMonitor.frame = CGSizeMake(kScreen_width-40, 40);
            self.btnStartMonitor.center = CGPointMake(self.label4.center.x, self.label4.center.y);
            self.btnStartMonitor.layer.cornerRadius = 30.f;
            self.btnStartMonitor.clipsToBounds = YES;
            //newFrame.origin.x = kScreen_width/2-newFrame.size.width/2;
            //newFrame.origin.y = self.subviewWrapper.frame.size.height - viewScaleHeight(80);
//            self.btnStartMonitor.frame = newFrame;
            
        }
        
        //!开始时间
        newFrame = self.recordeDate.frame;
        newFrame.origin.x = CGRectGetMaxX(self.drawWrapper.frame)-newFrame.size.width -10 ;//186;
        newFrame.origin.y = CGRectGetMaxY(self.drawWrapper.frame);
        self.recordeDate.frame = newFrame;//[186 419 128 20]
        
    
    self.drawLayer.xOffset = CGRectGetMinX(self.offsetLine.frame);
    
//    self.drawLayer.tocoOrNot = _tmpTocoOrNot;
    
    /*
    
    LKCBluetoothManager *blueToothManager = [LKCBluetoothManager shareInstance];
    blueToothManager.timeingmonitor = 0;
    if (blueToothManager.isConnected) {
        //!已注释
        [blueToothManager realTimeBeforeRecordDrawline];//  录制之前，提前画曲线
        [UserDefaults setObject:@"yes" forKey:@"Notrecord"];
    }
    */
}

//重写replayRecord的set方法,LKCReplayViewController中的viewDidLoad中调用
// 绑定历史记录数据，供外部调用，显示历史回放的一条记录

- (void)setReplayRecord:(LKCOneRecord *)replayRecord
{
    
    int ratio = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 2;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 4;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio = 8;
    }
    
    
    // 重新设置content size 和 drawlayer size
    if (ratio== 0) {
        ratio = 1;
    }
    
    NSInteger count = [replayRecord.hearts count]/ratio;//edison
    CGFloat width = CGRectGetWidth(self.drawWrapper.frame) + count;//320 + count
    CGSize contentSize = CGSizeMake(width, CGRectGetHeight(self.drawWrapper.frame));//height:190
    self.drawWrapper.contentSize = contentSize;//xxx,190
    
    CGRect newFrame = self.drawLayer.frame;
    newFrame.size.width = CGRectGetWidth(newFrame) + count;
    self.drawLayer.frame = newFrame;//xxx,190
    self.drawLayer.tocoOrNot = replayRecord.TocoOrNot;
    self.drawLayer.points = replayRecord.hearts;
    [self.drawLayer setNeedsDisplay];
    
    
    // 显示胎动数

    
    int totalTime = self.replayRecord.monitorDuration;
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",totalTime/60<10?[NSString stringWithFormat:@"0%d",totalTime/60] : [NSString stringWithFormat:@"%d",totalTime/60],totalTime%60<10?[NSString stringWithFormat:@"0%d",totalTime%60] : [NSString stringWithFormat:@"%d",totalTime%60]];
    
    self.duration.text = [NSString stringWithFormat:@"00:00"];
    self.totalTime.text = [NSString stringWithFormat:@"/%@",timeStr];
    
    _replayRecord = replayRecord;
}


/**
 * 创建音频播放url
 * 用于播放wav音频文件
 * 返回需要播放的文件地址
 * onButtonEvent（开始或停止监护）中调用
 */


- (NSURL *)createPlayAudioURL
{
    
    long long  startTime      =  self.replayRecord.startTimeInterval * 1000;
    
    NSString *audioDir = [[LKCHistoryManager shareHistoryManager] getAudioFilePath];
    
    
    NSString * audioType = [_mp3OrWavString substringFromIndex:_mp3OrWavString.length-3];
    //    DLog(@" %@----- %@",_mp3OrWavString,audioType);
    
    if ([audioType isEqualToString:@"mp3"]) {
        
        NSString *audioName = [NSString stringWithFormat:@"%lld.mp3", startTime];
        NSString *audioFilePath = [audioDir stringByAppendingPathComponent:audioName];
        
        NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
        return audioURL;
        
        
    } else {
        
        NSString *audioName = [NSString stringWithFormat:@"%lld.wav", startTime];
        NSString *audioFilePath = [audioDir stringByAppendingPathComponent:audioName];
        
        NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
        return audioURL;
    }
}



- (NSString*) getPlayAudioString
{
    long long  startTime      =  self.replayRecord.startTimeInterval * 1000;
    
    
    NSString *audioDir = [[LKCHistoryManager shareHistoryManager] getAudioFilePath];
    NSString *audioName = [NSString stringWithFormat:@"%lld.mp3",startTime];
    NSString *audioFilePath = [audioDir stringByAppendingPathComponent:audioName];
    self.item = [AZSoundItem soundItemWithContentsOfFile:audioName];
    
    NSLog(@"－－－－－－%@",audioFilePath);
    
    return audioFilePath;
}


- (NSString*) getcellPlayAudioString: (NSTimeInterval)cellstarttime
{
    long long  startTime      =  cellstarttime;
    
    
    NSString *audioDir = [[LKCHistoryManager shareHistoryManager] getAudioFilePath];
    NSString *audioName = [NSString stringWithFormat:@"%lld.mp3",startTime];
    NSString *audioFilePath = [audioDir stringByAppendingPathComponent:audioName];
    self.item = [AZSoundItem soundItemWithContentsOfFile:audioName];
    return audioFilePath;
}



/**
 * setupView中设置
 * 处理小火车按下事件和手动胎动按下事件,
 * 如果是回放记录则根据本地wav文件创建播放url，然后根据播放器的状态，再播放或停止播放
 * 如果是监听界面，则根据监听状态，再开始监听或者停止监听
 */


- (void)onButtonEvent:(UIButton *)sender
{
    if (sender.tag == 100) {
        if (self.monitorType == MonitorTypeReplay) {
            NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
            NSInteger historyscreen = [u integerForKey:kHistoryScreen];
            LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
            NSURL *audioURL = [playManager audioURL];
            if (audioURL) {
                // 如果正在播放时按下小火车则停止播放
                BOOL state = [LKCPlayManager getPlayState];
                if (state) {
                    [LKCPlayManager stop];
                }
            }else{
                if([self NeedDownOrNot:self.replayRecord]==YES){//需要下载
//                    if (historyscreen == 2 || historyscreen == 1) {
//                        [self netConnectState ];
                    
                    [self getOnePregFHRInfoFromHttp:self.replayRecord.choose_mid record:self.replayRecord];
                    //                                self.replayRecord.needUpOrDown = 0;
//                    [UserDefaults removeObjectForKey:@"WIFI"];
                    
                        
//                    }
//                    else if(historyscreen == 1){
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未下载声音文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alertView show];
//                    }
                }else{//不需要下载
                    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
                    /**
                     *  根据当前心率曲线的位置决定音频播放的起始位置
                     */
                    CGFloat ratio = 0;
                    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
                        ratio = 2;
                    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
                        ratio = 1;
                    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
                        ratio = 0.5;
                    }
                    
                    [playManager createPlayerWithURL:[self createPlayAudioURL]];
                    NSLog(@"-------  %@",[self createPlayAudioURL]);
                    CGFloat offsetX = (CGFloat)self.drawWrapper.contentOffset.x ;//绘制曲线的区域
                    //                    offsetX = offsetX / ratio;//由2变为1
                    //
                    //                    if (offsetX < 0) {
                    //                        offsetX = 0;
                    //                     } else if (offsetX > self.replayRecord.monitorDuration) {
                    //                        offsetX = self.replayRecord.monitorDuration - 1;
                    //                    }
                    
                    offsetX = ceil(offsetX /ratio);//由2变为1
                    offsetX = offsetX ;
                    
                    NSLog(@" %f ------ %f",offsetX,playManager.duration);
                    //                   if (offsetX >= playManager.duration) {
                    if (offsetX >= playManager.duration) {
                        if(playManager.duration > 0){
                            [LKCPlayManager stop];
                        }
                    } else {
                        [LKCPlayManager playSeekTime:offsetX];
                    }
                }
            }
        }
    }
    
//    [self getOnePregFHRInfoFromHttp:self.replayRecord.choose_mid record:self.replayRecord];
    
    
    
//    [self netConnectState ];
//    if ([UserDefaults objectForKey:@"WIFI"]) {
//        [self getOnePregFHRInfoFromHttp:self.replayRecord.choose_mid record:self.replayRecord];
//        //                                self.replayRecord.needUpOrDown = 0;
//        [UserDefaults removeObjectForKey:@"WIFI"];
//        
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"播放文件需要下载声音文件，建议在Wi-Fi下操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alertView show];
//        
//    }
}
-(void)addManualFHRMove{
//!    [[LKCBluetoothManager shareInstance] addManualFetalMove];
}
-(void)tocoResetClick{
//!    [LKCFetalSet sendFetalSettings:YES IsAlarm:NO AlarmLevel:0];
}

#pragma mark 网络连接状态
/*
-(void)netConnectState
{
    BOOL isExistenceNetwork = YES;
    
    KLReachabilityStatus stat = [KLReachabilityManager netWorkReachable];
    
    if (stat == KLReachabilityStatusNotReachable) {
        
        isExistenceNetwork = NO;
    }
    if (stat == KLReachabilityStatusReachableViaWiFi) {
        [UserDefaults setObject:@"yes" forKey:@"WIFI"];
    }
    
    if (!isExistenceNetwork) {
        [WMHUDUntil showMessage:@"请检查网络" toView:self];
    }
}
*/


-(void) jumpToUpdataVC{
    
   /*
        [self stopMonitor];*********************************不加此句，回放界面 无数据************************************
        [self viewController].tabBarController.tabBar.hidden = YES;
        
        UpdataViewController *serviceVC = [[UpdataViewController alloc] init];
        serviceVC.istoco = _tmpTocoOrNot;
        [[self viewController].navigationController pushViewController:serviceVC animated:YES];//界面跳转
    */
}


-(BOOL)NeedDownOrNot:(LKCOneRecord*)record{
    
    long long  startTime      =  record.startTimeInterval * 1000;
    NSString* localWavFileName = [[NSString alloc] initWithFormat:@"%lld.mp3", startTime];
    NSString* localWavFileName2 = [[NSString alloc] initWithFormat:@"%lld.wav", startTime];
    NSLog(@"%@     %@",localWavFileName,localWavFileName2);
    self.counttest = 0;
    self.countL2N = 0;
    NSString *audioDir = [[LKCHistoryManager shareHistoryManager] getAudioFilePath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:audioDir];
    
    for (NSString *fileName in enumerator){
        self.counttest ++;
        
        if ([localWavFileName isEqualToString:fileName] ||[localWavFileName2 isEqualToString:fileName] ) {
            //本地和网络都有
            
            if ([localWavFileName isEqualToString:fileName]) {
                _mp3OrWavString = localWavFileName;
            } else {
                _mp3OrWavString = localWavFileName2;
            }
            
            break;
        }
        else{
            self.countL2N ++;
        }
    }
    if (self.countL2N == self.counttest) {//表示该条数据本地没有，需要下载
        return YES;
    }
    else{
        return NO;
    }
}

//onButtonEvent中调用
- (void)stopMonitor
{
    /*
    if ([[LKCBluetoothManager shareInstance] isStartMonitor]) {
        
        [[LKCBluetoothManager shareInstance] startMonitor:NO];
        
    }
    
    */
    [self startHeartRateAnimation:NO];
}

// 改变小火车的状态，onMonitorStartEvent和playingStateChanged调用
- (void)changeMonitorButtonState:(BOOL)isMonitoring
{
    if (isMonitoring) {
        
        if (_isUpdateMonitor) {
            [self.btnStartMonitor setImage:[UIImage imageNamed:@"updateMonitorStop"] forState:UIControlStateNormal];
        } else {
            [self.btnStartMonitor setImage:[UIImage imageNamed:@"train_green"] forState:UIControlStateNormal];
        }
        
        self.label4.text = @"停止";
        [self startHeartRateAnimation:YES];
        [self.subviewWrapper addSubview:self.label4];
    } else {
        if (_isUpdateMonitor) {
            [self.btnStartMonitor setImage:[UIImage imageNamed:@"updateMonitorStart"] forState:UIControlStateNormal];
        } else {
            [self.btnStartMonitor setImage:[UIImage imageNamed:@"train_gray"] forState:UIControlStateNormal];
        }
        

        self.label4.text = @"播放";
        [self startHeartRateAnimation:NO];
        [self.subviewWrapper addSubview:self.label4];
        
    }
}

//获取View所在的Viewcontroller方法
- (UIViewController*)viewController{
    for(UIView* next =[self superview];next;next=next.superview){
        UIResponder* nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextResponder;
        }
    }
    return  nil;
}

//在setupView中设置的监听事件，响应LKCBluetoothManagerNotificationStartMonitor事件
- (void)onMonitorStartEvent:(NSNotification *)notice
{
    [self changeMonitorButtonState:YES];
}
//在setupView中设置的监听事件，响应LKCBluetoothManagerNotificationStopMonitor事件
- (void)onMonitorStopEvent:(NSNotification *)notice
{
    [self changeMonitorButtonState:NO];
}
//在setupView中设置的监听事件，响应LKCBluetoothManagerBluetoothDisconnected事件
- (void)onBluetoothDisConnected:(NSNotification *)notice
{
   
}


#pragma mark -
#pragma mark UIScrollView Delegate

/**
 *  曲线移动时，根据scroll view的content offset对应显示心率数据数组中的心率值
 *  显示胎心数值、信号强度等
 *  用户拖动导致content offset改变的时候就会调用
 * 是不是scrollRectToVisible的时候调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (![scrollView isEqual:self.drawWrapper]) {
        return;
    }
    
    CGFloat offsetX = (CGFloat)scrollView.contentOffset.x;
    NSArray *dateArray = nil;
    
    // 重放时使用记录中的数组数据
    dateArray = self.replayRecord.hearts;
    
    
    NSInteger count = [dateArray count]/2;
    if (!count) {
        return;
    }
    
    
    CGFloat ratio1 = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio1 = 2;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio1 = 4;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio1 = 8;//待定 或者8
    }
    
    if (offsetX < 0){
        offsetX = 0;
    } else if (offsetX > count - 1) {
        offsetX = count - 1;
    }
    
    // 显示胎心率数值
    LKCHeart *heart = [dateArray objectAtIndex:(offsetX*ratio1-1)];
    NSInteger rate = heart.rate;
    //    NSInteger rate2 = heart.rate2;
    NSInteger tocoValue = heart.tocoValue;
    if (rate >=0 && rate <=20) {
        self.heartRate.text = [NSString stringWithFormat:@"---"];
    } else {
        self.heartRate.text = [NSString stringWithFormat:@"%ld", (long)rate];
        
    }
    
    //        self.heartRate.text = [NSString stringWithFormat:@"%ld", (long)rate];
    self.tocoValue.text = [NSString stringWithFormat:@"%ld",(long)tocoValue];

    
    static int moveCount = 1;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat ratio = 0;
        if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
            ratio = 2;
        } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
            ratio = 1;
        }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            ratio = 0.5;
        }
        
        // 更新胎动数
        if (!_isUpdateMonitor) {
            weakSelf.heartMove.text = [UserDefaults objectForKey:@"FMcount"];
            
        }
        
        // 更新播放时间
        
        int totalTime = self.replayRecord.monitorDuration;
        NSString *timeStr = [NSString stringWithFormat:@"%@:%@",totalTime/60<10?[NSString stringWithFormat:@"0%d",totalTime/60] : [NSString stringWithFormat:@"%d",totalTime/60],totalTime%60<10?[NSString stringWithFormat:@"0%d",totalTime%60] : [NSString stringWithFormat:@"%d",totalTime%60]];

        
        if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            if (moveCount == 1) {
                NSString *curTimeStr = [NSString formatSecondsToString:((offsetX + 1)/ratio)];
                [weakSelf.duration setText:[NSString stringWithFormat:@"%@", curTimeStr]];
                moveCount = 0;
            }else{
                moveCount = 1;
            }
        }else{
            NSString *curTimeStr = [NSString formatSecondsToString:((offsetX + 1)/ratio)];
            [weakSelf.duration setText:[NSString stringWithFormat:@"%@", curTimeStr]];
            [weakSelf.totalTime setText:[NSString stringWithFormat:@"/%@", timeStr]];
            
        }
    });
    
}

//停止拖拽的时候开始执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGFloat offsetX = (CGFloat)scrollView.contentOffset.x;
    offsetX = offsetX < 0 ? 0 : offsetX;
//     DLog(@" %f ========",offsetX);
    
    // 因为0.5秒中记录一个心率数据，所以scroll view的contentOffset与音频时长的比例为2
    // 所以偏移量除以4才是对应的音频播放位置
    
    CGFloat ratio = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 2;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 1;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio = 0.5;
    }
    
    
    offsetX = ceil(offsetX /ratio);//由2变为1
    offsetX = offsetX ;
    
    
    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
    
    
//          DLog(@" %f ======== %f",offsetX,playManager.duration);
    if (offsetX >= playManager.duration) {
        if(playManager.duration > 0){
            [LKCPlayManager stop];
        }
    } else {
        [LKCPlayManager playSeekTime:offsetX];
    }
    
}


//减速停止的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    
    NSInteger offsetX = (NSInteger)scrollView.contentOffset.x;
    offsetX = offsetX < 0 ? 0 : offsetX;
    // seek time
    
    
    // 因为0.25秒中记录一个心率数据，所以scroll view的contentOffset与音频时长的比例为2
    // 所以偏移量除以2才是对应的音频播放位置
    
    CGFloat ratio = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 2;
        offsetX = ceil(offsetX / ratio);//由2变为1
        offsetX = offsetX * (120 /120);
        
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 1;
        offsetX = ceil(offsetX / ratio);//由2变为1
        offsetX = offsetX * (120 /120);
        
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        //            ratio = 0.5;
    }
    
    
    
    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
    
     NSLog(@" %ld ++++++++ %f",(long)offsetX,playManager.duration);
    if (offsetX >= playManager.duration) {
        if(playManager.duration > 0){
            [LKCPlayManager stop];
            //[LKCPlayManager playSeekTime:offsetX-3];
        }
    } else {
        [LKCPlayManager playSeekTime:offsetX];
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}

// 开始或者停止心跳图片的动画，playingStateChanged调用
- (void)startHeartRateAnimation:(BOOL)start
{
    if (start) {
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        scaleAnimation.repeatCount = INFINITY;
        scaleAnimation.fromValue = @0.6;
        scaleAnimation.toValue = @1.0;
        scaleAnimation.duration = 0.6f;
        scaleAnimation.timingFunction = defaultCurve;
        
        CALayer *layer = self.heartImageView.layer;
        [layer addAnimation:scaleAnimation forKey:@"hearImageScaleAnimation"];
    } else {
        
        CALayer *layer = self.heartImageView.layer;
        [layer removeAllAnimations];
    }
}

#pragma mark LKCPlayManagerUIDelegate

// 更新当前的播放时间,代理LKCPlayManager中的方法，每隔0。5秒会调用一次
- (void)currentPlaybackTimeChanged:(NSTimeInterval)currentTime
{
    if (!self.drawWrapper.isDragging) {
        // 移动曲线
        [self moveDrawlayer];
        
    }
}
// 移动心率曲线，currentPlaybackTimeChanged中调用，LKCBluetoothManager中的recordHeartRate也有调用
//这里只是实现滚动屏幕，没有这个函数照样可以实现曲线的绘制，只是不能滚动而已
- (void)moveDrawlayer
{
    
    static int moveCount = 1;
    /*
    //定时功能
    LKCBluetoothManager *blueToothManager = [LKCBluetoothManager shareInstance];
    if((blueToothManager.timeingmonitor>self.totaltime)&&(self.totaltime)){
        
        [self jumpToUpdataVC];
        return;
    }
    */
    /*
     * 每个心率数据对应了scroll view中偏移的x量
     * 一个心率数据对应1pixel
     */
    CGFloat moveDetal = 1;
    CGFloat ratio = 0;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 1;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 0.5;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio = 0.5;//貌似最小单位就是0.5 ，没办法，只能改定时器了。。。
    }
    
    // 拖动视图时不更新时间和曲线
    if (!self.drawWrapper.isDragging) {
        
        CGPoint cotOffset = self.drawWrapper.contentOffset;
        CGFloat x = cotOffset.x + moveDetal;
        
        if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
            if (moveCount == 1) {
                [self.drawWrapper scrollRectToVisible:CGRectMake(x, 0, CGRectGetWidth(self.drawWrapper.frame),CGRectGetHeight(self.drawLayer.frame) ) animated:YES];
                moveCount = 0;
            }else{
                moveCount = 1;
            }
        } else {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.drawWrapper scrollRectToVisible:CGRectMake(x, 0, CGRectGetWidth(weakSelf.drawWrapper.frame),CGRectGetHeight(weakSelf.drawLayer.frame) ) animated:YES];
            });
            
        }
        
    }
}

//代理LKCPlayManager中的方法
- (void)totalPlaybackTimeChanged:(NSTimeInterval)totalTime
{
    
}

// wav文件播放状态改变,代理LKCPlayManager中的方法,在LKCPlayManager的setIsPlaying中调用
- (void)playingStateChanged:(BOOL)playing
{
    if (playing) {
        // 播放
        [self changeMonitorButtonState:YES];//改变小火车的状态
        [self startHeartRateAnimation:YES];
    } else {
        // 暂停
        [self startHeartRateAnimation:NO];
        [self changeMonitorButtonState:NO];
    }
}

// wav文件播放结束,代理LKCPlayManager中的方法
- (void)playerStoped:(BOOL)manual
{
    [self audioDidFinishPlaying];
}

// 音频播放完，其实是本类的对象方法，同时也是代理LKCPlayManager中的方法
- (void)audioDidFinishPlaying
{
    [self startHeartRateAnimation:NO];
    [self changeMonitorButtonState:NO];
    
    // 移动回到(0,0)
    self.drawWrapper.contentOffset = CGPointMake(0, 0);
    
    int totalTime = self.replayRecord.monitorDuration;
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",totalTime/60<10?[NSString stringWithFormat:@"0%d",totalTime/60] : [NSString stringWithFormat:@"%d",totalTime/60],totalTime%60<10?[NSString stringWithFormat:@"0%d",totalTime%60] : [NSString stringWithFormat:@"%d",totalTime%60]];
    
    self.duration.text = [NSString stringWithFormat:@"00:00"];
    self.totalTime.text = [NSString stringWithFormat:@"/%@", timeStr];
        

    
}

-(void)getOnePregFHRInfoFromHttp:(NSString*)mid record:(LKCOneRecord*)record
{
    
    
    NSData* waveInfo = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.mp3OrWavString]];
    [self getDetailHttpwaveData:waveInfo record:record];
    
    [WMHUDUntil hideHUDForView:self];
    
    //!播放
    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
    
    //  根据当前心率曲线的位置决定音频播放的起始位置
    
    [playManager createPlayerWithURL:[self createPlayAudioURL]];
    NSInteger offsetX = (NSInteger)self.drawWrapper.contentOffset.x;//绘制曲线的区域
    offsetX /= 2;
    
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > self.replayRecord.monitorDuration) {
        offsetX = self.replayRecord.monitorDuration - 1;
    }
    // seek time不能超过音频实际长度
    NSTimeInterval duration = [playManager duration];//这个函数是调用的内部播放器的长度
    offsetX = offsetX > duration ? duration : offsetX;
    [LKCPlayManager playSeekTime:offsetX];
    
   /*
    ///从服务端下载 获取某条数据（.mp3）
    LoginModel *loginModel = [WMCache getMemoryLoginModel];
    ResidentEntity *residentEntity = [ResidentEntity getResidentEntity:loginModel.SHOUJIHAO];
    __weak __typeof(self) weakSelf = self;
    
    [WMHUDUntil showWhiteLoadingWithMessage:@"正在下载" toView:self];
 
    WMHttpHelper *helper = [[WMHttpHelper alloc] initWithHTTPMethod:HTTP_GET url:@"weimaipt/api/fygl/fetalheart/getsingle" parameters:@{@"weimaihao":residentEntity.weimaihao,@"mid":mid}];
    helper.hideHUD = YES;
    
    LKCReplayViewController *baseVc = (LKCReplayViewController *)self.superviewcontroller;
    
    [baseVc httpNewWithHelper:helper success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"getsingle responseObject = %@",responseObject);
        
        
        //保存Wave文件
        NSDictionary *g_dicData = [responseObject objectForKey:@"data"];//data域
        _strWavepath = [g_dicData objectForKey:@"wavpath"];//data域的wavepath域,声音文件
        LKCHttpManager* httpManager = [[LKCHttpManager alloc]init];
        NSData* waveInfo       = [httpManager getwaveData:_strWavepath];
        [weakSelf getDetailHttpwaveData:waveInfo record:record];
        
        [WMHUDUntil hideHUDForView:self];
        
        //!播放
        LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
        
        //  根据当前心率曲线的位置决定音频播放的起始位置
        
        [playManager createPlayerWithURL:[self createPlayAudioURL]];
        NSInteger offsetX = (NSInteger)weakSelf.drawWrapper.contentOffset.x;//绘制曲线的区域
        offsetX /= 2;
        
        if (offsetX < 0) {
            offsetX = 0;
        } else if (offsetX > weakSelf.replayRecord.monitorDuration) {
            offsetX = weakSelf.replayRecord.monitorDuration - 1;
        }
        // seek time不能超过音频实际长度
        NSTimeInterval duration = [playManager duration];//这个函数是调用的内部播放器的长度
        offsetX = offsetX > duration ? duration : offsetX;
        [LKCPlayManager playSeekTime:offsetX];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WMHUDUntil hideHUDForView:self];
    }];
    */
    
}
 
//根据http返回的字典获取其中的wave文件
-(void)getDetailHttpwaveData:(NSData*)waveData record:(LKCOneRecord*)record
{
    if (waveData == nil) {
        return;
    }else{
        long long  startTime      =  record.startTimeInterval * 1000;
        // 使用监听起始时间为文件名
        NSString *audioDir = [[LKCHistoryManager shareHistoryManager] getAudioFilePath];
        NSString * audioType = [_mp3OrWavString substringFromIndex:_mp3OrWavString.length-3];
        NSLog(@" --    --- %@",audioType);
//        if ([audioType isEqualToString:@"wav"]) {
            NSString *audioFilePath = [audioDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.wav", startTime]];
            _mp3OrWavString = audioFilePath;
            FILE *fp = fopen([audioFilePath UTF8String], "wb+");
            void *pFileData = (void *)[waveData bytes];
            fwrite(pFileData, sizeof(UInt8), [waveData length], fp);
            fclose(fp);
//        } else {
//            NSString *audioFilePath = [audioDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3", startTime]];
//            _mp3OrWavString = audioFilePath;
//            FILE *fp = fopen([audioFilePath UTF8String], "wb+");
//            void *pFileData = (void *)[waveData bytes];
//            fwrite(pFileData, sizeof(UInt8), [waveData length], fp);
//            fclose(fp);
//        }
    }
}






@end
