//
//  WMInformationModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMInformationModel.h"
static WMInformationModel * informationModel;

@implementation WMInformationModel
+(WMInformationModel *)shareInformationModel
{
    if (!informationModel)
    {
        informationModel=[[WMInformationModel alloc] init];
        
    }
    return informationModel;
}


@end
