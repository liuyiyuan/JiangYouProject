//
//  WMAllPatienCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/2/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPatientReportedModel.h"

@protocol WMAllPatienCellDelegate <NSObject>

@optional
-(void)acceptPatientReportAction:(UIButton *)button;
@end


@interface WMAllPatienCell : UITableViewCell

@property (nonatomic ,assign) id<WMAllPatienCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UILabel *symptomsLable;

-(void)setupViewWithModel:(WMPatientReportedModel *)patientReportedModel withTag:(NSInteger )cellIndex;

@end
