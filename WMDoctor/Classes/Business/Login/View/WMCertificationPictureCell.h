//
//  WMCertificationPictureCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMCertificationPictureCellDelegate <NSObject>

-(void)uploadPictureAction;
-(void)uploadPictureAgainAction;
@end

@interface WMCertificationPictureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *againButton;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic, assign)id<WMCertificationPictureCellDelegate>delegate;
@end
