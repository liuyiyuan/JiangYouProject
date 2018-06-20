//
//  WMScoreTaskListCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMScoreTaskModel.h"

@protocol WMScoreTaskCellDelegate <NSObject>

-(void)cellBtnClick:(NSString *)Code;

@end

@interface WMScoreTaskListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskDesc;
@property (weak, nonatomic) IBOutlet UILabel *taskScore;
@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (nonatomic,assign)id<WMScoreTaskCellDelegate>delegate;
@property (nonatomic,strong) WMScoreTaskDetailModel * allModel;

- (void)setCellValue:(WMScoreTaskDetailModel *)model;

@end
