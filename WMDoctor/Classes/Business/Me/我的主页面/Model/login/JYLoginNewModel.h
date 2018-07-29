//
//  JYLoginNewModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/26.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYLoginNewModel : WMJSONModel

//用户id
@property(nonatomic, strong)NSString *userId;
//手机号
@property(nonatomic, strong)NSString *tel;
//绑定微信
@property(nonatomic, strong)NSString *weiXin;
//绑定QQ
@property(nonatomic, strong)NSString *qq;
//是否是新用户 1是新用户 0不是新用户
@property(nonatomic, strong)NSString *isNewUser;
//昵称
@property(nonatomic, strong)NSString *nickName;
//头像地址
@property(nonatomic, strong)NSString *userPhoto;
//性别 true男 false女
@property(nonatomic, strong)NSString *sex;
//简介
@property(nonatomic, strong)NSString *introduce;
//真实姓名
@property(nonatomic, strong)NSString *realName;
//身份证号
@property(nonatomic, strong)NSString *card;
//从事行业id
@property(nonatomic, strong)NSString *workId;
//从事行业名称
@property(nonatomic, strong)NSString *workName;
//年收入id
@property(nonatomic, strong)NSString *annualIncomeId;

@end
