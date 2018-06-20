//
//  WMSearchPatientCell.m
//  WMDoctor
//
//  Created by xugq on 2018/5/11.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMSearchPatientCell.h"
#import "NSString+Additions.h"

@implementation WMSearchPatientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//搜索列表根据患者赋值
- (void)searchPaitentVCSetValueWithWMPatientModel:(WMPatientModel *)patient andSearchKeyWord:(NSString *)keyword{
    self.orderTag.hidden = YES;
    [self setHeadImageWithUrlStr:patient.avator andSex:patient.sex];
    self.sex.text = [NSString stringWithFormat:@"%@  %@岁", patient.sex, patient.age];
    self.time.text = patient.addTime;
    self.name.attributedText = [self getAttributedStrWithString:patient.name andKeyword:keyword];
    NSString *tagStr = [self getTagStrWithTagGroups:patient.tagGroups];
    self.illness.attributedText = [self getAttributedStrWithString:tagStr andKeyword:keyword];
    self.illness.lineBreakMode = NSLineBreakByTruncatingTail;
}

//标签分组患者列表添加数据
- (void)tagPatientVCSetValueWithWMPatientModel:(WMPatientModel *)patient{
    self.orderTag.hidden = YES;
    [self setHeadImageWithUrlStr:patient.avator andSex:patient.sex];
    self.name.text = patient.name;
    self.sex.text = [NSString stringWithFormat:@"%@  %@岁", patient.sex, patient.age];
    self.illness.text = [self getTagStrWithTagGroups:patient.tagGroups];
    self.time.text = patient.addTime;
    self.timeToTop.constant = 6;
}

//所有患者列表添加数据
- (void)allPatientVCSetValueWithWMTotalPatientsModel:(WMTotalPatientsModel *)patient{
    [self setHeadImageAndSexWithUrlStr:patient.headPicture andSex:patient.sex];
    self.name.text = patient.name;
    [self setSexAndAgeWithSex:patient.sex andAge:patient.age];
    self.illness.text = [self getTagStrWithTagGroups:patient.tagGroups];
    self.orderTag.hidden = NO;
    if (stringIsEmpty(patient.vipTagName)) {
        self.timeToTop.constant = 6;
        self.orderTag.hidden = YES;
    } else{
        [self setOrderTagWithOrderTag:patient.vipTagName];
    }
    self.time.text = patient.focusTime;
}

//VIP患者列表添加数据
- (void)vipPatientVCSetValueWithWMVPIPatientsDetailModel:(WMVPIPatientsDetailModel *)patient{
    [self setHeadImageAndSexWithUrlStr:patient.avator andSex:patient.sex];
    self.name.text = patient.name;
    [self setSexAndAgeWithSex:patient.sex andAge:patient.age];
    self.illness.text = [self getTagStrWithTagGroups:patient.tagGroups];
    [self setOrderTagWithOrderTag:patient.tag];
    self.time.text = patient.visitDate;
    self.timeToTop.constant = 6;
}

//患者报道列表加数据
- (void)patientReportedVCSetValueWithWMPatientReportedModel:(WMPatientReportedModel *)patient{
    self.orderTag.hidden = YES;
    [self setHeadImageAndSexWithUrlStr:patient.headPicture andSex:patient.sex];
    self.name.text = patient.name;
    [self setSexAndAgeWithSex:patient.sex andAge:patient.age];
    self.illness.text = [self getTagStrWithTagGroups:patient.tagGroups];
    self.time.text = patient.focusTime;
    self.timeToTop.constant = 6;
}

//根据性别和年龄设置赋值性别和年龄
- (void)setSexAndAgeWithSex:(NSNumber *)sex andAge:(NSString *)age{
    NSString *sexStr = @"";
    if ([sex intValue] == 1) {
        sexStr = @"男";
    } else if ([sex intValue] == 2){
        sexStr = @"女";
    }
    self.sex.text = [NSString stringWithFormat:@"%@  %@岁", sexStr, age];
}

//根据性别和头像链接设置头像
- (void)setHeadImageAndSexWithUrlStr:(NSString *)urlStr andSex:(NSNumber *)sex{
    if (stringIsEmpty(urlStr)) {
        if ([sex intValue]==1) {
            //男
            self.headImg.image=[UIImage imageNamed:@"ic_head_male"];
        }else if ([sex intValue]==2){
            //女
            self.headImg.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
            self.headImg.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }else{
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
}

////根据性别和头像链接设置头像 注意：入参sex v1.7后改成string类型 服务端转好传过来
- (void)setHeadImageWithUrlStr:(NSString *)urlStr andSex:(NSString *)sex{
    if (stringIsEmpty(urlStr)) {
        if ([sex isEqualToString:@"男"]) {
            //男
            self.headImg.image=[UIImage imageNamed:@"ic_head_male"];
        }else if ([sex isEqualToString:@"女"]){
            //女
            self.headImg.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
            self.headImg.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }else{
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
}

//从标签数据中取出所有标签拼成字符串
- (NSString *)getTagStrWithTagGroups:(NSArray *)tagGroup{
    NSString *tagStr = @"";
    for (WMPatientTagModel *objTag in tagGroup) {
        NSLog(@"tag name : %@", objTag.tagName);
        tagStr = [tagStr stringByAppendingString:objTag.tagName];
        tagStr = [tagStr stringByAppendingString:@","];
    }
    if (tagStr.length > 1) {
        tagStr = [tagStr substringToIndex:tagStr.length - 1];
    }
    return tagStr;
}

//针对VIP患者显示订单生成的标签及时间控件上移
- (void)setOrderTagWithOrderTag:(NSString *)tag{
    self.orderTag.text = [NSString stringWithFormat:@"%@    ", tag];
    self.orderTag.textAlignment = NSTextAlignmentCenter;
    [self.orderTag sizeToFit];
    self.orderTag.layer.masksToBounds = YES;
    self.orderTag.layer.cornerRadius = 9;
    self.timeToTop.constant = 6;
    self.tagToTop.constant = 32;
    self.time.textAlignment = NSTextAlignmentRight;
}

//将字符串中所有关键更改颜色 并以富文本的形式返回
- (NSAttributedString *)getAttributedStrWithString:(NSString *)text andKeyword:(NSString *)keyword{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    NSMutableArray *locations = [NSString getRangesWithSourceStr:text andKeyword:keyword];
    for (NSNumber *location in locations) {
        NSRange range = NSMakeRange([location integerValue], keyword.length);
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"18A2FF"] range:range];
    }
    return attrStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
