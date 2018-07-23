//
//  ZCToolsCore.m
//  SobotKit
//
//  Created by zhangxy on 2018/1/29.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import "ZCToolsCore.h"

@implementation ZCToolsCore

static ZCToolsCore *_instance = nil;
static dispatch_once_t onceToken;
+(ZCToolsCore *)getToolsCore{
    dispatch_once(&onceToken, ^{
        if(_instance == nil){
            _instance = [[ZCToolsCore alloc] initPrivate];
        }
    });
    return _instance;
}

-(id)initPrivate{
    self=[super init];
    if(self){
        
    }
    return self;
}

-(id)init{
    return [[self class] getToolsCore];
}



-(void)clear{
    onceToken=0;
    _instance = nil;
    
}

@end
