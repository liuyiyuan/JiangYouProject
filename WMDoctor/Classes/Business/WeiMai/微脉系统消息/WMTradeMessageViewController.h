//
//  WMTradeMessageViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
typedef NS_ENUM(NSInteger,WMTradeMessageNotificationType)
{
    PaymentSuccessfulNotificationType               = 5002,//就诊卡充值成功
    PaymentFailureNotificationType                  = 5003,//就诊卡充值失败
    
        
};

@interface WMTradeMessageViewController : WMBaseViewController

@end
