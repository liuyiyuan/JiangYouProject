//
//  WMDoctorCertificationResultView.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorCertificationResultView.h"

@implementation WMDoctorCertificationResultView

-(id)initWithText:(NSString *)textString withMoney:(NSString *)money{
    
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        if ([textString isEqualToString:@"2"]) {
            
            self.resonArray=[[NSMutableArray alloc] initWithObjects:@"开启微脉线上诊室",@"提供图文、包月收费服务",@"拥有专属二维码名片",@"精彩活动抢先参与", nil];
        }
        
        if ([textString isEqualToString:@"3"]){
            self.resonArray=[[NSMutableArray alloc] initWithObjects:@"照片上传模糊、不清晰",@"信息虚假、有误",@"姓名与照片本人不符",@"重复提交认证信息", nil];
        
        
        }
        
        [self setupSuccessfulViewWith:textString withMoney:money];
            
    }
    
    return self;
    
}

-(void)setupSuccessfulViewWith:(NSString *)textString withMoney:(NSString *)money{
    float top;
    if (kScreen_height<=480) {
        top=40;
    }else{
        top=119;
    }
    float width= 280;
    float heght=15+17+15+self.resonArray.count*17+(self.resonArray.count-1)*10+20+40+25;
    
    self.shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4];
    //这是一个坑呀。不能忘记了。不让button的点击事件没有
    [self addSubview:self.shadowView];
    
    //思路是：原则上此时已经算出 bgView的总高度=resultView+reasonView
    self.bgView=[[UIView alloc] init];
    self.bgView.frame=CGRectMake((kScreen_width-280)*0.5, top, width, 180+heght);
    self.bgView.layer.cornerRadius=4;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.backgroundColor=[UIColor whiteColor];
    [self.shadowView addSubview:self.bgView];
    
    self.resultView=[[UIView alloc]init];
   
    self.resultView.frame=CGRectMake(0, 0, width, 180);
    [self.bgView addSubview:self.resultView];
    self.resultView.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
    
    
    //创建
    
    
    UIImageView *closeImageView=[[UIImageView alloc] init];
    closeImageView.frame=CGRectMake(width-16-24, 16, 16, 16);
    closeImageView.image=[UIImage imageNamed:@"ic_guanb"];
    closeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * privateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canleAction:)];
    privateLetterTap.numberOfTouchesRequired = 1; //手指数
    privateLetterTap.numberOfTapsRequired = 1; //tap次数
    [closeImageView addGestureRecognizer:privateLetterTap];

    [self.resultView addSubview:closeImageView];
    
    //创建
    UIImageView *titleImageView=[[UIImageView alloc] init];
    titleImageView.frame=CGRectMake((width-36)*0.5, 30, 36, 43);
    [self.resultView addSubview:titleImageView];
    
    
    UILabel *titleLabel=[[UILabel alloc] init];
    titleLabel.frame=CGRectMake(0, titleImageView.frame.origin.y+titleImageView.frame.size.height+10, width, 20);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:16];
    [self.resultView addSubview:titleLabel];
    
    UILabel *detailLabel=[[UILabel alloc] init];
    detailLabel.frame=CGRectMake(38, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, width-38*2, 40);
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.numberOfLines=0;
    detailLabel.font=[UIFont systemFontOfSize:14];
    detailLabel.textColor=[UIColor whiteColor];
    [self.resultView addSubview:detailLabel];
    
    
    
    //self.reasonView=[[UIView alloc]init];
    //self.reasonView.frame=CGRectMake(0, self.resultView.frame.origin.y+self.resultView.frame.size.height, width, heght);
    if ([textString isEqualToString:@"2"]) {
        
        titleImageView.image=[UIImage imageNamed:@"ic_renzhengchenggong"];
        titleLabel.text=@"通过认证";
        detailLabel.text = @"恭喜你！正式成为微脉认证医生";

        self.resonArray=[[NSMutableArray alloc] initWithObjects:@"开启微脉线上诊室",@"提供图文、包月收费服务",@"拥有专属二维码名片",@"精彩活动抢先参与", nil];
         self.reasonView=[self reasonSuccessViewWithRect:CGRectMake(0, self.resultView.frame.origin.y+self.resultView.frame.size.height, width, heght)];
    }
    else{
        titleImageView.image=[UIImage imageNamed:@"ic_renzhengshibai"];
        titleLabel.text=@"认证失败";
        detailLabel.text=@"抱歉，你提交的信息认证失败！";

         self.resonArray=[[NSMutableArray alloc] initWithObjects:@"照片上传模糊、不清晰",@"信息虚假、有误",@"姓名与照片本人不符",@"重复提交认证信息", nil];
         self.reasonView=[self reasonFailureViewWithRect:CGRectMake(0, self.resultView.frame.origin.y+self.resultView.frame.size.height, width, heght)];
    }
    
   
  
    self.reasonView.backgroundColor=[UIColor whiteColor];
    [self.bgView addSubview:self.reasonView];
    
    
    
    
}
-(void)canleAction:(UITapGestureRecognizer *)gesture{
     [self remove];
}
-(UIView *)reasonSuccessViewWithRect:(CGRect)rect{
    float width= 280;
    float heght=15+17+15+self.resonArray.count*17+(self.resonArray.count-1)*10+20+40+25;
    UIView *view=[[UIView alloc] init];
    view.frame=rect;
    UILabel *alterLabel=[[UILabel alloc] init];
    alterLabel.frame=CGRectMake(30, 15, width-30-30, 17);
    alterLabel.text=@"您可享以下几大特权：";
    alterLabel.textColor=[UIColor colorWithHexString:@"999999"];
    alterLabel.font=[UIFont systemFontOfSize:12.0];
    [view addSubview:alterLabel];
    
    for (int i=0; i<self.resonArray.count; i++) {
        UIImageView *textImageView=[[UIImageView alloc] initWithFrame:CGRectMake(30, alterLabel.frame.origin.y+alterLabel.frame.size.height+15+17*i+10*i, 17, 17)];
        textImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_tequan%d",i]];
        //textAlble.text=self.resonArray[i];
        //textAlble.textColor=[UIColor colorWithHexString:@"333333"];
        //textAlble.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:textImageView];
        
        
    }

    
    for (int i=0; i<self.resonArray.count; i++) {
        
        UILabel *textAlble=[[UILabel alloc] initWithFrame:CGRectMake(55, alterLabel.frame.origin.y+alterLabel.frame.size.height+15+17*i+10*i, width-55-30, 17)];
        textAlble.text=self.resonArray[i];
        textAlble.textColor=[UIColor colorWithHexString:@"333333"];
        textAlble.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:textAlble];
        
        
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(30, heght-25-40, width-30*2, 40);
    button.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
    [button setTitle:@"新手指导" forState:UIControlStateNormal];
    button.layer.cornerRadius=4;
    button.layer.masksToBounds=YES;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(guideAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    return view;
    
    
}

-(UIView *)reasonFailureViewWithRect:(CGRect)rect{
    
    float width= 280;
    float heght=15+17+15+self.resonArray.count*17+(self.resonArray.count-1)*10+20+40+25;
    UIView *view=[[UIView alloc] init];
    view.frame=rect;
    UILabel *alterLabel=[[UILabel alloc] init];
    alterLabel.frame=CGRectMake(30, 15, width-30-30, 17);
    alterLabel.text=@"可能存在以下原因：";
    alterLabel.textColor=[UIColor colorWithHexString:@"999999"];
    alterLabel.font=[UIFont systemFontOfSize:12.0];
    [view addSubview:alterLabel];
    
    for (int i=0; i<self.resonArray.count; i++) {
        
        UILabel *textAlble=[[UILabel alloc] initWithFrame:CGRectMake(30, alterLabel.frame.origin.y+alterLabel.frame.size.height+15+17*i+10*i, width-55-30, 17)];
        textAlble.text=self.resonArray[i];
        textAlble.textColor=[UIColor colorWithHexString:@"333333"];
        textAlble.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:textAlble];
        
        
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(30, heght-25-40, width-30*2, 40);
    button.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
    [button setTitle:@"重新提交" forState:UIControlStateNormal];
    button.layer.cornerRadius=4;
    button.layer.masksToBounds=YES;
    button.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(againAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}


-(void)guideAction:(UIButton *)button{
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(newbieGuide)]) {
        [self.delegate newbieGuide];
         [self remove];
    }
    
}
-(void)againAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueAuthentication)]) {
        [self.delegate continueAuthentication];
         [self remove];
    }
   
}

- (void)show
{
    //找主window
    //找应用程序对象 自定义页面主要是针对 self进行操作
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

-(void)remove
{
    //自定义页面主要是针对 self进行操作
    [self removeFromSuperview];
    
}



@end
