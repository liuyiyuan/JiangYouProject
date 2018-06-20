//
//  WMTagSelectModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/23.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMTagModel;
@interface WMTagModel :WMJSONModel

@property (nonatomic,copy) NSString * flag;

@property (nonatomic,copy) NSString * tagId;

@property (nonatomic,copy) NSString * tagName;


@end

@protocol WMAllTagModel;
@interface WMAllTagModel :WMJSONModel

@property (nonatomic,copy) NSString * flag;

@property (nonatomic,copy) NSString * tagId;

@property (nonatomic,copy) NSString * tagName;

@property (nonatomic,copy) NSString<Optional> * isSelect;

@end

@interface WMTagSelectModel : WMJSONModel

@property (nonatomic,strong) NSMutableArray<WMPatientTagModel> * allTags;

@property (nonatomic,strong) NSMutableArray<WMPatientTagModel> * patientTags;

@end


@interface WMTagModelCustom : WMJSONModel

@property (nonatomic,strong) NSMutableArray<WMPatientTagModel> * patientTags;

@property (nonatomic,copy) NSString * weimaihao;

@end
