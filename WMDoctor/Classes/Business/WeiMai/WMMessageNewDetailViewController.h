//
//  WMMessageNewDetailViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseWKWebController.h"

@interface WMMessageNewDetailViewController : WMBaseWKWebController
@property(nonatomic ,strong)NSString *shareTitle;
@property(nonatomic ,strong)NSString *shareDetail;
@property(nonatomic ,strong)NSString *shareUrl;
@property(nonatomic ,strong)NSString *sharePictureUrl;
@property(nonatomic, strong)NSString *hiddenRightBarBtn;

@end
