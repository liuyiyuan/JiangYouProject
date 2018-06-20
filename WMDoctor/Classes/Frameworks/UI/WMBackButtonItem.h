//
//  WMBackButtonItem.h
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMBackButtonItem : UIBarButtonItem

@property (nonatomic,copy) NSString *backTitle;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
