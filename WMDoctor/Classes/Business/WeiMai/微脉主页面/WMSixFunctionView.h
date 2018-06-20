//
//  WMSixFunctionView.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMIndexDataModel.h"

@protocol WMSixFunctionViewDelegate <NSObject>

@required

- (void)clickSixEntran:(WMFunctionEntries *)model;

@end

@interface WMSixFunctionView : UIView

@property (nonatomic, weak) id<WMSixFunctionViewDelegate> delegate;

- (void)sixViewMakeViewWithArray:(NSArray *)modelArray;

@end
