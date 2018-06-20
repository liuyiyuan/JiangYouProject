//
//  WMIndexQuestionsCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMIndexQuestionsCell.h"

@implementation WMIndexQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.theView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.theView.layer.shadowColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
    self.theView.layer.shadowOpacity = 0.3;
    
    self.theView.layer.shadowRadius = 2;
    
    self.theView.layer.cornerRadius = 4;
    
    self.theView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithIndexQuestion:(WMQuestionModel *)question{
    self.titleLabel.text = question.content;
    self.timeLabel.text = question.askTime;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",question.price];
    
    NSDictionary *stateDic = @{@"2" : @"被抢答",
                               @"3" : @"已解答",
                               @"4" : @"已关闭",
                               @"5" : @"解答中"
                               };
    NSDictionary *stateColorDic = @{
                                    @"2" : @"999999",
                                    @"3" : @"333333",
                                    @"4" : @"999999",
                                    @"5" : @"333333"
                                    };
    NSDictionary *titleColorDic = @{
                                    @"2" : @"999999",
                                    @"3" : @"333333",
                                    @"4" : @"B2B2B2",
                                    @"5" : @"333333"
                                    };
    
    self.answer.hidden = YES;
    self.state.hidden = YES;
    if ([question.state intValue] == 1) {
        self.answer.hidden = NO;
    } else {
        self.state.hidden = NO;
        if ([stateDic.allKeys containsObject:question.state]) {
            self.state.text = [stateDic objectForKey:question.state];
        }
        if ([stateColorDic.allKeys containsObject:question.state]) {
            self.state.textColor = [UIColor colorWithHexString:[stateColorDic objectForKey:question.state]];
        }
        if ([titleColorDic.allKeys containsObject:question.state]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:[titleColorDic objectForKey:question.state]];
        }
    }
}

- (IBAction)anwerBtn:(id)sender {
    
}

@end
