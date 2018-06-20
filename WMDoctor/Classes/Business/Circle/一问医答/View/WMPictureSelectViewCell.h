//
//  WMPictureSelectViewCell.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/4.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  WMPictureSelectDelegate<NSObject>
@optional//可选的

-(void)removeAction:(UIButton *)button;

@end

@interface WMPictureSelectViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic ,assign)id<WMPictureSelectDelegate>delegate;

@end
