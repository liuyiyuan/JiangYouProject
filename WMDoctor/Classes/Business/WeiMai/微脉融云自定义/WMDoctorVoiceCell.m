//
//  WMDoctorVoiceCell.m
//  WMDoctor
//
//  Created by xugq on 2017/9/29.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorVoiceCell.h"

@implementation WMDoctorVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupValueWithModel:(WMDoctorVoiceModel *)doctorVoice{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:doctorVoice.doctorImage] placeholderImage:[UIImage imageNamed:@"doctor_man"] options:SDWebImageAllowInvalidSSLCertificates];
    self.name.text = [NSString stringWithFormat:@"%@", doctorVoice.doctorName];
    self.publishedTime.text = doctorVoice.releaseTime;
    self.desc.text = doctorVoice.title;
    CGFloat height =[self heightForLabelWithText:doctorVoice.title width:kScreen_width-30 font:[UIFont systemFontOfSize:16.0]];
    
    if (height>22) {
        self.descHeightLayout.constant=44;
    }
    else{
         self.descHeightLayout.constant=22;
    }
    self.voiceInLength.text = [self setVoiceINlengths:doctorVoice.timeLength];
    self.audience.text = [NSString stringWithFormat:@"%@人已收听", doctorVoice.listenedNum];
    
}
- (CGFloat)heightForLabelWithText:(NSString *)content width:(CGFloat)width font:(UIFont *)font{
    NSDictionary * attributes =  @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};//字体
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    return height;
}
- (NSString *)setVoiceINlengths:(NSString *)voiceLength{
    int voiceInLength = [voiceLength intValue];
    int m = voiceInLength / 60;
    int s = voiceInLength % 60;
    if (s < 10) {
        return [NSString stringWithFormat:@"%d:0%d", m, s];
    }
    return [NSString stringWithFormat:@"%d:%d", m, s];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
