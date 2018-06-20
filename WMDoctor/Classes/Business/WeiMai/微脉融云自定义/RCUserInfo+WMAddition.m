//
//  RCUserInfo+WMAddition.m
//  Micropulse
//
//  Created by 茭白 on 16/8/29.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "RCUserInfo+WMAddition.h"
#import <objc/runtime.h>

@implementation RCUserInfo (WMAddition)
@dynamic sex;
@dynamic userId;
@dynamic type;

- (instancetype)initWithUserId:(NSString *)userId portrait:(NSString *)portrait sex:(NSString *)sex type:(NSString *)type{
    if (self = [super init]) {
        self.userId        =   userId;
        self.portraitUri   =   portrait;
        self.sex   =   sex;
        self.type = type;
        
    }
    return self;
}

//添加属性扩展set方法
static char* const SEX = "sex";
static char* const TYPE = "type";
static char* const VIP = "vip";
static char* const TAGNAMES = "tagNames";



-(void)setSex:(NSString *)newSex{
    
    objc_setAssociatedObject(self,SEX,newSex,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)setType:(NSString *)newType{
    objc_setAssociatedObject(self,TYPE,newType,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setVip:(NSString *)newVip{
    objc_setAssociatedObject(self,VIP,newVip,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTagNames:(NSArray *)newTagNames{
    objc_setAssociatedObject(self, TAGNAMES, newTagNames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSString *)sex{
    return objc_getAssociatedObject(self,SEX);
}

- (NSString *)type{
    return objc_getAssociatedObject(self,TYPE);
}

- (NSString *)vip{
    return objc_getAssociatedObject(self, VIP);
}

- (NSArray *)tagNames{
    return objc_getAssociatedObject(self, TAGNAMES);
}

@end
