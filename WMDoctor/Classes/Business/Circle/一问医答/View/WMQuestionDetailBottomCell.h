//
//  WMQuestionDetailBottomCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMQuestionDetailModel.h"

@interface WMQuestionDetailBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *doctorImage;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *departmentName;
@property (weak, nonatomic) IBOutlet UILabel *doctorTitle;
@property (weak, nonatomic) IBOutlet UILabel *doctorAnswer;

- (void)setCellValue:(WMQuestionDetailInfoModel *)model;

@end
