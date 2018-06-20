//
//  UITableView+BackgroundView.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/21.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "UITableView+BackgroundView.h"

@implementation UITableView (BackgroundView)
//------------------------------------------------------------------------------tableview start
- (void)showBackgroundView:(NSString *)desc type:(BackgroundType)backgroundType
{
    NSString *imageName = nil;
    switch (backgroundType) {
        case BackgroundTypeEmpty:
            imageName = @"Image_empty_default";
            break;
        case BackgroundTypeError:
            imageName = @"Image_empty_default";
            break;
        case BackgroundTypeNetworkError:
            imageName = @"Image_error_network";
            break;
        case BackgroundTypeNOZiXun://暂无咨询
            imageName = @"quesheng_zixun";
            break;
        case BackgroundTypeNOTongZhi://暂无通知
            imageName = @"quesheng_tongzhi";
            break;
        case BackgroundTypeNOTrade://暂无交易消息
            imageName = @"quesheng_zhangdan";
            break;
        case BackgroundTypeNOPatient://圈子暂无患者
            imageName = @"quesheng_quanzi";
            break;
        case BackgroundTypeNORecord://暂无档案信息
            imageName = @"noHealthData";
            
            
            break;
        case BackgroundTypeNODingdan://圈子暂无订单
            imageName = @"quesheng_dingdan";
            break;
        case BackgroundTypeNOUNReport:  //胎心暂无待处理报告
            imageName = @"bg_daichuliquesheng";
            break;
        case BackgroundTypeNOReport:  //胎心暂无已处理报告
            imageName = @"bg_yichuliquesheng";
            break;
        case BackgroundTypeSearchNoPatient:  //没有找到相关患者
            imageName = @"medicalCircle";
            break;
        default:
            break;
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = CGPointMake(CGRectGetMidX(backgroundView.frame),backgroundView.height*0.4);
    [backgroundView addSubview:imageView];
    if (![strOrEmpty(desc) isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.width, 21)];
        label.text = desc;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.center = CGPointMake(imageView.centerX, imageView.bottom+20);
        [backgroundView addSubview:label];
    }
    self.backgroundView = backgroundView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//设置Table背景图片
- (void)showBackgroundView:(NSString *)imgName title:(NSString *)desc{
    NSString *imageName = imgName;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = CGPointMake(CGRectGetMidX(backgroundView.frame),backgroundView.height*0.4);
    [backgroundView addSubview:imageView];
    if (![strOrEmpty(desc) isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.width, 21)];
        label.text = desc;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.center = CGPointMake(imageView.centerX, imageView.bottom+20);
        [backgroundView addSubview:label];
    }
    self.backgroundView = backgroundView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)removeBackgroundViewForNeedToChangeSeparator:(BOOL)needToChangeSeparator
{
    self.backgroundView = nil;
    if (needToChangeSeparator){
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)showFooterBackgroundView:(NSString *)desc type:(BackgroundType)backgroundType{
    NSString *imageName = nil;
    switch (backgroundType) {
        case BackgroundTypeEmpty:
            imageName = @"Image_empty_default";
            break;
        case BackgroundTypeError:
            imageName = @"Image_empty_default";
            break;
        case BackgroundTypeNetworkError:
            imageName = @"Image_error_network";
            break;
        case BackgroundTypeNORecord:
            imageName = @"noHealthData";
            break;
        default:
            break;
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 250)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = CGPointMake(CGRectGetMidX(backgroundView.frame),backgroundView.height*0.4);
    [backgroundView addSubview:imageView];
    if (![strOrEmpty(desc) isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.width, 21)];
        label.text = desc;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.center = CGPointMake(imageView.centerX, imageView.bottom+20);
        [backgroundView addSubview:label];
    }
    self.tableFooterView = backgroundView;
}

- (void)removeFooterBackgroundViewForTableView{
    self.tableFooterView = nil;
}
//------------------------------------------------------------------------------tableview end

@end
