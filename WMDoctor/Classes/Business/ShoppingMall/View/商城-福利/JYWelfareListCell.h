//
//  JYWelfareListCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYWelfareListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImgView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPopular;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIButton *restaurantFoods;

@end
