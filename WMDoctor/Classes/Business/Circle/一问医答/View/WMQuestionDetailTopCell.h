//
//  WMQuestionDetailTopCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMQuestionDetailModel.h"
#import "WMNewPictureSelectView.h"

@protocol WMQuestionDetailTopCellDelegate <NSObject>

-(void)cellPreviewPictureWithTag:(NSInteger )tag withShowType:(PictureShowType) showType;

-(void)cellHeightChange:(BOOL)flag;

@end

@interface WMQuestionDetailTopCell : UITableViewCell<WMNewPictureSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QuestionHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *labelHiddeView;
@property (weak, nonatomic) IBOutlet UIImageView *labelHideImage;
@property (nonatomic,assign)id<WMQuestionDetailTopCellDelegate>delegate;

@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) BOOL textHideFlag;

@property (nonatomic,strong) WMNewPictureSelectView * picView;

- (void)setCellValue:(WMQuestionDetailInfoModel *)model andFlag:(BOOL)flag;

@end
