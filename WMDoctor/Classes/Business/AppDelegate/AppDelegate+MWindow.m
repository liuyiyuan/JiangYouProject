//
//  AppDelegate+MWindow.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/21.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "AppDelegate+MWindow.h"
#import "MWApi.h"

@implementation AppDelegate (MWindow)

-(void)registerMoWindow{
    //注册魔窗
    [MWApi registerApp:@"JU6ULB9EJRN4K4V7ND549JUJ10KXB99M"];
    //没注册的公共方法
    [MWApi registerMLinkDefaultHandler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        NSLog(@"没有注册事件");
    }];
    // https://ailp1h.mlinks.cc/AbYP
    //以后的全部事件
    [MWApi registerMLinkHandlerWithKey:@"CommentRouter" handler:^(NSURL *url, NSDictionary *params) {
        NSDictionary *combinationParams= @{@"keyName":@"CommentRouter",
                                           @"params":params};
        [self jumpTargetPagesWithMLinkWithParams:combinationParams];
        
    }];
    
}
-(void)jumpTargetPagesWithMLinkWithParams:(NSDictionary *)combinationParams{
    //获取事件名称
    NSString *keyName=[combinationParams objectForKey:@"keyName"];
    //获取参数
    NSDictionary *params=[combinationParams objectForKey:@"params"];
    NSString *flag=[params objectForKey:@"flag"];
}



@end
