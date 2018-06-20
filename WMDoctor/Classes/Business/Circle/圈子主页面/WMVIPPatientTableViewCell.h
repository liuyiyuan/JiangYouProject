//
//  WMVIPPatientTableViewCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMVPIPatientsModel.h"
@interface WMVIPPatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *illNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;


-(void)setViewWithModel:(WMVPIPatientsDetailModel *)patientsDetailModel;
@end
