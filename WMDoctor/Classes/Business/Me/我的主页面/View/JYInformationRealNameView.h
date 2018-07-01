//
//  JYInformationRealNameView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYInformationButtonArrayView.h"
@interface JYInformationRealNameView : UIView

@property(nonatomic,strong)UILabel *doneLabel;//完成实名认证获得更多红利

@property(nonatomic,strong)UILabel *realNameLabel;//实名认证

@property(nonatomic,strong)UIView *lineView;//灰线

@property(nonatomic,strong)UILabel *nameLabel;//姓名

@property(nonatomic,strong)UITextField *nameTextField;//姓名输入框

@property(nonatomic,strong)UILabel *idNumberLabel;//身份证号

@property(nonatomic,strong)UITextField *idNumberTextField;//身份证号输入框

@property(nonatomic,strong)UILabel *industryLabel;//行业

@property(nonatomic,strong)NSMutableArray *buttonArray;//按钮数组

@property(nonatomic,strong)UIButton *selectedButton;//已选中按钮

@property(nonatomic,strong)JYInformationButtonArrayView *buttonArrayView;//按钮背景view 

@property(nonatomic,strong)UITextField *workTextFidle;//从事行业输入框

@property(nonatomic,strong)UIView *secondLineView;//下边线

@end
