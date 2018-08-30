//
//  JYHomeSameCItyHeaderView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SameCItyHeaderViewDelegate <NSObject>

- (void)clickSameCItyHeaderViewIndex:(NSIndexPath *)indexPath;

@end

@interface JYHomeSameCItyHeaderView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *goodWorkImageView;//支撑风向标，海量好工作

@property (nonatomic, strong) UIImageView *secondhandImageImage;//二手手机

@property (nonatomic, strong) UIImageView *strategyImage;//职场攻略

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIView *blueView;

@property (nonatomic, strong) UILabel *hotLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, weak  ) id<SameCItyHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSArray *fastListArray;

@property (nonatomic, strong) NSArray *photoNavListArray;//三图数组

@end
