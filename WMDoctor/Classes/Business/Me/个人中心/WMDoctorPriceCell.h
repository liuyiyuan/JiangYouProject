//
//  WMDoctorPriceCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMDoctorPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLebel;

- (void)setCellValue:(NSString *)price;

@end
