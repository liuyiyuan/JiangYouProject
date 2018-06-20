//
//  WMTagGroupSelectCollectionViewCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagGroupSelectCollectionViewCell.h"

@implementation WMTagGroupSelectCollectionViewCell

- (void)setValueForTag:(WMAllTagModel *)model{
    self.tagTextFeild.layer.cornerRadius = 15;
    self.tagTextFeild.layer.borderWidth = 0.5;
    self.tagTextFeild.textAlignment = NSTextAlignmentCenter;
    self.tagTextFeild.text = model.tagName;
    self.tagTextFeild.enabled = NO;
    if ([model.isSelect isEqualToString:@"1"]) {        //选中状态
        self.tagTextFeild.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
        self.tagTextFeild.textColor = [UIColor colorWithHexString:@"18a2ff"];
    }else{
        self.tagTextFeild.layer.borderColor = [UIColor colorWithHexString:@"dbdbdb"].CGColor;
        self.tagTextFeild.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    
}



- (IBAction)touchEnter:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTag: isSelect:)]) {
        [self.delegate selectTag:self.tagTextFeild.text isSelect:self.isSelect];
    }
}

@end
