//
//  JYSCCHeadlineCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSCCHeadlineModel.h"
#import "JYNewestStoreModel.h"

@interface JYSCCHeadlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *headlineImageView;


/**
 商城-精选“今日头条”设置数据

 @param headlineModel <#headlineModel description#>
 */
- (void)setValueWithJYSCCHeadlineModel:(JYSCCHeadlineModel *)headlineModel;


/**
 商城-福利“最新入住”设置数据

 @param newestStoreModel <#newestStoreModel description#>
 */
- (void)setValueWithNewestStoreModel:(JYNewestStoreModel *)newestStoreModel;

@end
