//
//  WMQuestionDetailAnswerCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HClTextView.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQTextView.h"
#import "QuestionEntity+CoreDataClass.h"
#import "QuestionEntity+CoreDataProperties.h"

@protocol WMQuestionDetailAnswerCellDelegate <NSObject>

-(void)cellClickBtn:(NSString *)str;

-(void)getTempStr:(NSString *)str;

@end

@interface WMQuestionDetailAnswerCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong) HClTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic,copy) NSString * sendText;
@property (nonatomic,strong) IQTextView * iqTextView;
@property (nonatomic,assign)id<WMQuestionDetailAnswerCellDelegate>delegate;

- (void)getQuestionContext:(NSString *)questionId andUserid:(NSString *)userId;

@end
