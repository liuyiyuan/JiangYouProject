//
//  WMHomeModuleView.m
//  Micropulse
//
//  Created by airende on 2016/12/23.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMHomeModuleView.h"
#import "UIImageView+WebCache.h"

#define PAGE_SPACE 5

@interface WMHomeModuleView ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, copy) NSArray *modelArray;



//-- pageController 相关
@property(nonatomic, strong) UIView *pageView;//大的背景图
@property(nonatomic, strong) UIView *pageBgView;//类pageContoller.view
@property(nonatomic, strong) UIImageView *currentPage;//当前页面（移动）
@property(nonatomic, strong) NSMutableArray* markimgs;//默认页码图片数组

//下两属性可放外面 让外部调用(如果有多处使用 并有差异的话)
@property(nonatomic, strong) UIImage *currentPageImage;//当前图片
@property(nonatomic, strong) UIImage *defaultPageImage;//默认图片

@property(nonatomic, assign) long pages;//页码总数
//---



@end

@implementation WMHomeModuleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _defaultPageImage = [UIImage imageNamed:@"ic_gongnengqu_point_normal"];
        _currentPageImage = [UIImage imageNamed:@"ic_gongnengqu_point_select"];
        
        _markimgs = [NSMutableArray array];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 78)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.contentSize = _scrollView.size;
        [self addSubview:_scrollView];
        
    }
    return self;
}


- (void)setValueWithModelArray:(NSArray *)modelArray {
    //页数
    _pages = modelArray.count/4 + (modelArray.count%4?1:0);
    _modelArray = [modelArray mutableCopy];
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0 ; i < modelArray.count ;i++) {
        
        HomeAppModel *appModel = modelArray[i];
        
        UIButton *bgButton = [[UIButton alloc] initWithFrame:CGRectMake(i*self.scrollView.width/4, 0, self.scrollView.width/4, self.scrollView.height)];
        bgButton.tag = i;
        [bgButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:bgButton];
        
        CGFloat h = 0;
        if (kScreen_width < 375) {
            h = 10/375.0;
        }else if(kScreen_width == 375){
            h = 5/375.0;
        }else{
            h = 3/375.0;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgButton.width- 36/375.0 * kScreen_width)/2, h * kScreen_width, 36/375.0 * kScreen_width, 36/375.0 * kScreen_width)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:appModel.image] placeholderImage:[UIImage imageNamed:@"weimaidefault"]];
        [bgButton addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.height+imageView.frame.origin.y+10, bgButton.width, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = appModel.name;
        [bgButton addSubview:label];
    }
    
    
    [_pageBgView removeFromSuperview];
    [_pageView removeFromSuperview];
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    if (_pages > 1) {
        _pageView = [[UIView alloc] initWithFrame:CGRectMake(50, self.height - 10 , self.width - 100, 10)];
//        _pageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_pageView];
        
        _pageBgView = [[UIView alloc] initWithFrame:CGRectZero];
//        _pageBgView.backgroundColor = [UIColor grayColor];
        [_pageView addSubview:_pageBgView];
        [self loadPageControlSubViews];
    }
    
    //放地下很重要！！！
    _scrollView.contentSize = CGSizeMake(self.width*_pages, _scrollView.height);

}

//初始化pageView的图片
- (void)loadPageControlSubViews{
    
    [_markimgs removeAllObjects];
    //设置默认全部的pageView
    for (int i = 0; i<_pages; i++) {
        //创建默认的pageimage
        UIImageView* pageImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        pageImage.image = _defaultPageImage;
        pageImage.contentMode = UIViewContentModeScaleAspectFit;
        pageImage.backgroundColor = [UIColor grayColor];
        [_pageBgView addSubview:pageImage];
        [_markimgs addObject:pageImage];
        
        if (_defaultPageImage) {
            pageImage.backgroundColor = [UIColor clearColor];
        }
        
        [_pageBgView addSubview:pageImage];
    }
    
    //设置当前的pageView
    _currentPage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _currentPage.backgroundColor = [UIColor blueColor];
    _currentPage.image = _currentPageImage;
    if (_currentPageImage) {
        _currentPage.backgroundColor = [UIColor clearColor];
    }
    
    [_pageBgView addSubview:_currentPage];

    [self reloadPageViewSize];

}

//设置pageView的size
- (void)reloadPageViewSize{
    
    CGSize sizeCurrent = CGSizeMake(12, 12);
    CGSize sizeDefault = CGSizeMake(12, 12);
    
    if (_defaultPageImage) {
        sizeDefault = _defaultPageImage.size;
    }
    if (_currentPageImage) {
        sizeCurrent = _currentPageImage.size;
    }
    
    CGFloat bg_w = sizeDefault.width*_pages+PAGE_SPACE*(_pages-1);
    CGFloat bg_h = sizeDefault.height;
    
    _pageBgView.frame = CGRectMake(_pageView.width/2-bg_w/2, _pageView.height/2-bg_h, bg_w, bg_h);
    
    //def
    for (int i = 0; i<_markimgs.count; i++) {
        UIImageView* imgv = (UIImageView*)_markimgs[i];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        imgv.frame = CGRectMake(i*(sizeDefault.width+PAGE_SPACE), 0, sizeDefault.width, sizeDefault.height);
    }

    //cur
    _currentPage.frame = CGRectMake(0, 0, sizeCurrent.width, sizeCurrent.height);
    _currentPage.contentMode = UIViewContentModeScaleAspectFit;


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //x的偏移量比
    CGFloat scroll_content_x = _scrollView.contentSize.width-_scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat move_content_x = _currentPage.superview.bounds.size.width-_currentPage.bounds.size.width;
    
    //求当前滑块的x坐标
    CGFloat move_curr_x = move_content_x*offsetX/scroll_content_x;
    
    NSLog(@"offset x = %f",move_curr_x);
    
    CGFloat x = move_curr_x; //左右不偏移出去
    if (move_curr_x <= 0) {
        x = 0;
    }else if (move_curr_x >= 16*(_pages-1)){
        x = 16*(_pages-1);
    }else{
        x = move_curr_x;
    }
    
    _currentPage.frame = CGRectMake(x, 0, _currentPage.frame.size.width, _currentPage.frame.size.height);

}

//随机颜色
- (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (void)clickButton:(UIButton *)button{
    
    HomeAppModel *model = _modelArray[button.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(goModuleWith:)]) {
        [self.delegate goModuleWith:model];
    }
}



@end
