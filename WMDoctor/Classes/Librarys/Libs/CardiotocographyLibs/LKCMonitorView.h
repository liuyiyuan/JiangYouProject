//
//  LKCMonitorView.h  监控界面
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-4.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCDrawLayer.h"
#import "LKCPlayManager.h"

typedef NS_ENUM(NSInteger, MonitorType) {
    MonitorTypeRealTime,    //
    MonitorTypeReplay,// 重放
};

@class LKCOneRecord;
//需要实现这两个的代理方法
@interface LKCMonitorView : UIView < UIScrollViewDelegate, LKCPlayManagerUIDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *vcBg;           //整个界面的背景图片,含有图片的view



@property (strong, nonatomic) IBOutlet UILabel *duration;               // 音频时长

@property (strong, nonatomic) IBOutlet UIButton *btnStartMonitor;       // 启动/停止监听按钮
@property (strong, nonatomic) IBOutlet UIView *offsetLine;           //  时间轴

@property (strong, nonatomic) IBOutlet UIScrollView *drawWrapper;   // 要实现UIScrollView代理的方法哦
@property (strong, nonatomic) IBOutlet LKCDrawLayer *drawLayer;     // 加载在drawWrapper上的一个 view

@property (strong, nonatomic) IBOutlet UILabel *recordeDate;// 监护界面中点击开始后显示的开始时间 2014-11-20 12:12

@property (strong, nonatomic) IBOutlet UISlider *voiceSlider;


@property (strong, nonatomic) IBOutlet UIImageView *heartImageView; // 心脏图片
@property (strong, nonatomic) IBOutlet UILabel *volume;             // 音量值
@property (strong, nonatomic) IBOutlet UILabel *heartRate;          // 心率数
@property (strong, nonatomic) IBOutlet UILabel *tocoValue;
@property (strong, nonatomic) IBOutlet UILabel *heartAlarm;         //胎心报警
@property (strong, nonatomic) IBOutlet UILabel *heartMove;          // 胎动数
@property (strong, nonatomic) IBOutlet UIImageView *batteryValue;    //电池电量
@property (strong, nonatomic) IBOutlet UIImageView *img_bg1;    // 信号强度


@property (assign, nonatomic) MonitorType monitorType;

@property (assign, nonatomic) NSInteger orientation;

@property (assign, nonatomic) int isUpdateMonitor;

@property (strong , nonatomic) NSString * mp3OrWavString;


// 显示蓝牙信号强度
//- (void)changeSingalLevel:(NSInteger)level;
//-(void) changeBatteryValue:(NSInteger) level;

- (void)moveDrawlayer;
// 心跳动画
- (void)startHeartRateAnimation:(BOOL)start;

//- (void)startMonitor;
- (void)stopMonitor;
- (NSString*) getPlayAudioString;
- (NSString*) getcellPlayAudioString: (NSTimeInterval)cellstarttime;

- (void)deallocMonitorView;
@property (strong, nonatomic) LKCOneRecord *replayRecord;       // 重放的record

@end
