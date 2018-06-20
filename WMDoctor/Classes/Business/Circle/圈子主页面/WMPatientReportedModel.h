//
//  WMPatientReportedModel.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMPatientTagModel;
@interface WMPatientTagModel : WMJSONModel

@property (nonatomic, strong) NSString *flag;
//
@property (nonatomic, strong) NSString *tagId;
//标签名字
@property (nonatomic, strong) NSString *tagName;

@property (nonatomic, strong) NSString *isSelect;

@end

@protocol WMPatientReportedModel;
@interface WMPatientReportedModel : WMJSONModel
@property (nonatomic,copy)NSString *focusTime;//时间
@property (nonatomic,copy)NSString *freshMark;//新人标志
@property (nonatomic,copy)NSString *headPicture;//头像
@property (nonatomic,copy)NSString *name;//名字
@property (nonatomic,copy)NSString *phone;//手机号
@property (nonatomic,copy)NSString *weimaihao;//微脉号
@property (nonatomic,strong)NSNumber *sex;//性别
@property (nonatomic,copy)NSString *acceptMark;//医生接受标志   1: 接受 0:不接受'
@property (nonatomic,copy)NSString *sackName;//疾病名称
@property (nonatomic,copy)NSString *visitDate;//就诊时间
@property (nonatomic,strong)NSNumber *liushuihao;//流水号
@property (nonatomic,strong)NSString *age;//年龄
@property (nonatomic,strong)NSArray<WMPatientTagModel> *tagGroups;//标签分组

@end

@interface WMPatientReportedDataModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMPatientReportedModel> *list;
@property (nonatomic ,strong) NSNumber *totalPage;
@property (nonatomic ,strong) NSNumber *currentPage;

@end



@protocol WMPatientHealthModel;
@interface WMPatientHealthModel : WMJSONModel

//健康档案地址
@property (nonatomic ,strong) NSString *jiuzhenmxlb;
//就诊时间
@property (nonatomic ,strong) NSString *jiuzhensj;
//科室名称
@property (nonatomic ,strong) NSString *keshimc;
//医院名称
@property (nonatomic ,strong) NSString *yiyuanmc;
//诊断名称
@property (nonatomic ,strong) NSString *zhenduanmc;

@end


@interface WMPatientDataModel : WMJSONModel
//年龄
@property (nonatomic ,strong) NSString *age;
//性别
@property (nonatomic ,strong) NSString *sex;
//头像
@property (nonatomic ,strong) NSString *url;
//姓名
@property (nonatomic ,strong) NSString *xingming;

//备注
@property (nonatomic,copy) NSString<Optional> * remark;

//标签
@property (nonatomic, strong) NSMutableArray<WMPatientTagModel> *tags;

@property (nonatomic ,strong) NSArray<WMPatientHealthModel> *health;

@end

@protocol WMOneMemberModel;
@interface WMOneMemberModel : WMJSONModel
//头像
@property (nonatomic ,strong) NSString *pictureUrl;
//姓名
@property (nonatomic ,strong) NSString *userName;
//用户类型： 1:群主 2:助手 3:患者 只有患者才能点击进入患者资料
@property (nonatomic ,strong) NSString *userType;
//微脉号
@property (nonatomic ,strong) NSString *weimaihao;
//用户id
@property (nonatomic ,strong) NSString *rongcloudId;

@end


@interface WMGroupMemberModel : WMJSONModel

//微脉号
@property (nonatomic, strong) NSArray<WMOneMemberModel> *result;
@property (nonatomic, strong) NSString *currentUserType;

@end



@protocol WMPatientModel;
@interface WMPatientModel : WMJSONModel
//标签
@property (nonatomic, strong) NSArray<WMPatientTagModel> *tagGroups;
//增加时间
@property (nonatomic, strong) NSString *addTime;
//年龄
@property (nonatomic, strong) NSString *age;
//头像
@property (nonatomic, strong) NSString *avator;
//名字
@property (nonatomic, strong) NSString *name;
//性别
@property (nonatomic, strong) NSString *sex;
//微脉号
@property (nonatomic, strong) NSString *weimaihao;
@end

@interface WMTagGroupModel : WMJSONModel

//
@property (nonatomic, strong) NSArray<WMPatientModel> *patients;
//是否有下一页
@property (nonatomic, assign) BOOL isMore;


@end




