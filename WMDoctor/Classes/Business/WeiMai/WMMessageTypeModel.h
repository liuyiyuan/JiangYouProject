//
//  WMMessageTypeModel.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMMessageDetailModel;

@interface WMMessageDetailModel : WMJSONModel

@property (nonatomic ,copy)NSString *messageDate;///<时间*>
@property (nonatomic ,copy)NSString *name;///<消息名称>
@property (nonatomic ,strong)NSNumber *noread;///<未读数>
@property (nonatomic ,copy)NSString *summary;///<消息详情>
@property (nonatomic ,copy)NSString *type;///<消息类型>

@end

@interface WMMessageTypeModel : WMJSONModel
@property (nonatomic ,strong)NSArray <WMMessageDetailModel> *messageType;
@end

