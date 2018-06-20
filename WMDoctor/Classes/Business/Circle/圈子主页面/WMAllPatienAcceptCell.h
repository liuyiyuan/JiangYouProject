//
//  WMAllPatienAcceptCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/2/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPatientReportedModel.h"

@interface WMAllPatienAcceptCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addEdLable;
@property (weak, nonatomic) IBOutlet UILabel *symptomsLable;

-(void)setupViewWithModel:(WMPatientReportedModel *)patientReportedModel;

@end
