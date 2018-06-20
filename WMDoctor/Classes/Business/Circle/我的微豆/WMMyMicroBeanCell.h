//
//  WMMyMicroBeanCell.h
//  WMDoctor
//
//  Created by xugq on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMyMicroBeanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *hospital;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIButton *exchange;

- (void)setValueWithBeanExchangeModel:(WMBeanExchangeModel *)microBean;

@end
