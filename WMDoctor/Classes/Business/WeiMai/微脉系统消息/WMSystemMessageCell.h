//
//  WMSystemMessageCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMessageTypeModel.h"
@interface WMSystemMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabe;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
-(void)setupViewWithModel:(WMMessageDetailModel *)messageDetailModel;
@end
