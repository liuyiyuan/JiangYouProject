//
//  WMMyServiceSetViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMMyServiceSetViewController : WMBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString * inquiryType;

@end
