//
//  ACOGModel.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGModel.h"

@implementation ACOGModel
- (instancetype)initWithPicInfoDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.boldTitle = dic[@"title"];
        self.topMark = dic[@"topMark"];
        self.topTitle = dic[@"topTitle"];
        self.midMark = dic[@"midMark"];
        self.midTitle = dic[@"midTitle"];

        self.btmTitle = dic[@"btmTitle"];
        self.btmMark = dic[@"btmMark"];
        
    }
    return self;
}

@end
