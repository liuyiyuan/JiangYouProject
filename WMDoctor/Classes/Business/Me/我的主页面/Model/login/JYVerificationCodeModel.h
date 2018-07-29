//
//  JYVerificationCodeModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYVerificationCodeModel : WMJSONModel

//base64位图片码
@property(nonatomic, strong)NSString *validCodeImg;

@end
