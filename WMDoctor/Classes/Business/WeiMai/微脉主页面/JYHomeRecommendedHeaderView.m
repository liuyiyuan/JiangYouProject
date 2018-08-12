//
//  JYHomeVideoHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeRecommendedHeaderView.h"
#import "HYBLoopScrollView.h"
@implementation JYHomeRecommendedHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
  
    
    NSArray *imageArray = @[@"矩形 13 副本 4",@"矩形 13 副本 4",@"矩形 13 副本 4",@"矩形 13 副本 4"];
    //轮播图
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, pixelValue(360)) imageUrls:imageArray timeInterval:5 didSelect:^(NSInteger atIndex) {
        
        
    } didScroll:^(NSInteger toIndex) {
        
    }];
    
    [self addSubview:loop];
    
    [self addSubview:self.welfare];
    
    [self addSubview:self.redPage];
    
    [self addSubview:self.answer];
    
    
    self.welfare.frame = CGRectMake(0, CGRectGetMaxY(loop.frame) + pixelValue(10), (UI_SCREEN_WIDTH - pixelValue(20))/ 3, pixelValue(120));
    
    
    self.redPage.frame = CGRectMake(CGRectGetMaxX(self.welfare.frame) + pixelValue(10), self.welfare.frame.origin.y, self.welfare.frame.size.width, self.welfare.frame.size.height);
    
    
    self.answer.frame = CGRectMake(CGRectGetMaxX(self.redPage.frame) + pixelValue(10), self.welfare.frame.origin.y, self.welfare.frame.size.width, self.welfare.frame.size.height);
    
    
   
}
//我型我秀
-(UIImageView *)welfare{
    if(!_welfare){
        _welfare = [[UIImageView alloc]init];
        _welfare.image = [UIImage imageNamed:@"jy_home_welfare"];
    }
    return _welfare;
}

//航拍
-(UIImageView *)redPage{
    if(!_redPage){
        _redPage = [[UIImageView alloc]init];
        _redPage.image = [UIImage imageNamed:@"jy_home_redPage"];
    }
    return _redPage;
}

//直播
-(UIImageView *)answer{
    if(!_answer){
        _answer = [[UIImageView alloc]init];
        _answer.image = [UIImage imageNamed:@"jy_home_answer"];
    }
    return _answer;
}




@end
