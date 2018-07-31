//
//  WMNewHotQuestionCell.h
//  Micropulse
//
//  Created by 王攀登 on 2018/3/22.
//  Copyright © 2018年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMNewHotQuestionModel.h"

@interface WMNewHotQuestionCell : UICollectionViewCell

/** 今日热门的轮播
 *  判断是否是热门咨询
 *  yes一问医答     no热门咨询
 */
@property (nonatomic, assign) BOOL isHotQa;

@property (nonatomic, strong) WMNewHotQuestionModel *model;
// 问答
- (void)configHotQaNum:(NSString *)qaNum content:(NSString *)content;
// 热门咨询
- (void)configHotTopContent:(NSString *)topContent bottomContent:(NSString *)bottomContent;

@end
