//
//  WMIntegralDetailCell.h
//  WMDoctor
//
//  Created by xugq on 2017/11/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMIntegralDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *point;

- (void)setValueWithIntegral:(WMIntegralModel *)integral;

@end
