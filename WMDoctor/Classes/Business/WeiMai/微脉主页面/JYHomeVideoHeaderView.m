//
//  JYHomeVideoHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeVideoHeaderView.h"

@implementation JYHomeVideoHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    [self addSubview:self.myStyle];
    [self.myStyle addSubview:self.myStyleLaebl];
    
    [self addSubview:self.airPicture];
    [self.airPicture addSubview:self.airPictureLaebl];
    
    [self addSubview:self.live];
    [self.live addSubview:self.liveLaebl];
    
    
    self.myStyle.frame = CGRectMake(pixelValue(20), pixelValue(20), (UI_SCREEN_WIDTH - pixelValue(80)) / 3, pixelValue(100));
    self.myStyleLaebl.frame = CGRectMake(0, 0, self.myStyle.frame.size.width, self.myStyle.frame.size.height);
    
    self.airPicture.frame = CGRectMake(CGRectGetMaxX(self.myStyle.frame) + pixelValue(20), self.myStyle.frame.origin.y, self.myStyle.frame.size.width, self.myStyle.frame.size.height);
    self.airPictureLaebl.frame = CGRectMake(0, 0, self.myStyle.frame.size.width, self.myStyle.frame.size.height);
    
    self.live.frame = CGRectMake(CGRectGetMaxX(self.airPicture.frame) + pixelValue(20), self.airPicture.frame.origin.y, self.myStyle.frame.size.width, self.myStyle.frame.size.height);
    self.liveLaebl.frame = CGRectMake(0, 0, self.myStyle.frame.size.width, self.myStyle.frame.size.height);
    
//    NSArray *imageArray = @[@"矩形 13",@"矩形 13",@"矩形 13",@"矩形 13"];
    //轮播图
    self.loop = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.myStyle.frame) + pixelValue(20), UI_SCREEN_WIDTH, pixelValue(360)) imageUrls:self.imageUrls timeInterval:5 didSelect:^(NSInteger atIndex) {
        
        
    } didScroll:^(NSInteger toIndex) {
        
    }];
    
    [self addSubview:self.loop];
}
//我型我秀
-(UIImageView *)myStyle{
    if(!_myStyle){
        _myStyle = [[UIImageView alloc]init];
    }
    return _myStyle;
}
//我型我秀label
-(UILabel *)myStyleLaebl{
    if(!_myStyleLaebl){
        _myStyleLaebl = [[UILabel alloc]init];
        _myStyleLaebl.textColor = [UIColor whiteColor];
        _myStyleLaebl.font = [UIFont systemFontOfSize:pixelValue(26)];
        _myStyleLaebl.textAlignment = NSTextAlignmentCenter;
    }
    return _myStyleLaebl;
}
//航拍
-(UIImageView *)airPicture{
    if(!_airPicture){
        _airPicture = [[UIImageView alloc]init];
    }
    return _airPicture;
}
//航拍label
-(UILabel *)airPictureLaebl{
    if(!_airPictureLaebl){
        _airPictureLaebl = [[UILabel alloc]init];
        _airPictureLaebl.textColor = [UIColor whiteColor];
        _airPictureLaebl.font = [UIFont systemFontOfSize:pixelValue(26)];
        _airPictureLaebl.textAlignment = NSTextAlignmentCenter;
    }
    return _airPictureLaebl;
}
//直播
-(UIImageView *)live{
    if(!_live){
        _live = [[UIImageView alloc]init];
    }
    return _live;
}

//直播label
-(UILabel *)liveLaebl{
    if(!_liveLaebl){
        _liveLaebl = [[UILabel alloc]init];
        _liveLaebl.textColor = [UIColor whiteColor];
        _liveLaebl.font = [UIFont systemFontOfSize:pixelValue(26)];
        _liveLaebl.textAlignment = NSTextAlignmentCenter;
    }
    return _liveLaebl;
}

-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    [self configUI];
}

-(void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    if(tagArray.count == 3){
        NSDictionary *dict0 = tagArray[0];
        NSDictionary *dict1 = tagArray[1];
        NSDictionary *dict2 = tagArray[2];
        [self.myStyle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict0[@"tagImg"]]] placeholderImage:nil];
        self.myStyleLaebl.text = dict0[@"captions"];
        [self.airPicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict1[@"tagImg"]]] placeholderImage:nil];
        self.airPictureLaebl.text = dict1[@"captions"];
        [self.live sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict2[@"tagImg"]]] placeholderImage:nil];
        self.liveLaebl.text = dict2[@"captions"];
    }
}

@end
