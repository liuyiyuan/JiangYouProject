//
//  WMImageView.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMImageView.h"

@implementation WMImageView

{
    BOOL _isDoubleTap;//是否为双击的操作
}
/**
 *  初始化试图
 *  frame 需要传入的参数
 */
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //初始化试图
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    //下方的滚动视图用于图片的缩放
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setContentSize:self.bounds.size];
    _scrollView.pagingEnabled = NO;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    
    //显示的imageView
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:_imageView];
    
    /**
     *  以下是用手势来写点击事件
     *  singleTap 单指一次点击事件
     *  doubleTap 单指两次点击事件
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
}
//图片重新计算位置，然后显示  20161116 方法替换
-(void)calculateImageSizeToShow:(UIImage *)image{
    
    CGFloat widthRotio = CGRectGetWidth(self.frame)/(image.size.width*1.0f);
    CGFloat heightRotio = CGRectGetHeight(self.frame)/(image.size.height*1.0f);
    CGFloat wantRotio = MIN(widthRotio, heightRotio);
    
    CGFloat viewWidth = ceil(wantRotio * image.size.width);
    if (CGRectGetWidth(self.frame)-viewWidth < 2) {
        viewWidth = CGRectGetWidth(self.frame);
    }
    CGFloat viewHeight = ceil(wantRotio * image.size.height);
    //widthRotio==heightRotio && viewWidth==kScreen_width && viewHeight==kScreen_height 表示是手机截图 需要做判断。
    CGRect newRect = CGRectMake((CGRectGetWidth(self.frame)-viewWidth)/2, (CGRectGetHeight(self.frame)-viewHeight)/2, viewWidth, viewHeight);
    
    [_imageView setFrame:newRect];
    /*
     CGFloat widthRotio = CGRectGetWidth(self.frame)/(image.size.width*1.0f);
     CGFloat heightRotio = CGRectGetHeight(self.frame)/(image.size.height*1.0f);
     CGFloat wantRotio = MIN(widthRotio, heightRotio);
     
     CGFloat viewWidth = wantRotio * image.size.width;
     CGFloat viewHeight = wantRotio * image.size.height;
     
     CGRect newRect = CGRectMake((CGRectGetWidth(self.frame)-viewWidth)/2, (CGRectGetHeight(self.frame)-viewHeight)/2, viewWidth, viewHeight);
     
     [_imageView setFrame:newRect];
     */
}
#pragma mark - 处理收拾
//单机是退出是取消
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    if (!_isDoubleTap)
    {   //如果不是放大状态，那么单击就是推出
        if (self.singTapHide)
        {
            self.singTapHide();
        }
        
    }
}

//双击是方法热点区域
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    
    CGPoint touchPoint = [tap locationInView:_imageView];
    
    if (_scrollView.zoomScale != _scrollView.minimumZoomScale && _scrollView.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
        _isDoubleTap = NO;
        
    } else {
        CGFloat newZoomScale = ((_scrollView.maximumZoomScale + _scrollView.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
        _isDoubleTap = YES;
        
    }
}
- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = _scrollView.minimumZoomScale;
    if (_imageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _imageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(_scrollView.minimumZoomScale, zoomScale), _scrollView.maximumZoomScale);
        }
    }
    return zoomScale;
}
#pragma mark-UIScrollViewDelegate
//返回给他一个可以缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//返回原来的样子
- (void)setScaleImageToNormal
{
    [_scrollView setZoomScale:1 animated:YES];
}
//正在缩放的时候会调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{   //这里要设置缩放的imageView 始终居中
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

//一个阶段的缩放停止的时候会调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale < 1)
    {
        [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
        
        _isDoubleTap = NO;
    }
}


@end
