//
//  WMPatientReportedCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPatientReportedModel.h"
@interface WMPatientReportedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

-(void)setupViewWithModel:(WMPatientReportedModel *)patientReportedModel;
@end
