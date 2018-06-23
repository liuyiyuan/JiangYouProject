//
//  WMOrderCell.m
//  WMDoctor
//
//  Created by xugq on 2017/12/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOrderCell.h"

@implementation WMOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accept.layer.borderWidth = 1;
    self.accept.layer.borderColor = [UIColor colorWithHexString:@"DBDBDB"].CGColor;
}

- (void)setValueWithModel:(WMOrderListModel *)order{
    self.name.text = [NSString stringWithFormat:@"%@ | %@", order.huanzhexm, order.orderDate];
    NSDictionary *stateDic = @{
                               @"0" : @"待完成",
                               @"1" : @"已完成",
                               @"2" : @"已关闭"
                               };
    if ([stateDic.allKeys containsObject:order.orderStatus]) {
        self.state.text = [stateDic objectForKey:order.orderStatus];
    }
    self.type.text = order.orderItem;
    self.rules.text = [NSString stringWithFormat:@"￥%@/%@", order.orderFee, order.unit];
    self.time.text = order.orderEndDate;
    self.accept.hidden = NO;
    self.bottomLine.hidden = NO;
    if ([order.orderType intValue] == 1) {
        if ([order.orderStatus intValue] == 0) {
            //待完成
            [self.accept setTitle:@"回复咨询" forState:UIControlStateNormal];
        } else if ([order.orderStatus intValue] == 1){
            //已完成
            [self.accept setTitle:@"随访" forState:UIControlStateNormal];
        } else if ([order.orderStatus intValue] == 2){
            //已关闭
            [self.accept setTitle:@"随访" forState:UIControlStateNormal];
        }
    } else if ([order.orderType intValue] == 7 || [order.orderType intValue] == 10){
        self.accept.hidden = YES;
        self.bottomLine.hidden = YES;
    } else if ([order.orderType intValue] == 8){
        if ([order.orderStatus intValue] == 0) {
            //待完成
            [self.accept setTitle:@"进入朋友圈" forState:UIControlStateNormal];
        } else if ([order.orderStatus intValue] == 1){
            //已完成
            [self.accept setTitle:@"进入朋友圈" forState:UIControlStateNormal];
        }
    } else if ([order.orderType intValue] == 9) {
        //一问医答
        [self.accept setTitle:@"查看提问" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
