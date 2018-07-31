//
//  JYStoreBannerTableViewCell.m
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreBannerTableViewCell.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface JYStoreBannerTableViewCell()<SDCycleScrollViewDelegate>

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end


@implementation JYStoreBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCycleScrollView];
}





- (void)setupCycleScrollView{
    self.cycleScrollView.frame = CGRectMake(0, 0, self.width, self.height);
    self.cycleScrollView.imageURLStringsGroup =@[];
    self.cycleScrollView.titlesGroup = @[];//[NSArray arrayWithArray:titleArr];
//    self.cycleScrollView.growingSDCycleBannerIds = [NSArray arrayWithArray:titleArr];
    [self.contentView addSubview:self.cycleScrollView];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"img_default"]];
        _cycleScrollView.frame = CGRectMake(0, 0, kScreen_width,kScreen_width*155.0/375.0);
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.titleLabelTextColor = [UIColor clearColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"ic_point_selected"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"ic_point_normal"];
    }
    return _cycleScrollView;
}

//SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"index : %@", index);
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
