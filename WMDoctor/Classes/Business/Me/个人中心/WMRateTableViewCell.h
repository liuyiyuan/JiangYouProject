//
//  WMRateTableViewCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDoctorServiceModel.h"
#import "WMEvaluateLabelView.h"
#import "WMStarView.h"

@interface WMRateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentDateLabel;

@property (weak, nonatomic) IBOutlet WMEvaluateLabelView *commentTagView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic,strong) WMStarView * starView;

- (void)setRateCellValue:(WMDoctorServiceCommentsModel *)model;

-(void)setLabelArr:(NSArray *)labelArr;
@end
