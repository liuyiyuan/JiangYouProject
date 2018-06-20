//
//  ContactsCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "ContactsCell.h"


@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addBtn.layer.borderWidth = 0.5;
    self.addBtn.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(WMContactsModel *)model{
    self.contactName.text = model.contactName;
    self.contactNumber.text = model.contactNumber;
    self.contactImage = model.contactImage;
}

@end
