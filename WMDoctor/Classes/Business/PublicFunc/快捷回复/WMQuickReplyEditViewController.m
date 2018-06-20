//
//  WMQuickReplyEditViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuickReplyEditViewController.h"
#import "WMQuickReplyModel.h"
#import "QuickEntity+CoreDataClass.h"

@interface WMQuickReplyEditViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *editText;

@end

@implementation WMQuickReplyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
}

- (void)setupUI{
    
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:[self sureView]];
    buttonItem.width=40;
    self.navigationItem.rightBarButtonItems = @[buttonItem];
    self.editText.delegate = self;
}

-(UIView *)sureView{
    
    UIView *view=[[UIView alloc] init];
    view.frame=CGRectMake(0, 0, 40, 40);
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(0, 0, 40, 40);
    label.textColor=[UIColor whiteColor];
    label.text=@"完成";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveQuickReply)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
    [view addGestureRecognizer:PrivateLetterTap];
    return view;
}


- (void)saveQuickReply{
    
    if (self.editText.text.length < 1) {
        [WMHUDUntil showMessageToWindow:@"回复内容不能为空"];
        return;
    }
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    //拿到最大排序的数据
    WMQuickReplyModel * tempModel = [QuickEntity getQuickEntity:loginModel.phone andTheType:self.typeStr];
    
    WMQuickReplyModel * model = [WMQuickReplyModel new];
    model.contentText = self.editText.text;
    model.order = [NSNumber numberWithInt:([tempModel.order intValue] +1)];     //最大排序上+1
    model.userId = loginModel.phone;
    model.theType = self.typeStr;
    
    [QuickEntity saveQuickEntity:model];
    [WMHUDUntil showMessageToWindow:@"添加成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length > 299 || (textView.text.length + text.length) > 299) {
        [WMHUDUntil showMessageToWindow:@"字数限制为300"];
        return NO;
    }
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
