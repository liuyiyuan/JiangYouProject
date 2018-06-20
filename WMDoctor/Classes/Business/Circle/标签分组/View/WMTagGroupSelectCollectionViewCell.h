//
//  WMTagGroupSelectCollectionViewCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTagSelectModel.h"

@protocol WMTagGroupSelectCollectionViewCellDelegate <NSObject>
@optional
- (void)selectTag:(NSString *)text isSelect:(BOOL)isSelect;

@end

@interface WMTagGroupSelectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *tagTextFeild;

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,assign)id<WMTagGroupSelectCollectionViewCellDelegate>delegate;

- (void)setValueForTag:(WMAllTagModel *)model;

@end
