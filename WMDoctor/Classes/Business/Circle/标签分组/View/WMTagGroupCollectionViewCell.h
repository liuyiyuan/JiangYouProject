//
//  WMTagGroupCollectionViewCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTagSelectModel.h"

@protocol WMTagGroupCollectionViewCellDelegate <NSObject>

- (void)EnterText:(WMTagModel *)text;
- (void)textFieldDidChange:(NSString *)text;



@end

@interface WMTagGroupCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tagTextFeild;

@property (nonatomic,assign)id<WMTagGroupCollectionViewCellDelegate>delegate;

- (void)setValueForTag:(WMPatientTagModel *)model;

- (void)setValueForText;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
