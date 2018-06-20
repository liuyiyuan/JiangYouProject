//
//  WMStarView.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMStarView.h"

@implementation WMStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



/**
 此处还有重用问题，虽暂不影响功能，但是性能需要提升，现在有点忙，待日后解决。

 @param starValue 星星的值
 */
-(void)setStarValue:(float)starValue{
    BOOL flag = false;
    //统一安卓方案0.3-0.8显示半颗
    if (starValue >= 0 && starValue <5.1) {
        int b = (int)starValue;
        for (int i = 0; i < 5; i++) {
            if (i < b) {       //一颗星星
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*i, 0, 15, 15)];
                imageView.tag = 101;
                imageView.image = [UIImage imageNamed:@"ic_mine_homepagestar"];
                [self addSubview:imageView];
            }else{      //无星星
                if (flag) {
                    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*i, 0, 15, 15)];
                    imageView.image = [UIImage imageNamed:@"ic_mine_homepagestar3"];
                    [self addSubview:imageView];
                }else{
                    if (starValue < (b+0.3)) {  //无星星
                        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*i, 0, 15, 15)];
                        imageView.image = [UIImage imageNamed:@"ic_mine_homepagestar3"];
                        [self addSubview:imageView];
                    }else if (starValue > (b+0.3) && starValue < (b+0.8)){  //半颗星星
                        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*i, 0, 15, 15)];
                        imageView.image = [UIImage imageNamed:@"ic_mine_homepagestar2"];
                        [self addSubview:imageView];
                    }else{  //一颗星星
                        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*i, 0, 15, 15)];
                        imageView.image = [UIImage imageNamed:@"ic_mine_homepagestar"];
                        [self addSubview:imageView];
                    }
                    flag = true;    //接下来均为无星星
                }
                
            }
        }
    }
    if (self.openValue) {
        if (!self.ValueLabel) {
            [self.ValueLabel removeFromSuperview];
            self.ValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 35, 15)];
            self.ValueLabel.font = [UIFont systemFontOfSize:12];
            self.ValueLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
            self.ValueLabel.text = [NSString stringWithFormat:@"%.1f",starValue];
            [self addSubview:self.ValueLabel];
        }else{
            self.ValueLabel.text = [NSString stringWithFormat:@"%.1f",starValue];
        }
        
    }
    
}


@end
