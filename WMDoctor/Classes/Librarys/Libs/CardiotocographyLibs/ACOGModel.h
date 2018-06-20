//
//  ACOGModel.h
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACOGModel : NSObject

@property (nonatomic, copy) NSString * boldTitle;
@property (nonatomic, copy) NSString *topMark;
@property (nonatomic, copy) NSString *topTitle;
@property (nonatomic, copy) NSString *midMark;
@property (nonatomic, copy) NSString *midTitle;

@property (nonatomic, copy) NSString *btmTitle;
@property (nonatomic, copy) NSString *btmMark;


- (instancetype)initWithPicInfoDictionary:(NSDictionary *)dic;

@end
