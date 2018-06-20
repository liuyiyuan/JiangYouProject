//
//  WMCricleGroupModel.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"
/**
 * 圈子的出参 （不带Param代表出参）
 */
@protocol WMCricleGroupModel;

@interface WMCricleGroupModel : WMPageCustomModel

@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,copy) NSString * groupPicture;
@property (nonatomic,copy) NSString<Optional> * groupId;
@property (nonatomic,copy) NSString<Optional> * groupType;
@property (nonatomic,copy) NSString<Optional> * number;
@property (nonatomic,copy) NSString<Optional> * rankVaue;

@end

@interface WMCricleMainModel : WMPageCustomModel
@property (nonatomic ,strong)NSArray<WMCricleGroupModel> *list;
@end

//医患圈 圈子主页
@interface WMCricleHomePageModel : WMPageCustomModel
//群组
@property (nonatomic ,strong)NSArray<WMCricleGroupModel> *groups;
//
@property (nonatomic ,strong)NSArray<WMCricleGroupModel> *patiens;
//标签分组
@property (nonatomic, strong)NSArray<WMCricleGroupModel> *tagGroups;


@end

@interface WMMedicalCircleModel : WMPageCustomModel
//群组
@property (nonatomic ,strong)NSArray<WMCricleGroupModel> *groups;

@end


