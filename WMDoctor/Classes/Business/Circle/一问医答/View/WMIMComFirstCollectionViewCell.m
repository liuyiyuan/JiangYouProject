//
//  WMIMComFirstCollectionViewCell.m
//  Micropulse
//
//  Created by 茭白 on 2017/3/3.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMIMComFirstCollectionViewCell.h"

@implementation WMIMComFirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
    // Initialization code
}

-(void)setupView{
    
    self.detailLable.text=@"请上传病历、处方、化验单、检查单等\n最多添加5张图片";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = CGRectMake(0, 0, self.showView.frame.size.width, (kScreen_width/3-0.2)*1/1.5*2-25);
        //    borderLayer.position = CGPointMake(self.showView.centerX, self.showView.centerY);
        
        borderLayer.path = [UIBezierPath bezierPathWithRect:self.showView.frame].CGPath;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.frame cornerRadius:4].CGPath;
        
        
        borderLayer.lineWidth = 2;
        //虚线边框
        borderLayer.lineDashPattern = @[@12, @6];
        //实线边框
        //    borderLayer.lineDashPattern = nil;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        [self.showView.layer addSublayer:borderLayer];
        
    });
    
    
    
}
@end
