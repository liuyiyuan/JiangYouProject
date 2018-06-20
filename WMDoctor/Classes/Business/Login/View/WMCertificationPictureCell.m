//
//  WMCertificationPictureCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCertificationPictureCell.h"

@implementation WMCertificationPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.againButton.layer.cornerRadius=4;
    self.againButton.layer.borderColor=[[UIColor colorWithHexString:@"18a2ff"] CGColor];
    self.againButton.layer.borderWidth=1.0;
    self.againButton.layer.masksToBounds=YES;
    self.pictureImageView.contentMode=UIViewContentModeScaleAspectFill;

    self.pictureImageView.layer.cornerRadius=4.0;
    self.pictureImageView.layer.masksToBounds=YES;
    [self setupCellView];
    
}
-(void)setupCellView{
    // Initialization code
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = CGRectMake(0, 0, 150, 100);
        //    borderLayer.position = CGPointMake(self.showView.centerX, self.showView.centerY);
        
        borderLayer.path = [UIBezierPath bezierPathWithRect:self.imageView.frame].CGPath;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.frame cornerRadius:4].CGPath;
        
        
        borderLayer.lineWidth = 2;
        //虚线边框
        borderLayer.lineDashPattern = @[@12, @6];
        //实线边框
        //    borderLayer.lineDashPattern = nil;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        [self.pictureView.layer addSublayer:borderLayer];
    });
    
    UITapGestureRecognizer * privateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureAction:)];
    privateLetterTap.numberOfTouchesRequired = 1; //手指数
    privateLetterTap.numberOfTapsRequired = 1; //tap次数
    [self.pictureView addGestureRecognizer:privateLetterTap];
    
    
    

}
-(void)setPhotos:(NSMutableArray *)photos{
    if (photos.count>0) {
        self.againButton.hidden=NO;
        self.addLabel.hidden=YES;
        self.pictureImageView.image=[photos firstObject];
        self.pictureView.hidden=YES;
    }
    else{
        self.pictureView.hidden=NO;
        self.againButton.hidden=YES;
        self.addLabel.hidden=NO;
    }
}
- (IBAction)uploadAgainAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadPictureAgainAction)]) {
        [self.delegate uploadPictureAgainAction];
    }
}

-(void)sureAction: (UITapGestureRecognizer *)gesture{
    
    //respondsToSelector
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadPictureAction)]) {
        [self.delegate uploadPictureAction];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
