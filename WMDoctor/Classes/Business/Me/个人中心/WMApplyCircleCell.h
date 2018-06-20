//
//  WMApplyCircleCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMApplyCircelCellDelegate <NSObject>

-(void)goCircle;

@end

@interface WMApplyCircleCell : UITableViewCell

@property (nonatomic,assign)id<WMApplyCircelCellDelegate>delegate;

@end
