//
//  WMCardiotocographyReportCell.h
//  WMDoctor
//  胎心监护报告列表Cell
//  Created by JacksonMichael on 2017/7/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMReportListModel.h"

@interface WMCardiotocographyReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;    //时间
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;   //分数
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //姓名
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;    //信息
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;  //详细

//设置Cell值
- (void)setCellValue:(WMReportListModel *)model;

@property (nonatomic , strong)  NSString * totalStr;
@property (nonatomic , strong)  NSString * scoreStr;
@property (nonatomic , strong)  NSString * modelScore;
@property (nonatomic , strong)  NSArray * suggestArr;

@property (nonatomic , strong)  NSArray * typeArr;
@property (nonatomic , strong)  NSArray * adviceArr;

@property (nonatomic,strong) NSMutableDictionary * mdic;

@end
