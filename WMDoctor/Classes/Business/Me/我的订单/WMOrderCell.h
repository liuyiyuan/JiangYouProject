//
//  WMOrderCell.h
//  WMDoctor
//
//  Created by xugq on 2017/12/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *rules;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *accept;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)setValueWithModel:(WMOrderListModel *)order;

@end
