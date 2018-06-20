//
//  WMQAQuestionLabelsView.m
//  Micropulse
//
//  Created by airende on 2017/11/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMQAQuestionLabelsView.h"
#import "UIView+Extension.h"
#import "WMPatientReportedModel.h"
#import "NSArray+Additions.h"


#define WMMargin 10 // 默认边距

@interface WMQAQuestionLabelsView (){
    NSMutableArray *_array;
    
    CGFloat _w;//宽度添加
    CGFloat _h;//高度添加
    BOOL _showTitle; //显示标题 区分使用地方 没标题默认选第一个
}
@property (nonatomic ,strong) UIView *stringView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation WMQAQuestionLabelsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupView{
    
    if (_showTitle == YES) {
        
        UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 250, 20)];
        titleNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        titleNameLabel.font = [UIFont systemFontOfSize:14.0];
        titleNameLabel.text = @"所有标签";
        [self addSubview:titleNameLabel];
        _stringView = [[UIView alloc] initWithFrame:CGRectMake(15, 45, kScreen_width-30, 100)];
        [self addSubview:_stringView];
    }else{
        _stringView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreen_width-30, 100)];
        [self addSubview:_stringView];
    }
}

- (void)setLabelSizeWidth:(CGFloat)w height:(CGFloat)h showTitle:(BOOL)isShow{
    _w = w;
    _h = h;
    _showTitle = isShow;
    [self setupView];
}

- (void)selectStyleLabel:(UILabel *)label{
    self.seleLabel = label;
    self.seleLabel.layer.borderWidth = 1;
    self.seleLabel.layer.borderColor = [UIColor colorWithHexString:@"18A2FF"].CGColor;
    self.seleLabel.textColor = [UIColor colorWithHexString:@"18A2FF"];
}

/** 添加标签 */
- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor colorWithHexString:@"dbdbdb"].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];//label.frame 自适应
    
    if (_h!=0 && _w!=0) {
        label.width += _w;
        label.height += _h;
    }else{
        label.width += 30;
        label.height += 20;
    }

    label.layer.cornerRadius = label.height/2;
    label.clipsToBounds = YES;
    return label;
}

- (void)stringDidClick:(UIGestureRecognizer *)ges{
    
    UILabel *label = (UILabel *)ges.view;
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionLabelsDidTapLabel:labelsView:)]) {
        [self.delegate questionLabelsDidTapLabel:label labelsView:self];
    }
    
}

- (void)setValueWithSelectedTagsArr:(NSMutableArray *)selectTags{
    _array = selectTags;
    
    // 清空标签容器的子控件
    [self.stringView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *labelArray = [NSMutableArray array];
    UILabel *tmepLabel = nil;
    for (int i = 0; i<selectTags.count; i++) {
        
        WMPatientTagModel *model = selectTags[i];
        
        //label样式设置
        UILabel *label = [self labelWithTitle:model.tagName];
        label.userInteractionEnabled = YES;
        label.tag = model.tagId.integerValue;
        
        //设置选中状态
        [self selectStyleLabel:label];
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stringDidClick:)]];
        [self.stringView addSubview:label];
        [labelArray addObject:label];
    }
    
    //处理LabelId不存在 选择第一个问题
    if (self.seleLabel == nil) {
        [self selectStyleLabel:tmepLabel];
    }
    
    // 计算位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;//🏷️个数 （间隙个数）
    CGFloat countCol = 0;//行数
    
    
    // 调整布局
    for (UILabel *subView in labelArray) {
        // 当搜索字数过多，宽度为contentView的宽度
        
        if (subView.width > _stringView.width){
            subView.width = _stringView.width;
        }
        if (currentX + subView.width + WMMargin/*默认边距*/ * countRow > _stringView.width) { // 得换行
            subView.x = 0;
            subView.y = (currentY += subView.height) + WMMargin * ++countCol;
            currentX = subView.width;
            countRow = 1;
        } else { // 不换行
            subView.x = (currentX += subView.width) - subView.width + WMMargin * countRow;
            subView.y = currentY + WMMargin * countCol;
            countRow ++;
        }
    }
    
    // 设置stringView高度
    float stringViewHeight = CGRectGetMaxY(_stringView.subviews.lastObject.frame);
    if (_stringView.subviews.lastObject.right + 100 > kScreen_width) {
        stringViewHeight = CGRectGetMaxY(_stringView.subviews.lastObject.frame) + 30;
    }
    if (CGRectGetMaxY(_stringView.subviews.lastObject.frame) == 0) {
        stringViewHeight = 40;
    }
    self.stringView.height = stringViewHeight;
    self.viewHeight = CGRectGetMaxY(_stringView.frame) + WMMargin;
    [self.stringView addSubview:[self getTextFieldWithLabelsArr:labelArray]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setValueWithAllTagsArr:(NSMutableArray *)allTags andSelectedTagsArr:(NSMutableArray *)selectedTags{
    _array = allTags;
    
    // 清空标签容器的子控件
    [self.stringView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *labelArray = [NSMutableArray array];
    UILabel *tmepLabel = nil;
    for (int i = 0; i<allTags.count; i++) {
        
        WMPatientTagModel *model = allTags[i];
        
        //label样式设置
        UILabel *label = [self labelWithTitle:model.tagName];
        label.userInteractionEnabled = YES;
        label.tag = model.tagId.integerValue;
        
        //设置选中状态
        if ([[NSArray getTagNames:selectedTags] containsObject:model.tagName]) {
            [self selectStyleLabel:label];
        }
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stringDidClick:)]];
        [self.stringView addSubview:label];
        [labelArray addObject:label];
    }
    
    //处理LabelId不存在 选择第一个问题
    if (self.seleLabel == nil) {
        [self selectStyleLabel:tmepLabel];
    }
    
    // 计算位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;//🏷️个数 （间隙个数）
    CGFloat countCol = 0;//行数
    
    
    // 调整布局
    for (UILabel *subView in labelArray) {
        // 当搜索字数过多，宽度为contentView的宽度
        
        if (subView.width > _stringView.width){
            subView.width = _stringView.width;
        }
        if (currentX + subView.width + WMMargin/*默认边距*/ * countRow > _stringView.width) { // 得换行
            subView.x = 0;
            subView.y = (currentY += subView.height) + WMMargin * ++countCol;
            currentX = subView.width;
            countRow = 1;
        } else { // 不换行
            subView.x = (currentX += subView.width) - subView.width + WMMargin * countRow;
            subView.y = currentY + WMMargin * countCol;
            countRow ++;
        }
    }
    
    // 设置stringView高度
    self.stringView.height = CGRectGetMaxY(_stringView.subviews.lastObject.frame);
    self.viewHeight = CGRectGetMaxY(_stringView.frame) + WMMargin;
}

- (UITextField *)getTextFieldWithLabelsArr:(NSArray *)labels{
    UILabel *lastLab = [[UILabel alloc] init];
    if (labels.count > 0) {
        lastLab = [labels lastObject];
    }
    float textField_x = lastLab.right + 15;
    float textField_y = lastLab.top + 5;
    if (kScreen_width - lastLab.right < 100 || labels.count == 0) {
        textField_x = 0;
        textField_y = lastLab.bottom + 15;
    }
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textField_x, textField_y, 80, 20)];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.placeholder = @"输入标签名";
    [self.textField addTarget:self action:@selector(textFieldInEditing) forControlEvents:UIControlEventEditingChanged];
    return self.textField;
}

- (void)textFieldInEditing{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidChanged:)]) {
        [self.delegate textFieldDidChanged:self.textField.text];
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    NSLog(@"keyboard will Hide");
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardWillHidden:)] && !stringIsEmpty(self.textField.text)) {
        [self.delegate keyboardWillHidden:self.textField];
    }
}

@end
