//
//  ACOGCollectionViewCell.h
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/21.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACOGCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) UIButton * markBtn;
@property (nonatomic , strong) UILabel  * tipLable;


-(void)setMarkbtnWithSelectedState:(BOOL)seleected;

@end