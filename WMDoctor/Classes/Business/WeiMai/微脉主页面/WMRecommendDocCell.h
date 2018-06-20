//
//  WMRecommendDocCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDoctorCardModel.h"
@interface WMRecommendDocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *choiceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageVew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLable;

-(void)setupViewWithModel:(WMDoctorCardDetailModel *)doctorCardDetailModel;

@end
