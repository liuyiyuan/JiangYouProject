//
//  WMMultilineTextViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMultilineTextViewController.h"
#import "HClTextView.h"
#import "WMSaveAllInfoAPIManager.h"

@interface WMMultilineTextViewController ()
{
    NSString * _saveStr;
}
@property (weak, nonatomic) HClTextView *textView;
@end

@implementation WMMultilineTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:[self sureView]];//[[UIBarButtonItem alloc]initWithTitle:@"消息盒子" style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    buttonItem.width=50;
    self.navigationItem.rightBarButtonItems = @[buttonItem];
    // Do any additional setup after loading the view.
}
-(UIView *)sureView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, 50, 40);
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(0, 0, 50, 40);
    label.textColor=[UIColor whiteColor];
    label.text=@"确定";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveInfo)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    [view addGestureRecognizer:PrivateLetterTap];
    return view;
}

- (void)setupUI{
    self.title = self.typeStr;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    HClTextView *textView = [[NSBundle mainBundle] loadNibNamed:@"HClTextView" owner:self options:nil].lastObject;
    textView.frame = CGRectMake(0, 0, kScreen_width, 200);
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.delegate = self;
    textView.clearButtonType = ClearButtonNeverAppear;
    
    NSString * placeholderStr = @"";
    if ([self.typeStr isEqualToString:@"擅长"]) {
        placeholderStr = @"示例：我擅长生殖内分泌疾病、妇科疑难杂症的诊断和处理。对月经不调、不孕症、内分泌疾病的诊断和治疗有独到之处";
    }else{
        placeholderStr = @"示例：徐州市妇幼保健院妇产科主任、妇科学博士。从事妇产科临床工作近30年，曾在第二军医大学附属上海长海医院进修学习。发表国家、省级论文数篇，2001-2006年于中南大学湘雅医院学习并获博士学位。";
    }
    
    [textView setBottomDivLineHidden:YES];
    [textView setPlaceholder:placeholderStr contentText:([self.typeStr isEqualToString:@"擅长"])?self.save_model.skill:self.save_model.intro maxTextCount:([self.typeStr isEqualToString:@"擅长"])?150:250];
    
    
}

- (void)saveInfo{
    if (_saveStr.length < 1) {
        [WMHUDUntil showMessageToWindow:@"请输入内容"];
        return;
    }
    if ([self.typeStr isEqualToString:@"擅长"]) {
        if (_saveStr.length > 150) {
            [WMHUDUntil showMessageToWindow:@"您的内容超出限制"];
            return;
        }
    }else{
        if (_saveStr.length > 250) {
            [WMHUDUntil showMessageToWindow:@"您的内容超出限制"];
            return;
        }
    }
    
    
    WMSaveAllInfoAPIManager * apiManager = [WMSaveAllInfoAPIManager new];
    [apiManager loadDataWithParams:@{@"content":_saveStr,@"key":([self.typeStr isEqualToString:@"擅长"])?@"2":@"3"} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.typeStr isEqualToString:@"擅长"]) {
            self.save_model.skill = _saveStr;
        }else{
            self.save_model.intro = _saveStr;
        }
        [self.navigationController popViewControllerAnimated:YES];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    _saveStr = textView.text;
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
