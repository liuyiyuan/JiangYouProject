//
//  WMCardiotocographyReportCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCardiotocographyReportCell.h"
#import "WMJSONUtil.h"

@implementation WMCardiotocographyReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(WMReportListModel *)model{
    self.timeLabel.text = model.sendTime;
    self.scoreLabel.text = [NSString stringWithFormat:@"系统评分：%@分",model.score];
    self.nameLabel.text = model.name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@岁 / %@ / %@",model.age,model.expectedDate,model.phone];
    _mdic = [WMJSONUtil JSONObjectWithString:model.scoringDetails];
    
    self.detailLabel.text = [self getStr];
}


- (NSString *)getStr{
    
    
    //        NSLog(@"=-=-=  %@",autoContentDic);
    
    
    _modelScore = [_mdic objectForKey:@"asctype"];
    
    
    
    
    
    _suggestArr = [[NSArray alloc] initWithObjects:@"时间过短或数据异常，无法完成评分。",@"本次监护结果为反应型，监护曲线提示本次监护结果良好（仅供参考）",@"本次监护结果为轻无反应型，可稍后再次进行胎心监测或辅以其他监测，确认胎儿状态（仅供参考）",@"本次监护结果为无反应型，请重视并辅以其他监测，确认胎儿状态（仅供参考）",@"本次监护结果为无反应型，怀疑胎儿窘迫，请反复进行胎心监测，确认胎儿状态，并向医生进行咨询，进行胎监报告解读（仅供参考））",@"危险警告，怀疑胎儿窘迫，请立即向医生进行咨询，进行胎监报告解读（仅供参考）", nil];
    
    
    _scoreStr = [_mdic objectForKey:@"result"];
    _typeArr = [_mdic objectForKey:@"advise"];
    _adviceArr = [_mdic objectForKey:@"type"];
    NSArray * totalArr = [_mdic objectForKey:@"totalscore"];
    NSLog(@"=== %@",totalArr);
    if ([[totalArr objectAtIndex:0] isEqual:[totalArr objectAtIndex:1]]) {
        _totalStr =[totalArr objectAtIndex:0];
    } else {
        _totalStr = [NSString stringWithFormat:@"%@-%@",[totalArr objectAtIndex:0],[totalArr objectAtIndex:1]];
    }
    NSArray * adviceArr = [_mdic objectForKey:@"advise"];
    //            NSString * dangerStr = @"";
    NSString * adviceStr = @"";
    
    NSString *warning =NSLocalizedString(@"报警内容",nil);
    NSArray * typeArr = [_mdic objectForKey:@"type"];
    if (([[totalArr objectAtIndex:0] intValue] + [[totalArr objectAtIndex:1] intValue])/2 < 7) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"低分警告",nil)];
    }
    if ([[typeArr objectAtIndex:0] intValue]>1) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"心率值异常警告",nil)];
    }
    if ([[typeArr objectAtIndex:1] intValue]>2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"变异过小警告",nil)];
    }
    if ([[typeArr objectAtIndex:3] intValue]!=1 && [[typeArr objectAtIndex:3] intValue]!=2 && [[typeArr objectAtIndex:3] intValue]!=8) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"存在减速警告",nil)];
    }
    if ([[typeArr objectAtIndex:4] intValue]==2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"正弦波警告",nil)];
    }
    if ([[typeArr objectAtIndex:5] intValue]==2) {
        warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"STV警告",nil)];
    }
    if ([warning isEqualToString:NSLocalizedString(@"报警内容",nil)]) {
        warning = @"";
    }
    
    NSLog(@"___%@",[adviceArr objectAtIndex:4]);
    
    if ([_modelScore isEqual:[NSNumber numberWithInteger:5]]) {
        adviceStr = [_suggestArr objectAtIndex:[[adviceArr objectAtIndex:2]  intValue]];
    } else {
        adviceStr = [_suggestArr objectAtIndex:[[adviceArr objectAtIndex:1]  intValue]];
    }
    
    NSString *label_text1 = @"";
    if ([[typeArr objectAtIndex:4] intValue]==2) {
        //            warning = [NSString stringWithFormat:@"%@ %@",warning,NSLocalizedString(@"正弦波警告",nil)];
        
        label_text1 =[NSString stringWithFormat:@"%@  %@ %@",NSLocalizedString(@"一切以医生回复为准",nil),warning,NSLocalizedString(@"点击评分详情进行查看具体内容",nil)];
    }else{
        label_text1 =[NSString stringWithFormat:@"%@ %@%@ %@，%@ %@",NSLocalizedString(@"一切以医生回复为准",nil),NSLocalizedString(@"系统评分",nil),_totalStr,NSLocalizedString(@"分",nil),adviceStr,warning];
    }
    
    return label_text1;
}

@end
