//
//  WMHealthRecordView.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMHealthRecordView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
- (id)initWithFrame:(CGRect)frame withDingdanhao:(NSString *)dingdanhao;
@end

