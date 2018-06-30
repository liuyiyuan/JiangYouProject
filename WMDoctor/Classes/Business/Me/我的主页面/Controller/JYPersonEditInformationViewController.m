//
//  JYPersonEditInformationViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPersonEditInformationViewController.h"
#import "JYInformaitonHeaderView.h"
#import "JYInformationNicknameView.h"
#import "JYInformationRealNameView.h"
@interface JYPersonEditInformationViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)JYInformaitonHeaderView *headerView;//头部视图

@property(nonatomic,strong)JYInformationNicknameView *nicknameView;//昵称

@property(nonatomic,strong)JYInformationRealNameView *realNameView;//实名认证

@end

@implementation JYPersonEditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.nicknameView];
    [self.scrollView addSubview:self.realNameView];
    
    self.scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(self.realNameView.frame) + 100);
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
    }
    return _nicknameView;
}

-(JYInformationRealNameView *)realNameView{
    if(!_realNameView){
        _realNameView = [[JYInformationRealNameView alloc]init];
        _realNameView.frame = CGRectMake(0, CGRectGetMaxY(self.nicknameView.frame) + pixelValue(5), UI_SCREEN_WIDTH, pixelValue(500));
    }
    return _realNameView;
}



@end
