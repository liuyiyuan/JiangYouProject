//
//  JYStoreModuleCell.m
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreModuleCell.h"
#import "WMHomeModuleView.h"
#import "JYStoresViewController.h"
#import "WMTabBarController.h"
#import "WMNavgationController.h"


@interface JYStoreModuleCell()<WMHomeModuleDelegate>

@property(nonatomic, strong) WMHomeModuleView *homeModuleView;  //轮播下的横向滑动小模块

@end

@implementation JYStoreModuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupModuleView];
    }
    return self;
}

- (void)setupModuleView{
    self.homeModuleView.frame = CGRectMake(0, 0, kScreenWidth, 69);
    [self setValue];
    [self.contentView addSubview:self.homeModuleView];
}

- (WMHomeModuleView *)homeModuleView {
    if (!_homeModuleView) {
        _homeModuleView = [[WMHomeModuleView alloc] initWithFrame:CGRectMake(0, 155, kScreen_width, 69)];
        _homeModuleView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _homeModuleView.delegate = self;
    }
    return _homeModuleView;
}

- (void)setValue{
    NSArray *images = @[@"robShopping", @"vipMember", @"coupons", @"merchants", @"tenants"];
    NSArray *titles = @[@"大牌抢购", @"会员", @"优惠券", @"商家", @"商家入驻"];
    [_homeModuleView setValueWithModelArray:images andTitleArr:titles];
}


//WMHomeModuleDelegate
- (void)clickModule:(NSInteger)index{
    if (index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JYStoreModuleClickPanicBuy" object:nil];
    } else if (index == 3){
        WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
        WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
        JYStoresViewController *storesViewController = [[JYStoresViewController alloc] init];
        [navController pushViewController:storesViewController animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
