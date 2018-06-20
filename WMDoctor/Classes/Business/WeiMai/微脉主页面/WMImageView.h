//
//  WMImageView.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UserSingleHide)();
typedef void(^ImageLoadFinish)(BOOL isSuccess);
@interface WMImageView : UIView<UIScrollViewDelegate>
@property (copy,nonatomic) UserSingleHide singTapHide;      //点击取消

//下方的滚动视图用于图片的缩放
@property(nonatomic,strong)UIScrollView *scrollView;
//显示图片的imageView
@property(nonatomic,strong)UIImageView *imageView;
//重新计算位置，把图片以合理的位置展示出来
-(void)calculateImageSizeToShow:(UIImage *)image;
//设置缩放的imageView变为正常状态
- (void)setScaleImageToNormal;

@end
