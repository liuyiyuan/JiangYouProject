//
//  WMDoctorCertificationResultView.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMDoctorCerResultViewDelegate <NSObject>

-(void)newbieGuide;
-(void)continueAuthentication;

@end


@interface WMDoctorCertificationResultView : UIView
-(instancetype) init __attribute__((unavailable("init not available, call right init method")));
+(instancetype) new __attribute__((unavailable("new not available, call right method")));
/**
 *  初始化
 *  param textString 错误原因或成功原因
 **/
-(id)initWithText:(NSString *)textString withMoney:(NSString *)money;


/**
 *  shadowView
 *  背景
 **/
@property(nonatomic,strong)UIView *shadowView;

@property(nonatomic,assign)id<WMDoctorCerResultViewDelegate>delegate;

/**
 *  bgView
 *  视图背景
 **/
@property(nonatomic,strong)UIView *bgView;
/**
 *  resultView
 *  结果视图
 **/
@property(nonatomic,strong)UIView *resultView;
/**
 *  shadowView
 *  原因视图
 **/
@property(nonatomic,strong)UIView *reasonView;

/**
 *  shadowView
 *  原因视图
 **/
@property(nonatomic,strong)NSMutableArray *resonArray;

/**
 * 弹出视图
 */
-(void)show;
/**
 * 隐藏视图
 */
-(void)remove;


@end
