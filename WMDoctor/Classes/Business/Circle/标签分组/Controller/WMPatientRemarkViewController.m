//
//  WMPatientRemarkViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMPatientRemarkViewController.h"
#import "WMRemarkUpdateAPIManager.h"

#define MAX_LIMIT_NUMS     500       //字数限制

@interface WMPatientRemarkViewController ()<UITextViewDelegate>

@property(nonatomic, strong)UIButton *leftBarBtn;
@property(nonatomic, strong)UIButton *rightBarBtn;
@property(nonatomic, strong)UILabel *placeholderLab;
@end

@implementation WMPatientRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBarBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBarBtn addTarget:self action:@selector(leftBarBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
    
    //确定按钮
    self.rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBarBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.alpha = 0.5;
    self.rightBarBtn.userInteractionEnabled = NO;
    [self.rightBarBtn addTarget:self action:@selector(goSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    self.textView.delegate = self;
    self.textView.text = self.remark;
    
    self.placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 200, 20)];
    self.placeholderLab.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    self.placeholderLab.font = [UIFont systemFontOfSize:14];
    self.placeholderLab.text = @"填写备注信息";
    [self.textView addSubview:self.placeholderLab];
    self.placeholderLab.hidden = !stringIsEmpty(self.remark);
}

- (void)leftBarBtnClickAction{
//    [self.navigationController popViewControllerAnimated:YES];
    [self remindAgainToReturn];
}

- (void)goSave{
    WMRemarkUpdateAPIManager * apiManager = [WMRemarkUpdateAPIManager new];
    NSDictionary *param = @{
                            @"remark" : self.textView.text,
                            @"weimaihao" : self.weimaihao
                            };
    [apiManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.patientData.remark = self.textView.text;
        [self.navigationController popViewControllerAnimated:YES];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    } else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placeholderLab.hidden = !stringIsEmpty(textView.text);
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS){
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    
    if ([textView.text isEqualToString:self.remark]) {
        self.rightBarBtn.titleLabel.alpha = 0.5;
        self.rightBarBtn.userInteractionEnabled = NO;
    } else{
        self.rightBarBtn.titleLabel.alpha = 1;
        self.rightBarBtn.userInteractionEnabled = YES;
    }
    
    
}

- (void)remindAgainToReturn{
    if (![self.textView.text isEqualToString:self.remark]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃本次修改" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
