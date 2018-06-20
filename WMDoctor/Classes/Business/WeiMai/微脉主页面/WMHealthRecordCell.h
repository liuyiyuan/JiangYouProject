//
//  WMHealthRecordCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPatientsHealthModel.h"
@interface WMHealthRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *casetypeLable;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)setupViewWithDetailModel:(WMPatientsHealthDetailModel *)patientsHealthDetailModel;
@end
