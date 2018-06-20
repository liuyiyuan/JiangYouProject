//
//  WMShowImageCollectionViewCell.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SingTapActionDelegate<NSObject>
@optional//可选的

-(void)SingTapAction;

@end
@interface WMShowImageCollectionViewCell : UICollectionViewCell

-(void)setupView:(NSString *)urlStr;
-(void)setupImageView:(UIImage *)image;
@property (nonatomic,assign)id<SingTapActionDelegate>delegate;


@end
