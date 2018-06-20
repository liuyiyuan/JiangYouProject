//
//  WMServiceListCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/7.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDoctorServiceModel.h"

@protocol WMServiceListCellDelegate <NSObject>

-(void)cellClickBtn:(NSString *)str andBtn:(UIButton *)btn;

@end

@interface WMServiceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *priceOne;
@property (weak, nonatomic) IBOutlet UILabel *priceTwo;

@property (nonatomic,assign)id<WMServiceListCellDelegate>delegate;

- (void)setCellValue:(WMDoctorMyServiceModel *)model;
@end
