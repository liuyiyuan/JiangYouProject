//
//  AppDelegate+GeTui.m
//  Micropulse
//
//  Created by 茭白 on 16/7/26.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "AppDelegate+GeTui.h"
#import "WMTabBarController.h"
#import "WMNavgationController.h"
#import "WMSystemMessageViewController.h"
@implementation AppDelegate (GeTui)


-(void)goListByPushInfo:(NSDictionary *)pushinfoDic state:(NSInteger)state
{
    if (!pushinfoDic) {
        return;
    }
    PushInfoModel *pushInfo = [[PushInfoModel alloc] initWithDictionary:pushinfoDic error:nil];
    
    if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]){
        WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
        WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
        
        switch (pushInfo.NOTIFYTYPE.integerValue) {
            case 116:
            {

                
                //跳转到系统消息
                WMSystemMessageViewController *vc=[[WMSystemMessageViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                NSMutableArray *array= [[NSMutableArray alloc] initWithObjects:@"tIdString", nil];
                vc.systemTargetIdArr= array;
                vc.backTitle=NSLocalizedString(@"kText_wemai_back", nil);
                [navController pushViewController:vc animated:YES];
                break;
            }
             
                //冻结问答订单
            case 156:
            {
                //跳转到系统消息
                WMSystemMessageViewController *vc=[[WMSystemMessageViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                NSMutableArray *array= [[NSMutableArray alloc] initWithObjects:@"tIdString", nil];
                vc.systemTargetIdArr= array;
                vc.backTitle=NSLocalizedString(@"kText_wemai_back", nil);
                [navController pushViewController:vc animated:YES];
                break;
            }
                
                //问答订单退款
            case 157:
            {
                //跳转到系统消息
                WMSystemMessageViewController *vc=[[WMSystemMessageViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                NSMutableArray *array= [[NSMutableArray alloc] initWithObjects:@"tIdString", nil];
                vc.systemTargetIdArr= array;
                vc.backTitle=NSLocalizedString(@"kText_wemai_back", nil);
                [navController pushViewController:vc animated:YES];
                break;
            }
            
            default:
                break;
                
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ///3.2.0版本消息体系 接收到消息时候刷新接口，获取未读数
            NSLog(@"不是个推消息，不被处理");
        });
        
    }
    else {  //广告页和登录页，还有可能是选择城市的页面
        NSLog(@"找不到根视图");
    }
    
}


@end
