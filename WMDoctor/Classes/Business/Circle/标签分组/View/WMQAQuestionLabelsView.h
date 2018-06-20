//
//  WMQAQuestionLabelsView.h
//  Micropulse
//
//  Created by airende on 2017/11/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMQAQuestionLabelsDelegate <NSObject>

- (void)questionLabelsDidTapLabel:(UILabel *)label labelsView:(id)labelsView;
- (void)textFieldDidChanged:(NSString *)text;
- (void)keyboardWillHidden:(UITextField *)textField;

@end

@interface WMQAQuestionLabelsView : UIView

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UILabel *seleLabel;


@property (nonatomic, weak) id<WMQAQuestionLabelsDelegate> delegate;

- (void)setLabelSizeWidth:(CGFloat)w height:(CGFloat)h showTitle:(BOOL)isShow;
- (void)setValueWithSelectedTagsArr:(NSMutableArray *)selectTags;
- (void)setValueWithAllTagsArr:(NSMutableArray *)allTags andSelectedTagsArr:(NSMutableArray *)selectedTags;

@end
