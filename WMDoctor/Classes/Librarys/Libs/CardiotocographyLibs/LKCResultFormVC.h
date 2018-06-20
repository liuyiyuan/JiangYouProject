//
//  LKCResultFormVC.h
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/9.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCResultFormVC : UIViewController
@property (nonatomic , strong) NSNumber * ScoreModel;
@property (nonatomic , strong) NSString * scoreStr;
@property (nonatomic , strong) NSString * totalScore;


@property (nonatomic , strong)  NSArray * typeArr;
@property (nonatomic , strong)  NSArray * adviceArr;

@end
