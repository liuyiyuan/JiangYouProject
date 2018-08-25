//
//  JYCircleHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleHeaderView.h"
#import "JYHomeBeautyPictureHeaderCollectionViewCell.h"

@interface JYCircleHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
@implementation JYCircleHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.loopView];
    [self addSubview:self.hotLabel];
    [self insertSubview:self.arrowLabel aboveSubview:self.hotLabel];
    [self addSubview:self.collectionView];
  
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(UI_SCREEN_WIDTH);
        make.height.mas_equalTo(pixelValue(360));
    }];
    
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.loopView.mas_bottom).offset(pixelValue(10));
        make.width.mas_equalTo(UI_SCREEN_WIDTH);
        make.height.mas_equalTo(pixelValue(80));
    }];
    
    [self.arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hotLabel.mas_centerY);
        make.right.mas_equalTo(self.hotLabel.mas_right).offset(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(80));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(172));
    }];
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYHomeBeautyPictureHeaderCollectionViewCell";
    JYHomeBeautyPictureHeaderCollectionViewCell * cell = (JYHomeBeautyPictureHeaderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UI_SCREEN_WIDTH - pixelValue(100)) / 2, pixelValue(160));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(pixelValue(0), pixelValue(0), pixelValue(0), pixelValue(0));
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return pixelValue(0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(clickHotViewIndex:)]) {
        [self.delegate clickHotViewIndex:indexPath];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(HYBLoopScrollView *)loopView{
    if(!_loopView){
        NSArray *imageArray = @[@"矩形 13 副本 4",@"矩形 13 副本 4",@"矩形 13 副本 4",@"矩形 13 副本 4"];
        _loopView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(360)) imageUrls:imageArray timeInterval:5 didSelect:^(NSInteger atIndex) {
            
        } didScroll:^(NSInteger toIndex) {
            
        }];
    }
    return _loopView;
}

//热门推荐
-(UILabel *)hotLabel{
    if(!_hotLabel){
        _hotLabel = [[UILabel alloc]init];
        _hotLabel.backgroundColor = [UIColor whiteColor];
        _hotLabel.text = @"  热门推荐";
        _hotLabel.textColor = [UIColor blackColor];
        _hotLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _hotLabel;
}
//箭头
-(UILabel *)arrowLabel{
    if(!_arrowLabel){
        _arrowLabel = [[UILabel alloc]init];
        _arrowLabel.text = @">";
        _arrowLabel.textColor = [UIColor blackColor];
        _arrowLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _arrowLabel;
}




-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//确定是水平滚动，还是垂直滚动
        flowLayout.minimumLineSpacing = pixelValue(0);
        flowLayout.minimumInteritemSpacing = pixelValue(10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[JYHomeBeautyPictureHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"JYHomeBeautyPictureHeaderCollectionViewCell"];
    }
    return _collectionView;
}

@end
