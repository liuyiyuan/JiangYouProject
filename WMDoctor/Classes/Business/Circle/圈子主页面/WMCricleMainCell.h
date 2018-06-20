//
//  WMCricleMainCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCricleGroupModel.h"
@interface WMCricleMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UILabel *unreadLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeft;

-(void)setupViewWithModel:(WMCricleGroupModel *)circleGroupModel;

- (void)medicalCircleVCSetupValueWithModel:(WMCricleGroupModel *)circleGroupModel;
@end
