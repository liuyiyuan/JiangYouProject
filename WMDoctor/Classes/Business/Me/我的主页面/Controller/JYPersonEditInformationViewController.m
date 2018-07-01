//
//  JYPersonEditInformationViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPersonEditInformationViewController.h"
#import "JYInformaitonHeaderView.h"//头部视图
#import "JYInformationNicknameView.h"//昵称
#import "JYInformationRealNameView.h"//实名认证
#import "JYInformationInComeView.h"//收入
@interface JYPersonEditInformationViewController ()<JYInformationButtonArrayViewDelegate,JYInformationNicknameViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)JYInformaitonHeaderView *headerView;//头部视图

@property(nonatomic,strong)JYInformationNicknameView *nicknameView;//昵称

@property(nonatomic,strong)JYInformationRealNameView *realNameView;//实名认证

@property(nonatomic,strong)JYInformationInComeView *inComeView;//收入

@property(nonatomic,strong)UIButton *sendButton;//发送按钮

@property(nonatomic,assign)long worlTag;//工作类型

@property(nonatomic,assign)long inComeTag;//年收入金额

@end

@implementation JYPersonEditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.worlTag = 0;
    self.inComeTag = 0;
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.nicknameView];
    [self.scrollView addSubview:self.realNameView];
    [self.scrollView addSubview:self.inComeView];
    [self.scrollView addSubview:self.sendButton];
    self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _scrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, self.view.frame.size.height);
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}

-(JYInformaitonHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYInformaitonHeaderView alloc]init];
        _headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(240));
        
    }
    return _headerView;
}

-(JYInformationNicknameView *)nicknameView{
    if(!_nicknameView){
        _nicknameView = [[JYInformationNicknameView alloc]init];
        _nicknameView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + pixelValue(5), UI_SCREEN_WIDTH, pixelValue(500));
        _nicknameView.delegate = self;
    }
    return _nicknameView;
}

-(JYInformationRealNameView *)realNameView{
    if(!_realNameView){
        _realNameView = [[JYInformationRealNameView alloc]init];
        _realNameView.frame = CGRectMake(0, CGRectGetMaxY(self.nicknameView.frame) + pixelValue(5), UI_SCREEN_WIDTH, pixelValue(520));
        _realNameView.buttonArrayView.delegate = self;
    }
    return _realNameView;
}

-(JYInformationInComeView *)inComeView{
    if(!_inComeView){
        _inComeView = [[JYInformationInComeView alloc]init];
        _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(220));
        _inComeView.buttonArrayView.delegate = self;
    }
    return _inComeView;
}

-(UIButton *)sendButton{
    if(!_sendButton){
        _sendButton = [[UIButton alloc]init];
        _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
        [_sendButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton  setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
        [_sendButton addTarget:self action:@selector(click_sendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


#pragma mark - 行业与年收入点击
- (void)btnSelectedWithView:(UIView *)view tag:(long)tag{
    if(view == self.realNameView.buttonArrayView){//行业点击
        self.worlTag = tag;
        NSLog(@"%ld",tag);
        if(tag == 5){//点击了行业其他
            _realNameView.workTextFidle.hidden = NO;
            _realNameView.frame = CGRectMake(0, CGRectGetMaxY(self.nicknameView.frame) + pixelValue(5), UI_SCREEN_WIDTH, pixelValue(620));
            if(self.inComeTag == 5){
                _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(320));
                _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
                self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
            }else{
                _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(220));
                _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
                self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
            }
            
        }else{
            _realNameView.workTextFidle.hidden = YES;
            _realNameView.frame = CGRectMake(0, CGRectGetMaxY(self.nicknameView.frame) + pixelValue(5), UI_SCREEN_WIDTH, pixelValue(520));
            if(self.inComeTag == 5){
                _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(320));
                _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
                self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
            }else{
                _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(220));
                _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
                self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
            }
        }
    }else if(view == self.inComeView.buttonArrayView){//年薪点击
        NSLog(@"%ld",tag);
        self.inComeTag = tag;
        if(tag == 5){//点击了收入其他
            _inComeView.inComeTextField.hidden = NO;
            _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(320));
            _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
            self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
        }else{
            _inComeView.inComeTextField.hidden = YES;
            _inComeView.frame = CGRectMake(0, CGRectGetMaxY(self.realNameView.frame), UI_SCREEN_WIDTH, pixelValue(220));
            _sendButton.frame = CGRectMake(pixelValue(80), CGRectGetMaxY(self.inComeView.frame) + pixelValue(40), UI_SCREEN_WIDTH - pixelValue(160), pixelValue(88));
            self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.sendButton.frame) + pixelValue(140));
        }
    }
    
}

#pragma mark - 性别点击
-(void)genderSelect:(int)type{
    NSLog(@"%d",type);
}

#pragma mark - 提交按钮
-(void)click_sendButton{
    
}
@end
