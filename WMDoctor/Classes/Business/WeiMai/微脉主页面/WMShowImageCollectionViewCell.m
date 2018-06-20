//
//  WMShowImageCollectionViewCell.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMShowImageCollectionViewCell.h"
#import "WMImageView.h"
#import "UIImageView+WebCache.h"

@implementation WMShowImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setupView:(NSString *)urlStr{
    
    WMImageView *imageView=[[WMImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    //imageView.tag=200+i;
    NSURL *url=[NSURL URLWithString:urlStr];
    [imageView.imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [imageView calculateImageSizeToShow:image];
        }
    }];
    
    __weak typeof(self) weakself = self;
    
    imageView.singTapHide = ^{
        
        if (weakself.delegate&&[weakself.delegate performSelector:@selector(SingTapAction)]) {
            [weakself.delegate SingTapAction];
        }
        
        //用户点击取消了，消失block
        
    };
    //[imageView.imageView sd_setImageWithURL:url];
    //[imageView setImageObject:self.array[i]];
    imageView.backgroundColor=[UIColor greenColor];
    [self addSubview:imageView];
    
}

-(void)setupImageView:(UIImage *)image{
    
    WMImageView *imageView=[[WMImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    //imageView.tag=200+i;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView calculateImageSizeToShow:image];
    imageView.imageView.image=image;
    __weak typeof(self) weakself = self;
    
    imageView.singTapHide = ^{
        
        if (weakself.delegate&&[weakself.delegate performSelector:@selector(SingTapAction)]) {
            [weakself.delegate SingTapAction];
        }
        
        //用户点击取消了，消失block
        
    };
    imageView.backgroundColor=[UIColor greenColor];
    [self addSubview:imageView];
    
}

@end
