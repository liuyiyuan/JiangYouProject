//
//  WMRCConversationHeaderView.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMRCChatHeaderViewDelegate <NSObject>
//点击健康档案
-(void)healthRecordAction:(UIButton *)button;

-(void)chatAction:(UIButton *)button;

@end

@interface WMRCConversationHeaderView : UIView


- (id)initWithFrame:(CGRect)frame;

@property (nonatomic,strong)UIButton *healthRecordBtn;
@property (nonatomic,strong)UIButton *chatBtn;
@property (nonatomic,strong)UILabel *redLabel;
@property (nonatomic,assign)id<WMRCChatHeaderViewDelegate>delegate;
@end
