//
//  ContactsCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMContactsModel.h"

@interface ContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


- (void)setCellValue:(WMContactsModel *)model;
@end
