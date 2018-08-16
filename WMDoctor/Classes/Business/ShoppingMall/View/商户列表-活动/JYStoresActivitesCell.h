//
//  JYStoresActivitesCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYStoresActivitesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *activeImageViewOne;
@property (weak, nonatomic) IBOutlet UIButton *activeImageViewTwo;
@property (weak, nonatomic) IBOutlet UIButton *activeImageViewThree;


/**
 商户列表-活动设置数据

 @param actives <#actives description#>
 */
- (void)setValueWithActives:(NSArray *)actives;

@end
