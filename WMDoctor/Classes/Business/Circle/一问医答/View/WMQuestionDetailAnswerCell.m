//
//  WMQuestionDetailAnswerCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailAnswerCell.h"


@implementation WMQuestionDetailAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView * textsuperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 230)];
    self.sendBtn.userInteractionEnabled = NO;
    //IQ
    
    self.iqTextView = [[IQTextView alloc]initWithFrame:CGRectMake(15, 15, kScreen_width-30, 220)];
    [self.iqTextView setPlaceholder:@"每个问题仅有一次回答机会，不可追加补充，回复后订单关闭。请根据您的专业知识尽量详细解答，以免造成患者退款，感谢您的付出。"];
    self.iqTextView.font = [UIFont systemFontOfSize:16];
    self.iqTextView.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.iqTextView.toolbarPlaceholder = @"问答详情";
    self.iqTextView.delegate = self;
    [textsuperView addSubview:self.iqTextView];
    [self addSubview:textsuperView];
    
//    self.textView = [[NSBundle mainBundle] loadNibNamed:@"HClTextView" owner:self options:nil].lastObject;
//    self.textView.frame = CGRectMake(15, 15, kScreen_width-30, 220);
//    [self.textView setPlaceholder:@"您可以根据自己的专业知识、从业经验或个人见解，提供尽可能准确、全面、详细的解答。防止单被其他医生抢答，请注意提交回答的速度" contentText:@"666" maxTextCount:5000];
    
//    self.textView.delegate = self;
//    [self.textView setBottomDivLineHidden:YES];
//    [self.textView setTextCountLabelHidden:YES];
//    [self.textView setClearButtonType:ClearButtonAppearWhenEditing];
//    [textsuperView addSubview:self.textView];
//    [self addSubview:textsuperView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self addGestureRecognizer:tapGestureRecognizer];
    
}


- (void)getQuestionContext:(NSString *)questionId andUserid:(NSString *)userId{
    //获取回复草稿
    QuestionEntity * tempModel = [QuestionEntity getQuestionEntityWith:userId andQuestionId:questionId];
    if (!stringIsEmpty(tempModel.context)) {
        self.iqTextView.text = tempModel.context;
        self.sendText = tempModel.context;
        if (tempModel.context.length >= 20) {
            [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            [self.sendBtn setBackgroundColor:[UIColor colorWithHexString:@"18a2ff"]];
            self.sendBtn.userInteractionEnabled = YES;
        }
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textView resignFirstResponder];
}

- (IBAction)answerBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickBtn:)]) {
        [self.delegate cellClickBtn:self.sendText];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.sendText = textView.text;
    //获取临时字符串用于存储
    if (self.delegate && [self.delegate respondsToSelector:@selector(getTempStr:)]) {
        [self.delegate getTempStr:self.sendText];
    }
    
    if (textView.text.length >= 20) {
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:[UIColor colorWithHexString:@"18a2ff"]];
        self.sendBtn.userInteractionEnabled = YES;
    }else{
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:[UIColor colorWithHexString:@"e6e7e8"]];
        self.sendBtn.userInteractionEnabled = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
