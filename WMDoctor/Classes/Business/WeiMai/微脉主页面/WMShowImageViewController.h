//
//  WMShowImageViewController.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMShowImageViewController : WMBaseViewController
//数组只能传输Image对象
@property (nonatomic,strong)NSMutableArray *array;
//点击图片索引
@property (nonatomic,assign)int currentIndex;

@property (nonatomic,assign)BOOL isSupportDelete;

@property (nonatomic,assign)BOOL isImageData;

@end
