//
//  WMDoctorRecordViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/9/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "WMUploadRecordAPIManager.h"
#import "WMDoctorRecordModel.h"
#import "UIImage+GIF.h"
#import "lame.h"

@interface WMDoctorRecordViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    AVAudioRecorder * _recorder;
    AVAudioPlayer * _audioPlayer;
}

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;   //倒计时标签
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;   //录制按钮
@property (weak, nonatomic) IBOutlet UIButton *listenBtn;   //试听按钮
@property (weak, nonatomic) IBOutlet UIButton *restBtn;     //重录按钮
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;   //录音状态标签
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;     //发布按钮
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UILabel *listenLabel;  //试听标签
@property (weak, nonatomic) IBOutlet UILabel *restLabel;    //重录标签

@property (nonatomic,strong) AVAudioSession * session;
@property (nonatomic,copy) NSString * filePath;
@property (nonatomic,strong) NSURL * recordFileUrl;
/**
 *  计时的时间
 */
@property(nonatomic,assign)NSInteger timeCount;
/**
 *  计时原始时间
 */
@property(nonatomic,assign)NSInteger oldTimeCount;
/**
 *  计时器
 */
@property(weak, nonatomic) NSTimer *timer;

@end

@implementation WMDoctorRecordViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self replayBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    _timeCount = 0;
    self.recordBtn.userInteractionEnabled = YES;
    self.listenBtn.userInteractionEnabled = NO;
    self.restBtn.userInteractionEnabled = NO;
    self.stateLabel.text = @"点击开始录音";
    self.sendBtn.hidden = YES;
    self.gifImageView.hidden = YES;
    NSString *path8 = [[NSBundle mainBundle] pathForResource:@"luyin" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path8];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    UIImage *image = [UIImage sd_animatedGIFNamed:@"luyin"];
    self.gifImageView.image = image;
    
    //清除原有录音文件
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/TheRecord.wav",path]]) {
        NSError *error;
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/TheRecord.wav",path] error:&error];    //删除文件夹下重名文件，以免合成时文件冲突合成输出失败
    }
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/TheRecordlast.wav",path]]) {
        NSError *error;
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/TheRecordlast.wav",path] error:&error];    //删除文件夹下重名文件，以免合成时文件冲突合成输出失败
    }
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/TheRecord.mp3",path]]) {
        NSError *error;
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/TheRecord.mp3",path] error:&error];    //删除文件夹下重名文件，以免合成时文件冲突合成输出失败
    }
    
    //获取麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){//麦克风权限
         if (granted) { NSLog(@"Authorized"); }
         else{      //没有授权
             NSLog(@"Denied or Restricted");
             [PopUpUtil confirmWithTitle:nil message:@"请在手机设置中开启此应用麦克风权限再使用此功能" toViewController:self buttonTitles:@[@"取消",@"去设置"] completionBlock:^(NSUInteger buttonIndex) {
                 if (buttonIndex == 1) {
                     NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                     
                     if([[UIApplication sharedApplication] canOpenURL:url]) {
                         [self.navigationController popViewControllerAnimated:YES];
                         NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                         [[UIApplication sharedApplication] openURL:url];
                         
                     }
                 }
                 if (buttonIndex == 0) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }];
             
         }
        
    }];
    
    self.gifImageView.animationImages = [self animationImages]; //获取Gif图片列表
    self.gifImageView.animationDuration = 1.6;     //执行一次完整动画所需的时长
    self.gifImageView.animationRepeatCount = 0;  //动画重复次数
    [self.gifImageView startAnimating];
    [self.view addSubview:self.gifImageView];
    
    // Do any additional setup after loading the view.
}

- (NSArray *)animationImages
{
    NSFileManager *fielM = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RecordLoading" ofType:@"bundle"];
    NSArray *arrays = [fielM contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *name in arrays) {
        UIImage *image = [UIImage imageNamed:[(@"RecordLoading.bundle") stringByAppendingPathComponent:name]];
        if (image) {
            [imagesArr addObject:image];
        }
    }
    return imagesArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始录音按钮
- (IBAction)recordBtn:(id)sender {
    
    [self beginTimers]; //先处理按钮状态
    
    if (_recorder.recording) {      //如果在录制状态点击后停止录制合成音频
        [_recorder stop];
        self.stateLabel.text = @"已暂停，点击继续";
        self.gifImageView.hidden = YES;
        self.stateLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        [WMHUDUntil showMessageToWindow:@"录音暂停"];
        return;
    }
    
    
    if (_recorder) {        //如果录过音
        if (![self.filePath containsString:@"last"]) {
            self.filePath = [self.filePath stringByReplacingOccurrencesOfString:@"Record" withString:@"Recordlast"];
        }
        
    }else{
        NSDate * nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
        
        //1.获取沙盒地址
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString * path = NSTemporaryDirectory();
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        
        NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:[NSString stringWithFormat:@"%@/theVideo",path]] objectEnumerator];
        NSLog(@"name:%@",[childFilesEnumerator nextObject]);
        if ([childFilesEnumerator nextObject]) {
            NSLog(@"有内容");
        }else{
            NSLog(@"无内容");
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/theVideo",path]]) {
            if ([[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/theVideo",path] contents:nil attributes:NULL]) {
                NSLog(@"theVideo文件夹创建成功");
            }else{
                NSLog(@"theVideo文件夹创建失败");
            }
        }
        
        
        
        self.filePath = [path stringByAppendingString:@"/TheRecord.wav"];
        NSLog(@"filePath:%@",self.filePath);
    }
    self.stateLabel.text = @"正在录音，点击可暂停";
    self.gifImageView.hidden = NO;
    NSLog(@"开始录音");
    
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;

    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:self.filePath];
    NSLog(@"recordFileUrl:%@",self.recordFileUrl);
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:&error];
    
    
    if (_recorder) {
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        NSLog(@"录音错误情况：%@",error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            [self stopRecord:nil];
        });
        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    
}

//重录按钮
- (IBAction)recordDone:(id)sender {
    [self restRecord];
}

//试听按钮
- (IBAction)replayBtn:(id)sender {
    if (_audioPlayer.isPlaying) {   //如果正在播放，就暂停
        _audioPlayer = nil;     //播放完成后清空播放器，以免音频文件被占用文件无法替换。
        if (_timeCount >= 300) {     //超时状态
            [self changeBtnState:@"超时后暂停试听"];      //UI样式状态改变
        }else{      //暂停状态
            [self changeBtnState:@"暂停试听"];      //UI样式状态改变
        }
        self.sendBtn.hidden = NO;
        
        return;
    }
    self.sendBtn.hidden = YES;
    [self audioPlayer];
    [_audioPlayer play];
    
    [self changeBtnState:@"开始试听"];      //UI样式状态改变
}

- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"]] error:&error];
        _audioPlayer.delegate = self;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];     //设置播放位置为扬声器
        NSLog(@"播放音频：%@",_audioPlayer.url);
        if (error) {
            NSLog(@"创建音频播放器对象发生错误:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音开始了");
//    [WMHUDUntil showMessageToWindow:@"录音开始了"];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];     //设置播放位置为扬声器
    NSLog(@"录音已结束");
    if ([self.filePath containsString:@"last"]) {
        [self hecheng];
    }
//    [WMHUDUntil showMessageToWindow:@"录音已结束"];
}

//合成录音
- (void)hecheng{
    //AVURLAsset子类的作用则是根据NSURL来初始化AVAsset对象.
    AVURLAsset *videoAsset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"]] options:nil];
    AVURLAsset *videoAsset2 = [[AVURLAsset alloc] initWithURL:self.recordFileUrl options:nil];
    NSLog(@"video1: %@",videoAsset1.URL);
    NSLog(@"video2: %@",videoAsset2.URL);
    //音频轨迹(一般视频至少有2个轨道,一个播放声音,一个播放画面.音频有一个)
    AVAssetTrack *assetTrack1 = [[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVAssetTrack *assetTrack2 = [[videoAsset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //AVMutableComposition用来合成视频或音频
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 把第二段录音添加到第一段后面
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset1.duration) ofTrack:assetTrack1 atTime:kCMTimeZero error:nil];
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset2.duration) ofTrack:assetTrack2 atTime:videoAsset1.duration error:nil];
    //输出
    AVAssetExportSession *exporeSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    exporeSession.outputFileType = @"com.apple.m4a-audio";
    NSLog(@"testtest===%@",AVFileTypeAppleM4A);
    NSLog(@"导出文件支持：%@",exporeSession.supportedFileTypes);
    exporeSession.outputURL = [NSURL fileURLWithPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"]];
    NSLog(@"outputURL: %@",exporeSession.outputURL);
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    [fileManager removeItemAtPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"] error:&error];    //删除文件夹下重名文件，以免合成时文件冲突合成输出失败
    NSLog(@"删除文件错误情况：%@",error);
    [exporeSession exportAsynchronouslyWithCompletionHandler:^{
        //exporeSession.status
        NSLog(@"录音已合成");
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString * path = NSTemporaryDirectory();
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        
        NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:[NSString stringWithFormat:@"%@/theVideo",path]] objectEnumerator];
        while((path=[childFilesEnumerator nextObject])!=nil){
            
            NSLog(@"%@",path);
            
        }
//        [WMHUDUntil showMessageToWindow:@"录音已合成"];
    }];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完毕");
    _audioPlayer = nil;     //播放完成后清空播放器，以免音频文件被占用文件无法替换。
    if (_timeCount >= 300) {     //超时状态
        [self changeBtnState:@"超时后暂停试听"];      //UI样式状态改变
    }else{      //暂停状态
        [self changeBtnState:@"暂停试听"];      //UI样式状态改变
    }
    self.sendBtn.hidden = NO;
    
}

- (void)changeBtnState:(NSString *)stateStr{
    
    if ([stateStr isEqualToString:@"开始录音"]) {
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_luyinbofangbukedian"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyinzhantin"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglubukedian"] forState:UIControlStateNormal];
        self.recordBtn.userInteractionEnabled = YES;
        self.listenBtn.userInteractionEnabled = NO;
        self.restBtn.userInteractionEnabled = NO;
        self.listenLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.restLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.sendBtn.hidden = YES;
    }else if ([stateStr isEqualToString:@"正在录音"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_bofangluyin"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyin"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglu"] forState:UIControlStateNormal];
        self.recordBtn.userInteractionEnabled = YES;
        self.listenBtn.userInteractionEnabled = YES;
        self.restBtn.userInteractionEnabled = YES;
        self.sendBtn.hidden = NO;
        self.listenLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.restLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
    }else if ([stateStr isEqualToString:@"重新录音"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_luyinbofangbukedian"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyin"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglubukedian"] forState:UIControlStateNormal];
        self.countDownLabel.text = @"0:00";
        self.countDownLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.stateLabel.text = @"点击开始录音";
        self.recordBtn.userInteractionEnabled = YES;
        self.listenBtn.userInteractionEnabled = NO;
        self.restBtn.userInteractionEnabled = NO;
        self.sendBtn.hidden = YES;
        self.listenLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.restLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else if ([stateStr isEqualToString:@"开始试听"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_bofangtingzhi"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyinbukedian"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglubukedian"] forState:UIControlStateNormal];
        self.recordBtn.userInteractionEnabled = NO;
        self.listenBtn.userInteractionEnabled = YES;
        self.restBtn.userInteractionEnabled = NO;
        self.listenLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.listenLabel.text = @"停止试听";
        self.restLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else if ([stateStr isEqualToString:@"暂停试听"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_bofangluyin"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyin"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglu"] forState:UIControlStateNormal];
        self.recordBtn.userInteractionEnabled = YES;
        self.listenBtn.userInteractionEnabled = YES;
        self.restBtn.userInteractionEnabled = YES;
        self.stateLabel.text = @"已暂停，点击继续";
        self.listenLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.listenLabel.text = @"试听";
        self.restLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }else if ([stateStr isEqualToString:@"超时后暂停试听"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_bofangluyin"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyinbukedian"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglu"] forState:UIControlStateNormal];
        self.recordBtn.userInteractionEnabled = NO;
        self.listenBtn.userInteractionEnabled = YES;
        self.restBtn.userInteractionEnabled = YES;
        self.stateLabel.text = @"录音已到时";
        self.listenLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.listenLabel.text = @"试听";
        self.restLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }else if ([stateStr isEqualToString:@"录音超时"]){
        [self.listenBtn setImage:[UIImage imageNamed:@"img_icon_bofangluyin"] forState:UIControlStateNormal];
        [self.recordBtn setImage:[UIImage imageNamed:@"img_icon_luyinbukedian"] forState:UIControlStateNormal];
        [self.restBtn setImage:[UIImage imageNamed:@"img_icon_chonglu"] forState:UIControlStateNormal];
        self.stateLabel.text = @"录音已到时";
        self.recordBtn.userInteractionEnabled = NO;
        self.listenBtn.userInteractionEnabled = YES;
        self.restBtn.userInteractionEnabled = YES;
        self.listenLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.listenLabel.text = @"试听";
        self.restLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
    }
    
}

//
- (void)next
{
    if (_timeCount>=300) {
        //结束了 超时了
        [self stopTimers];
        self.countDownLabel.text = @"5:00";
        return;
    }else{
        //改文字
        if (_timeCount>290) {
            self.countDownLabel.textColor = [UIColor colorWithHexString:@"FF5F5C"];
        }else{
            self.countDownLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        }
        _timeCount++;
        NSInteger min = 0;
        NSInteger second = 0;
        if (_timeCount > 59) {
            min = _timeCount/60;
            second = _timeCount%60;
            self.countDownLabel.text = [NSString stringWithFormat:(second < 10)?@"%zd:0%zd":@"%zd:%zd",min,second];
            
        }else{
            self.countDownLabel.text = [NSString stringWithFormat:(_timeCount < 10)?@"0:0%zd":@"0:%zd",_timeCount];
        }
        
        
    }
}

/**
 *  开始计时
 */
-(void)beginTimers{
    
    if (!self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(next) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    //更新时间
//    _timeCount = _oldTimeCount;
    
    
    if (_recorder.recording){   //正在录音（暂停状态）
        [self changeBtnState:@"正在录音"];
        [self.timer invalidate];
        self.timer = nil;
    }else{
        [self changeBtnState:@"开始录音"];
        [self next];
    }
    
}

/**
 *  结束计时
 */
-(void)stopTimers{
    [self.timer invalidate];
    self.timer = nil;
    [_recorder stop];
//    void (^statusBlock)(NSInteger) = objc_getAssociatedObject(self, statusBlockKey);
    
    self.gifImageView.hidden = YES;
    [self changeBtnState:@"录音超时"];
    self.sendBtn.hidden = NO;
}

//发送录音按钮
- (IBAction)sendRecord:(id)sender {
    
    if (_timeCount < 10) {
        [WMHUDUntil showMessageToWindow:@"发布失败，录音请不要短于10秒"];
        return;
    }
    
    UIAlertView *forbidPWDAlertView = [[UIAlertView alloc] initWithTitle:@"为你的医声取个标题吧" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认发布", nil,nil];
    forbidPWDAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;//设置输入的样式
    UITextField *pwdFild = [forbidPWDAlertView textFieldAtIndex:0];//设置输入框
    pwdFild.placeholder=@"最多25个字，必填";
    pwdFild.delegate=self;
    [forbidPWDAlertView show];
}

//
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>=25) {
        return NO;
    }else{
        return YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //只写了点击确定按钮的事件可以根据需要来设置多个按钮的点击事件
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        //转码音频
//        if (![self audio_PCMtoMP3]) {
//            [WMHUDUntil showMessageToWindow:@"音频转码失败，请重试"];
//            return;
//        }
        
        UITextField *titleField = [alertView textFieldAtIndex:0];
        NSString * textPWD=titleField.text;//获取输入的标题
        if (textPWD.length>0) {//点击发布
            WMUploadRecordAPIManager * apiManager = [WMUploadRecordAPIManager new];
            [apiManager setFormDataBlock:^(id<AFMultipartFormData> formData) {
//                NSDate * nowDate = [NSDate date];
//                NSCalendar *calendar = [NSCalendar currentCalendar];
//                NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//                NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
                //
                NSData *data=[NSData dataWithContentsOfFile:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"]];
//                [formData appendPartWithFileData:data name:@"file" fileName:@"TheRecord.mp3" mimeType:@"audio/mpeg"];
                [formData appendPartWithFileData:data name:@"file" fileName:@"TheRecord.wav" mimeType:@"audio/x-wav"];
            }];
            
            //
            WMDoctorRecordModel * model = [WMDoctorRecordModel new];
//            self.theGroupId = @"6666";
            model.groupId = self.theGroupId;
            model.timeLength = [NSString stringWithFormat:@"%zd",_timeCount];
            model.title = textPWD;
            model.suffix = @".wav";
            
            [apiManager loadDataWithParams:model.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PublishDoctorVoice" object:nil userInfo:nil];
                NSLog(@"responseObject=%@",responseObject);
                [WMHUDUntil showMessageToWindow:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } withFailure:^(ResponseResult *errorResult) {
                NSLog(@"responseObject=%@",errorResult);
            }];
            
        }else{
            [WMHUDUntil showMessageToWindow:@"你还未输入任何内容"];
            [self sendRecord:alertView];
        }
        
    }
}

#pragma mark ===== 转换成MP3文件=====
- (BOOL)audio_PCMtoMP3
{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString * wavPath = [path stringByAppendingString:@"/TheRecord.wav"];
    NSString * mp3Path = [path stringByAppendingString:@"/TheRecord.mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([wavPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        return NO;
    }
    @finally {
        NSLog(@"MP3生成成功: %@",mp3Path);
        return YES;
    }
    
}

- (void)convetM4aToWav:(NSURL *)originalUrl  destUrl:(NSURL *)destUrl {
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:originalUrl options:nil];
    
    //读取原始文件信息
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (![assetReader canAddOutput:assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput:assetReaderOutput];
    
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:destUrl
                                                          fileType:AVFileTypeCoreAudioFormat
                                                             error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        return;
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime:startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 NSLog (@"appended a buffer (%zu bytes)",
                        CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 
             } else {
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWritingWithCompletionHandler:^{
                     
                 }];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:[destUrl path]
                                                       error:nil];
                 NSLog (@"FlyElephant %lld",[outputFileAttributes fileSize]);
                 break;
             }
         }
         
     }];
}

//重写方法禁止粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

//重置弹框提醒
-(void)restRecord{
    [PopUpUtil confirmWithTitle:nil message:@"确定要重录吗" toViewController:self buttonTitles:@[@"取消",@"确定"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex==1) {
            [_recorder stop];
            _timeCount = 0;     //计时器清理
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            
            long long fileSize = [[fileManager attributesOfItemAtPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"] error:nil] fileSize]/1024;
            
            NSError *error;
            [fileManager removeItemAtPath:[self.filePath stringByReplacingOccurrencesOfString:@"Recordlast" withString:@"Record"] error:&error];    //删除文件夹下重名文件，以免合成时文件冲突合成输出失败
            NSLog(@"删除文件错误情况：%@",error);
            
            [self changeBtnState:@"重新录音"];      //改变UI样式状态
            
            //清除声音与录音数据
            _recorder = nil;
            _audioPlayer = nil;
            
            
//            [WMHUDUntil showMessageToWindow:[NSString stringWithFormat:@"重新录音，%lldM",fileSize/1024]];
        }
    }];
}

//返回提示(需要重写返回方法)
- (void)backOut{
    //需要一个前置判断是否有录音存在
    [PopUpUtil confirmWithTitle:nil message:@"录音尚未发布，退出后不会保存。确认退出吗？" toViewController:self buttonTitles:@[@"取消",@"确定"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)backButtonAction:(UIBarButtonItem *)item{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/TheRecord.wav",path]] || [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/TheRecordlast.wav",path]]) {
        [PopUpUtil confirmWithTitle:nil message:@"录音尚未发布，退出后不会保存。确认退出吗？" toViewController:self buttonTitles:@[@"取消",@"确定"] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//页面释放
- (void)dealloc{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];     //设置播放位置为扬声器
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
