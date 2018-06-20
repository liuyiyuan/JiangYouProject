//
//  WMQuestionsCell.h
//  WMDoctor
//
//  Created by xugq on 2017/11/20.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *answer;
@property (weak, nonatomic) IBOutlet UILabel *state;

- (void)setValueWithQuestion:(WMQuestionModel *)question;

@end
