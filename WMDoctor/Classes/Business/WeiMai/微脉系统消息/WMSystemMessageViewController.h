//
//  WMSystemMessageViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"

typedef NS_ENUM(NSInteger, WMMessageType)
{
    WMMessageTypeNotification        = 1002,//通知消息
    WMMessageTypeTradeMessage        = 1003,//交易消息
    WMMessageTypeRecommend           = 1005,//推荐资讯
    WMMessageTypeInformation         = 1006,//资讯消息
    
};
@interface WMSystemMessageViewController : WMBaseViewController
@property (nonatomic ,strong)NSMutableArray *systemTargetIdArr;
@end
