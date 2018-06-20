//
//  WMGuidePageViewController.m
//  WMDoctor
//  微脉引导页
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMGuidePageViewController.h"

@interface WMGuidePageViewController ()
{
    
}

@end

@implementation WMGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < self.images.count; i ++) {
        [gui addSubview:({
            self.btnEnter = [[UIImageView alloc]init];
            self.btnEnter.frame = CGRectMake(kScreen_width * i, 0, kScreen_width, kScreen_height);
            self.btnEnter.image = [UIImage imageNamed:self.images[i]];
            self.btnEnter;
        })];
        
        //暂无需所有页面都要进入按钮
        //        [self.btnEnter addSubview:({
        //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
        //            btn.frame = CGRectMake(kScreen_width * i, kScreen_height - 60, 100, 40);
        //            btn.center = CGPointMake(kScreen_width / 2, kScreen_height - 60);
        //            btn.backgroundColor = [UIColor lightGrayColor];
        //            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
        //            btn;
        //        })];
        
    }
    
    UIView * touchView = [[UIView alloc]initWithFrame:CGRectMake(kScreen_width * (self.images.count -1), kScreen_height - 180, kScreen_width, 180)];
    touchView.userInteractionEnabled = YES;
    UITapGestureRecognizer *touchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnter)];
    [touchView addGestureRecognizer:touchTap];
    [gui addSubview:touchView];
    
    gui.contentSize = CGSizeMake(kScreen_width * self.images.count, 0);
    [self.view addSubview:gui];
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_width / 2, 10)];
    self.pageControl.center = CGPointMake(kScreen_width / 2, kScreen_height - 20);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.hidden = YES;
}

- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(guideDoneClick:)]) {
        [self.delegate guideDoneClick:self];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)dealloc
{
    NSLog(@"引导页dealloc");
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
