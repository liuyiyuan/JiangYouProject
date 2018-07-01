//
//  JYInformationButtonArrayView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JYInformationButtonArrayViewDelegate <NSObject>

- (void)btnSelectedWithView:(UIView *)view tag:(long)tag;

@end

@interface JYInformationButtonArrayView : UIView

@property(nonatomic,strong)UIButton *selectedButton;

@property(nonatomic,strong)NSArray *buttonTitlearray;//按钮标题数组

@property (nonatomic, weak) id<JYInformationButtonArrayViewDelegate> delegate;

- (void)configUI;

@end
