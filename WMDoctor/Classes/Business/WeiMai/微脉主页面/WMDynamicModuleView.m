//
//  WMDynamicModuleView.m
//  Micropulse
//
//  Created by airende on 2017/1/5.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMDynamicModuleView.h"
#import "UIButton+WebCache.h"


@interface WMDynamicModuleView ()
{
    NSArray *_array;
}

@end

@implementation WMDynamicModuleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //do something
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)moduleViewMakeViewWithArray:(NSArray *)modelArray{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    _array = [NSArray arrayWithArray:modelArray];
    int sum = (int)modelArray.count;
    HomeAppModel *appModel = modelArray[sum - 1];
    NSString *lastStr = appModel.displayArea;
    NSArray *strarray = [lastStr componentsSeparatedByString:@","];
    int x = [strarray[2] intValue];
    int y = [strarray[3] intValue];
    NSLog(@"动态布局是: %d行, %d列", x, y);
    
//    //移除所有子视图
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(self.width/50.0, 0, self.width - (self.width/25.0), (y / (x*1.0)) * self.width);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, view.height);
    
    //!拿到视图的高度
    self.viewHeight = view.frame.size.height*24/25;

    int n = x+1;
    for (int i = 0; i < sum; i++){
        HomeAppModel *appModel1 = modelArray[i];
        NSString *subStr = appModel1.displayArea;
        NSArray *strarray = [subStr componentsSeparatedByString:@","];
        int sub_x = [strarray[0] intValue];
        int sub_y = [strarray[1] intValue];
        int sub_w = [strarray[2] intValue];
        int sub_h = [strarray[3] intValue];
        
        float aveWidth = (kScreen_width * 1.0) / n;
        float float_x = sub_x * aveWidth;
        float float_y = sub_y * aveWidth;
        float float_w = (sub_w - sub_x) * aveWidth;
        float float_h = (sub_h - sub_y) * aveWidth;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(float_x, float_y, float_w, float_h)];
        
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(clickYingYongEntran:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.adjustsImageWhenHighlighted = NO;
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:appModel1.image] forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    [self addSubview:view];
    
}

- (void)clickYingYongEntran:(UIButton *)button{
    
    HomeAppModel *model = _array[button.tag];
    if (_delegate&&[_delegate respondsToSelector:@selector(clickYingYongEntran:)]) {
        [self.delegate clickYingYongEntran:model];
    }
}

@end
