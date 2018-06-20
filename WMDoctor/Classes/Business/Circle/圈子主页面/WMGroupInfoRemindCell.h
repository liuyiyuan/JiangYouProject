//
//  WMGroupInfoRemindCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/4/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMGroupInfoRemindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *theSwitch;
- (void)setValueforCell:(BOOL)flag;
@property (nonatomic,copy) NSString * tagertId;
@end
