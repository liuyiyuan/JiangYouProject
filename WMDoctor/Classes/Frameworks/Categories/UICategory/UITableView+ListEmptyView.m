//
//  UITableView+ListEmptyView.m
//  WMDoctor
//
//  Created by choice-ios1 on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "UITableView+ListEmptyView.h"

@implementation UITableView (ListEmptyView)

static char confirmButtonKey;

static CGFloat const imageViewWidth = 160;
static CGFloat const imageViewHeight = 160;
static CGFloat const itemSpace = 20;

static CGFloat const labelRectX = 50;

static CGFloat const buttonWidth = 175;
static CGFloat const buttonHeight = 40;



- (void)showListEmptyView:(NSString *)imgName{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    NSString *imageName = imgName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = backgroundView.frame;
    [backgroundView addSubview:imageView];
    self.backgroundView = backgroundView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)showListEmptyView:(NSString *)imgName
                    title:(NSString *)desc
{
    [self showListEmptyView:imgName title:desc buttonTitle:nil completion:NULL];
}

- (void)showListEmptyView:(NSString *)imgName
                    title:(NSString *)desc
              buttonTitle:(NSString *)desc2
               completion:(void(^)(UIButton* button))block
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    NSString *imageName = imgName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake((self.width-imageViewWidth)/2, 64+itemSpace, imageViewWidth, imageViewHeight);
    [backgroundView addSubview:imageView];
    
    
    CGFloat labelWidth = self.width - labelRectX*2;
    UIFont *labelFont  = [UIFont systemFontOfSize:14];
    CGFloat labelHeight = [CommonUtil heightForLabelWithText:desc width:labelWidth font:labelFont];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = desc;
    label.numberOfLines = 2;
    label.frame = CGRectMake(labelRectX, imageView.bottom+itemSpace, labelWidth, labelHeight);
    label.font = labelFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    [backgroundView addSubview:label];
    
    
    if (!stringIsEmpty(desc2)) {

        UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:desc2 forState:UIControlStateNormal];
        confirmButton.frame = CGRectMake((self.width-buttonWidth)/2, label.bottom+30, buttonWidth, buttonHeight);
        confirmButton.layer.cornerRadius = 4;
        [confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#18a2ff"]];
        
        [confirmButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:confirmButton];
        objc_setAssociatedObject(confirmButton, &confirmButtonKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);

    }
    self.backgroundView = backgroundView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)buttonAction:(UIButton *)sender
{
    void (^actionBlock)(UIButton*) = objc_getAssociatedObject(sender, &confirmButtonKey);
    
    if (actionBlock) {
        actionBlock(sender);
    }
}
- (void)removeListEmptyViewForNeedToChangeSeparator:(BOOL)needToChangeSeparator
{
    self.backgroundView = nil;
    if (needToChangeSeparator){
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}
@end
