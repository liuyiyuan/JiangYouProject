//
//  JYStoresActivitesCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoresActivitesCell.h"
#import "JYStoreActiveCarefullyChooseModel.h"
#import "UIImage+Generate.h"

@implementation JYStoresActivitesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithActives:(NSArray *)actives{
    JYStoreActiveCarefullyChooseModel *activeOne = actives[0];
    UIImage *imageOne = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activeOne.pic]]];
    [self.activeImageViewOne setImage:imageOne forState:UIControlStateNormal];
    [self.activeImageViewOne addTarget:self action:@selector(activeBtnOneClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    JYStoreActiveCarefullyChooseModel *activeTwo = actives[1];
    UIImage *imageTwo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activeTwo.pic]]];
    [self.activeImageViewTwo setImage:imageTwo forState:UIControlStateNormal];
    [self.activeImageViewTwo addTarget:self action:@selector(activeBtnTwoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    JYStoreActiveCarefullyChooseModel *activeThree = actives[2];
    UIImage *imageThree = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activeThree.pic]]];
    [self.activeImageViewThree setImage:imageThree forState:UIControlStateNormal];
    [self.activeImageViewThree addTarget:self action:@selector(activeBtnThreeClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)activeBtnOneClickAction:(UIButton *)button{
    NSLog(@"btn one");
}

- (void)activeBtnTwoClickAction:(UIButton *)button{
    NSLog(@"btn two");
}

- (void)activeBtnThreeClickAction:(UIButton *)button{
    NSLog(@"btn three");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
