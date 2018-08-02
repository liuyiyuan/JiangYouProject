//
//  WMNewHotQuestionView.h
//  Micropulse
//
//  Created by 王攀登 on 2018/3/22.
//  Copyright © 2018年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMNewHotQuestionModel.h"

/**
 *  4.8.6 新版 轮播图
 *  热门问答/一问一答
 */

@protocol WMNewHotQuestionDelegate <NSObject>

- (void)wmNewHotQuestionViewClickWithModel:(WMNewHotQuestionModel *)model;

@end

@interface WMNewHotQuestionView : UIView

- (void)configHotIcon:(NSString *)iconUrl qaNum:(NSString *)qaNum hotArray:(NSMutableArray *)hotArray;
@property (nonatomic, weak) id <WMNewHotQuestionDelegate> delegate;

@end
