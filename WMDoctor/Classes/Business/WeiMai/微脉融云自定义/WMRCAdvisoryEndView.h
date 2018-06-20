//
//  WMRCAdvisoryEndView.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,WMRCAdvisoryEndViewType) {
    
    WMRCAdvisoryEndViewTypeFollowUp         =3001,//随访机制
    WMRCAdvisoryEndViewTypeSayHello         =3002,//打招呼机制
    
};

@protocol WMRCAdvisoryEndViewDelegate <NSObject>
@optional
-(void)followUpWithButton:(UIButton *)button;
-(void)sayHelloWithButton:(UIButton *)button;

@end

@interface WMRCAdvisoryEndView : UIView

- (id)initWithFrame:(CGRect)frame withType:(WMRCAdvisoryEndViewType)type;
@property (nonatomic, assign)id<WMRCAdvisoryEndViewDelegate>delegate;
@property (nonatomic, strong)UIImageView * showImageView;
@property (nonatomic, strong)UIButton *followUpButton;
@property (nonatomic, strong)UIButton *sayHelloButton;

- (void)hiddenView;

@end
