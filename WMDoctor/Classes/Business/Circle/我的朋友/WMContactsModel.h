//
//  WMContactsModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMContactsModel : WMJSONModel

@property (nonatomic,copy) NSString * contactName;

@property (nonatomic,copy) NSString * contactNumber;

@property (nonatomic,strong) UIImageView<Optional> * contactImage;

@end
