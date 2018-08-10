//
//  JYHomeSameCityTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCityTableViewCell.h"
#import "JYHomeSameCityCollectionViewCell.h"

@interface JYHomeSameCityTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation JYHomeSameCityTableViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYHomeSameCityCollectionViewCell";
    JYHomeSameCityCollectionViewCell * cell = (JYHomeSameCityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
    cell.myLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.row]];
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UI_SCREEN_WIDTH / 4, pixelValue(70));
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
//    if ([self.delegate respondsToSelector:@selector(clickSameCItyHeaderViewIndex:)]) {
//        [self.delegate clickSameCItyHeaderViewIndex:indexPath];
//    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//确定是水平滚动，还是垂直滚动
        flowLayout.minimumLineSpacing = pixelValue(0);
        flowLayout.minimumInteritemSpacing = pixelValue(0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JYHomeSameCityCollectionViewCell class] forCellWithReuseIdentifier:@"JYHomeSameCityCollectionViewCell"];
    }
    return _collectionView;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self configUI];
    [self.collectionView reloadData];
}
@end
