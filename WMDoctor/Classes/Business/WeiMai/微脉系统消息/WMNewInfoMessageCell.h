//
//  WMNewInfoMessageCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMessageListModel.h"
@interface WMNewInfoMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
-(void)setupViewWithModel:(WMMessageListDetailModel *)messageDetailModel;
@end
