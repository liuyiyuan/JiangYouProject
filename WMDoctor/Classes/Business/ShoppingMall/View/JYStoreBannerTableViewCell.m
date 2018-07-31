//
//  JYStoreBannerTableViewCell.m
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreBannerTableViewCell.h"
#import "WMHomeModuleView.h"
//#import "SDCycleScrollView.h"

@interface JYStoreBannerTableViewCell()<WMHomeModuleDelegate>

@property(nonatomic, strong) WMHomeModuleView *homeModuleView;  //轮播下的横向滑动小模块
//@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end


@implementation JYStoreBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initHomeModuleView{
    [self.homeModuleView setValueWithModelArray:@[]];
    self.homeModuleView.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:self.homeModuleView];
}

- (WMHomeModuleView *)homeModuleView {
    if (!_homeModuleView) {
        _homeModuleView = [[WMHomeModuleView alloc] initWithFrame:CGRectMake(0, 155, kScreen_width, 98)];
        _homeModuleView.delegate = self;
    }
    return _homeModuleView;
}
// # WMHomeModuleDelegate
- (void)goModuleWith:(HomeAppModel *)appModel{
    
}

- (void)setValueWithModelArray:(NSArray *)modelArray{
    [_homeModuleView setValueWithModelArray:modelArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
