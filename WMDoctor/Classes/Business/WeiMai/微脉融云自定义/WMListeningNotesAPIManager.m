//
//  WMListeningNotesAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/9/30.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMListeningNotesAPIManager.h"

@implementation WMListeningNotesAPIManager

- (NSString *)methodName{
    return @"/doctor_sound/preservation_listen_record";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

- (BOOL)isHideErrorTip{
    return YES;
}

@end
