//
//  WMOrderCountCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMOrderCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
- (void)setValueForCell:(NSString *)price;
@end
