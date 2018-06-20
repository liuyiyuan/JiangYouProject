//
//  WMServiceSetCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMServiceSetInfoModel.h"

@protocol WMServicePriceChangeDelegate <NSObject>

-(void)cellClickBtn:(NSString *)strTypeId;

-(void)refreshPrice;

@end

@interface WMServiceSetCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) WMServiceSetInfoModels * _infoModel;
@property (nonatomic,assign)id<WMServicePriceChangeDelegate>delegate;

@property (nonatomic,assign) BOOL useOn;

- (void)setCellValue:(WMServiceSetInfoModels *)model;
@end
