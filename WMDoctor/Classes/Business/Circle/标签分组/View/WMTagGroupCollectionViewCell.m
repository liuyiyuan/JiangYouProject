//
//  WMTagGroupCollectionViewCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagGroupCollectionViewCell.h"

@implementation WMTagGroupCollectionViewCell

- (void)setValueForTag:(WMPatientTagModel *)model{
    self.tagTextFeild.layer.cornerRadius = 15;
    self.tagTextFeild.layer.borderWidth = 0.5;
    self.tagTextFeild.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
    self.tagTextFeild.text = model.tagName;
    self.tagTextFeild.textColor = [UIColor colorWithHexString:@"18a2ff"];
    self.tagTextFeild.textAlignment = NSTextAlignmentCenter;
    self.tagTextFeild.enabled = NO;
    self.tagTextFeild.delegate = self;
}

- (void)setTagStyle:(BOOL)flag{
    if (flag) {
        
    }
}


- (void)setValueForText{
    self.tagTextFeild.layer.borderWidth = 0;
    self.tagTextFeild.delegate = self;
    self.tagTextFeild.enabled = YES;
    self.tagTextFeild.placeholder = @"输入标签名";
    self.tagTextFeild.text = @"";
    self.tagTextFeild.textColor = [UIColor colorWithHexString:@"333333"];
    self.tagTextFeild.textAlignment = NSTextAlignmentLeft;
    [self.tagTextFeild becomeFirstResponder];
//    self.layer.borderWidth = 0;
//    self.contentView.layer.borderWidth = 0;
    [self.tagTextFeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(EnterText:)]) {
        
        if (stringIsEmpty(textField.text)) {
            [WMHUDUntil showMessageToWindow:@"您输入的标签内容不能为空"];
            return NO;
        }
        
        WMTagModel * model = [WMTagModel new];
        model.tagName = textField.text;
        model.flag = @"2";
        model.tagId = @"";
        
        [self.delegate EnterText:model];
    }
    [self.tagTextFeild resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.delegate textFieldDidChange:textField.text];
    }
    CGFloat maxLength = 20;
    NSString *toBeString = textField.text;
    
    float textWidth = [CommonUtil widthForLabelWithText:toBeString height:20 font:[UIFont systemFontOfSize:14]];
    if (textWidth < 70) {
        textWidth = 70;
    }
    self.size = CGSizeMake(textWidth+30, 30);
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (IBAction)touchEnter:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(EnterText:)]) {
        
        [self.delegate EnterText:nil];
    }
}

@end
