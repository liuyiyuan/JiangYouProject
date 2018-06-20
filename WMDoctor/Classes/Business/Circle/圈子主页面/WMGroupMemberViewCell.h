//
//  WMGroupMemberViewCell.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/20.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WMGroupJSONModel.h"

@interface WMGroupMemberViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userTypeImageView;
-(void)setupViewWithModel:(WMOneMemberModel *)model;
@end
