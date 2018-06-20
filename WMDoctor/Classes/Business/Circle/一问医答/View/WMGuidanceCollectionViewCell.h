//
//  WMGuidanceCollectionViewCell.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/1.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMGuidanceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GuidanceImage;
@property (weak, nonatomic) IBOutlet UIView *showView;
-(void)setupView;
@end
