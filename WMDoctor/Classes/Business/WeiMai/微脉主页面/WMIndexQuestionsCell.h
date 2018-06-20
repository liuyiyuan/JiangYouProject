//
//  WMIndexQuestionsCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMIndexQuestionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *answer;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIView *theView;

- (void)setValueWithIndexQuestion:(WMQuestionModel *)question;

@end
