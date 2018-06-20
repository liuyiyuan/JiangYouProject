//
//  WMServiceTitleCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMServiceTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nothingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setCellValue:(NSString *)notingStr andPrice:(NSString *)priceStr;

@end
