//
//  WMAllPatientTableViewCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/2/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTotalPatientsDataModel.h"

@interface WMAllPatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *VIPFlag;
-(void)setupViewWithModel:(WMTotalPatientsModel *)totalPatientsDataModel;
@end
