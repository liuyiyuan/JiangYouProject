//
//  JYSCCHeadlineCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSCCHeadlineModel.h"

@interface JYSCCHeadlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *headlineImageView;


- (void)setValueWithJYSCCHeadlineModel:(JYSCCHeadlineModel *)headlineModel;

@end
