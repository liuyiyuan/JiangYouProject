//
//  AppDelegate+Business.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "AppDelegate+Business.h"
#import "WMLaunchImageAPIManager.h"
#import "WMAdvertModel.h"
#import "WMVersionUpgradeAPIManager.h"
#import "WMUpgradecheckModel.h"
#import "WMDevice.h"

//3*60
static NSTimeInterval const kSpaceInterval = 3*24*60*60;

@implementation AppDelegate (Business)

- (void)loadBusinessNetwork{
//    [self loadLaunchImage];
//    [self syncLoadUpgradeCheck:nil];
}

- (void)loadLaunchImage{
    
    WMLaunchImageAPIManager * manger = [[WMLaunchImageAPIManager alloc]init];
    [manger loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject=%@,messge=%@",responseObject,manger.result.message);
        WMAdvertModel * adModel = (WMAdvertModel *)responseObject;
        
        NSLog(@"ads:%@",adModel.ads);
        
        if (adModel.ads.count!=0) {
            [[NSUserDefaults standardUserDefaults] setObject:[adModel.ads firstObject]  forKey:kUser_LaunchImage];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUser_LaunchImage];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUser_LaunchImage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];

}
- (void)syncLoadUpgradeCheck:(void (^)(WMUpgradecheckModel* parameter)) handler

{
    WMShareData *shareData = [WMShareData shareInstance];
    if (shareData.upgradeModel) {
        if (handler) {
            handler(shareData.upgradeModel);
        }
    }else{
        
        WMVersionUpgradeAPIManager * manager = [[WMVersionUpgradeAPIManager alloc] init];
        [manager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            WMUpgradecheckModel * model = responseObject;
            [WMShareData shareInstance].upgradeModel = model;
            //NSLog(@"升级接口=%@",model);
            if (handler) {
                handler(model);
            }
            [self checkVerionAndUpdateWith:model];
            
        } withFailure:^(ResponseResult *errorResult) {
            //NSLog(@"升级错误=%@",errorResult);
        }];
    }
}
- (void)checkVerionAndUpdateWith:(WMUpgradecheckModel *)model
{
    if (!model) {
        return;
    }
    NSString * currentVersion = [[WMDevice currentDevice] appVersion];    
    //强制更新
    if ([currentVersion compare:model.minVersion options:NSNumericSearch]==NSOrderedAscending) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"新版本 " stringByAppendingString:model.currVersion]
                                                        message:NSLocalizedString(@"kText_upgradecheck_forcecontent", nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"立即更新", nil];
        alert.tag = 10001;
        [alert show];
                
    }else if ([currentVersion compare:model.currVersion options:NSNumericSearch]==NSOrderedAscending) {
        
        NSTimeInterval oldTimeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:kUPGRADETIMESTAMPKEY];
        NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
        if (newTimeInterval-oldTimeInterval>kSpaceInterval) {
            NSLog(@"upgradeInfo=%@",model.upgradeInfo);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"新版本 " stringByAppendingString:model.currVersion]
                                                            message:model.upgradeInfo
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"下次提醒",@"立即更新", nil];
            alert.tag = 10000;
            [alert show];
        }
    }
}
- (void)applicationWillEnterForegroundBusiness
{
    WMUpgradecheckModel * model = [WMShareData shareInstance].upgradeModel;
    
    NSString * currentVersion = [[WMDevice currentDevice] appVersion];
    
    if (model&&[currentVersion compare:model.minVersion options:NSNumericSearch]==NSOrderedAscending) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"新版本 " stringByAppendingString:model.currVersion]
                                                        message:NSLocalizedString(@"kText_upgradecheck_forcecontent", nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"立即更新", nil];
        alert.tag = 10001;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //强制更新
    if (alertView.tag==10001)
    {
        //跳转到App Store
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
        
    }else if (alertView.tag==10000)
    {
        if (buttonIndex==0) {
            
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            [[NSUserDefaults standardUserDefaults] setDouble:timestamp forKey:kUPGRADETIMESTAMPKEY];
        }else{
            
            //跳转到App Store
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
        }
    }
}
@end
