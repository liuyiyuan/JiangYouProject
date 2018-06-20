//
//  WMNotificationMessageViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMNotificationMessageViewController : WMBaseViewController
typedef NS_ENUM(NSInteger, WMMessageNotificationType)
{
    ReportCardNotificationType                 = 2001,//报告单提醒
    BookingSuccessfulNotificationType          = 3001,//预约成功
    BookingFailureNotificationType             = 3002,//预约失败
    
    
       
};

@end
