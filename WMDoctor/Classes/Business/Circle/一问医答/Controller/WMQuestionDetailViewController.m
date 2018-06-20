//
//  WMQuestionDetailViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailViewController.h"
#import "WMQuestionDetailModel.h"
#import "WMQuestionDetailAPIManager.h"
#import "WMQuestionDetailTopCell.h"
#import "WMShowImageViewController.h"
#include <CoreText/CTFont.h>
#include <CoreText/CTStringAttributes.h>
#include <CoreText/CTFramesetter.h>
#import "WMQuestionDetailBottomCell.h"
#import "WMQuestionDetailAnswerCell.h"
#import "WMQuestionAnswerSendAPIManager.h"
#import "WMQuestionStateAPIManager.h"
#import "QuestionEntity+CoreDataClass.h"
#import "AppConfig.h"
#import "WMQuestionExpiredAPIManager.h"

@interface WMQuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WMQuestionDetailTopCellDelegate,WMQuestionDetailAnswerCellDelegate>
{
    WMQuestionDetailModel * _model;
    WMQuestionDetailInfoModel * _infoModel;
    BOOL textHideFlag;
    int times;
    
    NSString * tempStr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) NSTimer *timer; // timer

@end

@implementation WMQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    times = 15;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)promptBox{
    
    if ([_infoModel.state isEqualToString:@"1"]) {      //待解答状态下提示
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"QuestionDetailFlag"]) {
            //        return;
        }else{
            //第一次的提示
            [PopUpUtil confirmWithTitle:@"提示" message:@"每个问题仅有一次回答机会，不可追加补充，请确保答案完整详尽！" toViewController:self buttonTitles:@[@"确定"] completionBlock:^(NSUInteger buttonIndex) {
                
            }];
            [defaults setObject:@YES forKey:@"QuestionDetailFlag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

- (void)initData{
    WMQuestionDetailAPIManager * apiManager = [WMQuestionDetailAPIManager new];
//    self.questionId = @"1";
    _model = nil;
    _infoModel = nil;
    textHideFlag = false;
    [apiManager loadDataWithParams:@{@"questionId":self.question.questionId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = (WMQuestionDetailModel *)responseObject;
        _infoModel = _model.doctorQuestionDetailVo;
        
        if ([_infoModel.state isEqualToString:@"3"] || [_infoModel.state isEqualToString:@"2"]) {      //已解答或被抢答
            self.timeLabelHeight.constant = 0;
            self.timeLabel.hidden = YES;
        }else if([_infoModel.state isEqualToString:@"5"]){      //被抢答
            [WMHUDUntil showMessageToWindow:@"该提问正在被其他医生抢答"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self promptBox];
            self.timeLabelHeight.constant = 30;
            times = [_infoModel.freezeTime intValue];
            _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeLabelCount) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer fire];
        }
        
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WMQuestionDetailTopCell * cell = (WMQuestionDetailTopCell *)[self.tableView dequeueReusableCellWithIdentifier:@"WMQuestionDetailTopCell" forIndexPath:indexPath];

        NSLog(@"cell=====%@",cell);
        [cell setDelegate:self];
        [cell setCellValue:_infoModel andFlag:textHideFlag];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        if ([_infoModel.state isEqualToString:@"3"] || [_infoModel.state isEqualToString:@"2"]) {      //已解答
            WMQuestionDetailBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMQuestionDetailBottomCell" forIndexPath:indexPath];
            [cell setCellValue:_infoModel];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{          //未解答
            WMQuestionDetailAnswerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMQuestionDetailAnswerCell" forIndexPath:indexPath];
            cell.delegate = self;
            LoginModel * login = [WMLoginCache getMemoryLoginModel];
            [cell getQuestionContext:self.question.questionId andUserid:login.phone];    //查询草稿并添加
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
        
    }
    
}

- (void)timeLabelCount{
//    self.timeLabel.text = [NSString stringWithFormat:@"抢题成功，您有%d分钟的时间处理提问",times];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抢题成功，您有%d分钟的时间处理提问",times]];
    if (AttributedStr.length == 18) {
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithHexString:@"FE5451"]
         
                              range:NSMakeRange(7, 2)];
    }else{
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithHexString:@"FE5451"]
         
                              range:NSMakeRange(7, 1)];
    }
    self.timeLabel.attributedText = AttributedStr;
    if (times > 0) {
        times --;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {       //此处分多种情况
        if (_infoModel) {
            float heightTemp = 0;
            
            //计算行数
            NSArray * linesArr = [self getSeparatedLinesFromLabel:_infoModel.content andFont:[UIFont systemFontOfSize:16] andRect:CGRectMake(15, 0, kScreen_width-30, 22)];
            if (linesArr.count > 4) {
                heightTemp += 40;
                
                
                if (!textHideFlag) {
                    heightTemp += 76+51;
                }else{
                    heightTemp += [CommonUtil heightForLabelWithText:_infoModel.content width:kScreen_width-30 font:[UIFont systemFontOfSize:16]] + 51;
                }
                
            }else{
                heightTemp += [CommonUtil heightForLabelWithText:_infoModel.content width:kScreen_width-30 font:[UIFont systemFontOfSize:16]] + 51;
            }
            if (_infoModel.pritureIndexs.count > 4) {
                heightTemp += 200;
            }else if(_infoModel.pritureIndexs.count >0 && _infoModel.pritureIndexs.count <5){
                heightTemp += 100;
            }else{
                heightTemp += 10;
            }
            //适配大屏幕
            if (kScreen_width > 380) {
                heightTemp += 20;
            }
            
            if ([_infoModel.state isEqualToString:@"3"]) {      //已解答
                heightTemp += 10;
            }else if ([_infoModel.state isEqualToString:@"1"] || [_infoModel.state isEqualToString:@"5"]){     //待解答和被自己抢答
                heightTemp += 40;
            }
            return heightTemp;
        }else{
            return 200.f;
            
        }
        
    }else{      //此处根据文字内容展示不同高度
        if ([_infoModel.state isEqualToString:@"1"] || [_infoModel.state isEqualToString:@"5"]){    //待解答和被自己抢答
            return 280;
        }else{
            return 90 + [CommonUtil heightForLabelWithText:_infoModel.answerContent width:kScreen_width-30 font:[UIFont systemFontOfSize:16]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
    
}

#pragma mark - WMQuestionDetailAnswerCellDelegate

-(void)getTempStr:(NSString *)str{
    tempStr = str;
}

-(void)cellClickBtn:(NSString *)str{
    
    
    WMQuestionAnswerSendAPIManager * apiManager = [WMQuestionAnswerSendAPIManager new];
    [apiManager loadDataWithParams:@{@"answerContent":str,@"questionId":_infoModel.questionId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * codeStr = [NSString stringWithFormat:@"%@",responseObject[@"errorCode"]];
        if ([codeStr isEqualToString:@"0"]) {
            self.question.state = @"3";
        }else{
            self.question.state = codeStr;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"answerSuccess" object:nil userInfo:nil];
        if ([codeStr isEqualToString:@"0"]) {       //提交成功
            [self initData];
        }else if([codeStr isEqualToString:@"9"]){
            [WMHUDUntil showMessageToWindow:responseObject[@"errorMessage"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WMHUDUntil showMessageToWindow:responseObject[@"errorMessage"]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"answerSuccess" object:nil userInfo:nil];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error:%@",errorResult);
        if (errorResult.code == 9) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
//    [PopUpUtil confirmWithTitle:@"" message:@"该提问已被其他医生抢答，请关注其他相关提问" toViewController:self buttonTitles:@[@"取消",@"确定"] completionBlock:^(NSUInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
//
    
    
    
}

#pragma mark - WMNewPictureSelectViewDelegate


-(void)cellPreviewPictureWithTag:(NSInteger )tag withShowType:(PictureShowType) showType{
    WMShowImageViewController *showImageVC=[[WMShowImageViewController alloc]init];
    showImageVC.array=_infoModel.pritureIndexs;
    showImageVC.currentIndex=(int)tag;
    showImageVC.isImageData=NO;
    showImageVC.isSupportDelete=NO;
    [self.navigationController pushViewController:showImageVC animated:YES];
}

-(void)cellHeightChange:(BOOL)flag{
    textHideFlag = flag;
    NSArray * indexArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//计算label行数
-(NSArray *)getSeparatedLinesFromLabel:(NSString *)thetext andFont:(UIFont *)thefont andRect:(CGRect )therect {
    
    NSString *text = thetext;
    
    UIFont *font = thefont;
    
    CGRect rect = therect;
    
    
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    
    
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    
    
    for (id line in lines)
        
    {
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        
        CFRange lineRange = CTLineGetStringRange(lineRef);
        
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        
        
        NSString *lineString = [text substringWithRange:range];
        
        [linesArray addObject:lineString];
        
    }
    
    return (NSArray *)linesArray;
    
}

- (void)backButtonAction:(UIBarButtonItem *)item{

    if (!stringIsEmpty(tempStr)) {      //草稿中如果有内容
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        WMQuestionDraftModel * qustionEntity = [[WMQuestionDraftModel alloc]init];
        qustionEntity.questionId = self.question.questionId;
        
        qustionEntity.userId = loginModel.phone;
        
        qustionEntity.context = tempStr;
        qustionEntity.theTime = [NSDate date];
        [QuestionEntity saveQuestionEntity:qustionEntity];  //保存
    }
    
    if ([_infoModel.state isEqualToString:@"1"]) {      //待解答返回需要解锁
        WMQuestionExpiredAPIManager * apiManager = [WMQuestionExpiredAPIManager new];
        [apiManager loadDataWithParams:@{@"questionId":self.question.questionId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
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
