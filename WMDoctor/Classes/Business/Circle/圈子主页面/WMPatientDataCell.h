//
//  WMPatientDataCell.h
//  WMDoctor
//
//  Created by xugq on 2017/8/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMPatientDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *disease;
@property (weak, nonatomic) IBOutlet UILabel *sectionName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *interrogationTime;

- (void)setValueWithPatientHealthModel:(WMPatientHealthModel *)health;

@end
