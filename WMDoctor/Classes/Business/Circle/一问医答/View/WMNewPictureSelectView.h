//
//  WMNewPictureSelectView.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/4.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPictureSelectViewCell.h"
#define guide_high 105 //引导图的高度
#define picture_width ((kScreen_width-20)/4-0.2)


typedef  NS_ENUM (NSInteger, PictureShowType) {
    ShowPictureType             =1, // 展示已有图片
    SelectPictureType           =2, // 选择图片
    
};

@protocol WMNewPictureSelectViewDelegate <NSObject>
/**
 * 点击cell
 */
@optional
-(void)previewPictureWithTag:(NSInteger )tag withShowType:(PictureShowType) showType;


/**
 * 点击引导图片 进入相机或则相册
 */
@optional
-(void)jumpCamera;

/**
 * 删除 操作
 */
@optional
-(void)deletePictureWithIndex:(NSInteger)index;


@end
@interface WMNewPictureSelectView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WMPictureSelectDelegate>
{
    
}
@property(nonatomic ,strong)NSMutableArray *guidanceArray;
@property (nonatomic,strong)UIImage *guidanceImage;
@property (nonatomic,assign)int SupportNumber;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)id<WMNewPictureSelectViewDelegate>delegate;
@property (nonatomic,assign)CGFloat wide_High_Scale;//宽 比 高=值
@property (nonatomic,copy)NSString *reminderStr;

/**
 * 初始化视图
 * 根据数据的个数来判断view的高度 （毕竟是把view放在cell中）
 */
-(instancetype)initWithFrame:(CGRect)frame
                   withArray:(NSMutableArray *)array withWideHighScale:(CGFloat )WideHighScal
                withShowType:(PictureShowType)showType;




@end
