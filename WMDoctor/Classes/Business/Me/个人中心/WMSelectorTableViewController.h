//
//  WMSelectorTableViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseTableViewController.h"


typedef NS_ENUM(NSUInteger,WMSelectorStyle){
    WMSelectorStyleEducation = 0,
    WMSelectorStyleProvince = 1,
    WMSelectorStyleCity = 2,
    WMSelectorStyleArea = 3,
    WMSelectorStyleTown = 4,
    WMSelectorStyleCountry = 5,
    WMSelectorStyleSchool = 6,
    WMSelectorStylePro = 7,
    WMSelectorStyleTime = 8
};

@interface WMSelectorTableViewController : WMBaseTableViewController
@property (nonatomic,assign) WMSelectorStyle selectSytle;
@property (nonatomic,assign) BOOL isSelectArea;
@property (nonatomic,copy) NSString * educationId;
@property (nonatomic,copy) NSString * schoolGrade;

@end
