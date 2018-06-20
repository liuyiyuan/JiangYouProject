//
//  WMQuestionsCell.m
//  WMDoctor
//
//  Created by xugq on 2017/11/20.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionsCell.h"

@implementation WMQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithQuestion:(WMQuestionModel *)question{
    //下面内容为了描述label 可以两端对齐
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:question.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *dic = @{
                          NSParagraphStyleAttributeName : paragraphStyle,
                          NSFontAttributeName : [UIFont systemFontOfSize:16]
                          };
    [attributedString setAttributes:dic range:NSMakeRange(0, attributedString.length)];
    self.title.attributedText = attributedString;
    self.time.text = question.askTime;
    self.price.text = question.price;
    self.price.attributedText = [self getTheReainderTimeCopy:question.price];
    self.answer.hidden = YES;
    self.state.hidden = YES;
    self.title.textColor = [UIColor colorWithHexString:@"333333"];
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
            self.title.textColor = [UIColor colorWithHexString:[titleColorDic objectForKey:question.state]];
        }
    }
}

- (NSMutableAttributedString *)getTheReainderTimeCopy:(NSString *) content{
    NSMutableAttributedString *mutableAttriteStr = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *attributeStr1 = [[NSAttributedString alloc] initWithString:@"心意 " attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"],NSBackgroundColorAttributeName : [UIColor whiteColor]}];
    NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"FF3D00"],NSBackgroundColorAttributeName : [UIColor whiteColor]}];
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"FF3D00"],NSBackgroundColorAttributeName : [UIColor whiteColor]}];
    [mutableAttriteStr appendAttributedString:attributeStr1];
    [mutableAttriteStr appendAttributedString:attributeStr2];
    [mutableAttriteStr appendAttributedString:attributeStr3];
    return mutableAttriteStr;
}

@end
