//
//  WMOpenServiceCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellClickSwitchDelegate <NSObject>

- (void)changedSwitchValue:(BOOL)on;

@end

@interface WMOpenServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *openServiceSwitch;

@property (nonatomic,weak) id<cellClickSwitchDelegate> cellDelegate;

@end
