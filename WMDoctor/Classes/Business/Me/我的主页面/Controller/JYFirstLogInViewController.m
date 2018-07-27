//
//  JYFindPassWordViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFirstLogInViewController.h"
#import "JYFirstLogInView.h"
#import "UIButton+EWTimer.h"
#import "JYSetPasswordAPIManager.h"

@interface JYFirstLogInViewController ()

@property(nonatomic,strong)JYFirstLogInView *firstLogInView;//找回密码

@end

@implementation JYFirstLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首次登录";
    
    [self congifUI];
}


-(void)congifUI{
    [self.view addSubview:self.firstLogInView];
    [self.firstLogInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
    }];
}

-(JYFirstLogInView *)firstLogInView{
    if(!_firstLogInView){
        _firstLogInView = [[JYFirstLogInView alloc]init];
        [_firstLogInView.loginBtn addTarget:self action:@selector(click_loginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstLogInView;
}

#pragma mark - 登录
-(void)click_loginBtn{
    NSDictionary *param = @{
                            @"tel" : @"13122221111",//_firstLogInView.phoneNumberLabel.text,
                            @"password" : _firstLogInView.passWordTextField.text
                            };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"tel":@"15395713725",
                           @"password":@"1"
                           };
    //第一个参数:请求路径(NSString) (URL地址后面无需添加参数)
    //第二个参数:要发送给服务器的参数 (传NSDictionary)
    //第三个参数:progress 进度回调
    //第四个参数:success 成功的回调
    //responseObject:响应体(内部默认已经做了JSON的反序列处理)
    //第五个参数:failure 失败的回调
    [manager POST:@"http://39.104.124.199:8080/jeecmsv9f/jyqss/mobile/user/setPassword" parameters:dict progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"请求成功---%@---%@",responseObject,[responseObject class]);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"请求失败--%@",error);
     }];
    
}
@end
