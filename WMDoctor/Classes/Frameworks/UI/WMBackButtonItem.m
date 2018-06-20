//
//  WMBackButtonItem.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBackButtonItem.h"

static  CGFloat const itemWidth    = 82;
static  CGFloat const itemHeight   = 44;
static  CGFloat const buttonHeight = 26;

@interface WMBackButtonItem()
{
    __weak id  _kTarget;
    SEL _kAction;
}

@end

@implementation WMBackButtonItem

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        
        _backTitle = title;
        _kTarget = target;
        _kAction = action;
        
        [self initialize];
        

    }return self;
}
- (void)initialize
{
    UIControl * backControl = [[UIControl alloc] init];
    backControl.frame = CGRectMake(0, 0, itemWidth, itemHeight);
    [backControl addTarget:_kTarget action:_kAction forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"bt_backarrow"] forState:UIControlStateNormal];
    backbutton.frame = CGRectMake(0, (itemHeight-buttonHeight)/2, buttonHeight, buttonHeight);
    backbutton.userInteractionEnabled = NO;
    [backbutton setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 7)];
    [backControl addSubview:backbutton];
    
    UILabel * backtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (itemHeight-buttonHeight)/2, itemWidth-20, buttonHeight)];
    backtitleLabel.text = _backTitle;
    backtitleLabel.textColor = [UIColor whiteColor];
    backtitleLabel.font = [UIFont systemFontOfSize:15];
    [backControl addSubview:backtitleLabel];
    
    self.customView = backControl;

}

@end
