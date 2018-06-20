//
//  WMNamePerfectViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMNamePerfectViewController.h"
#import "WMSaveAllInfoAPIManager.h"

@interface WMNamePerfectViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
}
@end

@implementation WMNamePerfectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"姓名";
    [self setupView];
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
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureAction:)];
    PrivateLetterTap.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap.numberOfTapsRequired = 1; //tap次数
   [view addGestureRecognizer:PrivateLetterTap];
    return view;
}
-(void)sureAction: (UITapGestureRecognizer *)gesture
{
    if (_textField.text.length<2) {
        [PopUpUtil alertWithMessage:@"姓名请填写2~15个字" toViewController:self withCompletionHandler:^{
            
        }];
    }
    else if (_textField.text.length>15){
        [PopUpUtil alertWithMessage:@"姓名请填写2~15个字" toViewController:self withCompletionHandler:^{
            
        }];
    }
    else{
        if (self.isInfo) {
            self.save_model.name = _textField.text;
            //保存
            WMSaveAllInfoAPIManager * apiManager = [WMSaveAllInfoAPIManager new];
            [apiManager loadDataWithParams:@{@"content":_textField.text,@"key":@"1"} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                [self.navigationController popViewControllerAnimated:YES];
            } withFailure:^(ResponseResult *errorResult) {
                
            }];
        }else{
            [WMInformationModel shareInformationModel].name=_textField.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }

}
-(void)setupView{
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    
    UIView *bgView=[[UIView alloc] init];
    bgView.frame=CGRectMake(0, 20, kScreen_width, 50);
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    _textField= [[UITextField alloc]initWithFrame:CGRectMake(15, 20, kScreen_width-15, 50)];
    WMInformationModel *infoModel=[WMInformationModel shareInformationModel];
    
    if (stringIsEmpty(infoModel.name)) {
        _textField.placeholder=@"请输入姓名";
    }
    else{
        _textField.text=infoModel.name;
    }
    _textField.delegate=self;
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor=[UIColor colorWithHexString:@"1f1f1f"];
    

    [self.view addSubview:_textField];
    
    
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        return NO;
    }
    
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (str.length > 15)
    {
        textField.text = [str substringToIndex:15];
        return NO;
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //该判断用于联想输入
    if (textField.text.length > 15)
    {
        textField.text = [textField.text substringToIndex:15];
    }
    _textField.text = textField.text;
}
*/
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
