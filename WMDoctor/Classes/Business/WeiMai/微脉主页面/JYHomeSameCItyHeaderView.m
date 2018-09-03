//
//  JYHomeSameCItyHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCItyHeaderView.h"
#import "JYHomeSameCityHeaderCollectionViewCell.h"
@interface JYHomeSameCItyHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation JYHomeSameCItyHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.collectionView];
    [self addSubview:self.goodWorkImageView];
    [self addSubview:self.secondhandImageImage];
    [self addSubview:self.strategyImage];
    
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.blueView];
    [self.whiteView addSubview:self.hotLabel];
    [self.whiteView addSubview:self.lineView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(120));
    }];
    
    [self.goodWorkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(pixelValue(30));
        make.left.mas_equalTo(pixelValue(30));
        make.width.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(90)) / 2);
        make.height.mas_equalTo(pixelValue(361));
    }];
    
    [self.secondhandImageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodWorkImageView.mas_top);
        make.right.mas_equalTo(-pixelValue(30));
        make.width.mas_equalTo(self.goodWorkImageView.mas_width);
        make.height.mas_equalTo(pixelValue(172));
    }];
    
    [self.strategyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondhandImageImage.mas_left);
        make.bottom.mas_equalTo(self.goodWorkImageView.mas_bottom);
        make.right.mas_equalTo(self.secondhandImageImage.mas_right);
        make.height.mas_equalTo(pixelValue(169));
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodWorkImageView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.width.mas_equalTo(pixelValue(10));
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blueView.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.right.mas_equalTo(pixelValue(-30));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.whiteView.mas_bottom);
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fastListArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYHomeSameCityHeaderCollectionViewCell";
    JYHomeSameCityHeaderCollectionViewCell * cell = (JYHomeSameCityHeaderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.fastListArray[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"channelIcon"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
    cell.myLabel.text = dict[@"title"];
    
    
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UI_SCREEN_WIDTH / 6, pixelValue(120));
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
    if ([self.delegate respondsToSelector:@selector(clickSameCItyHeaderViewIndex:)]) {
        [self.delegate clickSameCItyHeaderViewIndex:indexPath];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//确定是水平滚动，还是垂直滚动
        flowLayout.minimumLineSpacing = pixelValue(0);
        flowLayout.minimumInteritemSpacing = pixelValue(0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_collectionView registerClass:[JYHomeSameCityHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"JYHomeSameCityHeaderCollectionViewCell"];
    }
    return _collectionView;
}
//支撑风向标，海量好工作
-(UIImageView *)goodWorkImageView{
    if(!_goodWorkImageView){
        _goodWorkImageView = [[UIImageView alloc]init];
//        _goodWorkImageView.image = [UIImage imageNamed:@"JY_sameCity_goodWork"];
    }
    return _goodWorkImageView;
}
//二手手机
-(UIImageView *)secondhandImageImage{
    if(!_secondhandImageImage){
        _secondhandImageImage = [[UIImageView alloc]init];
//        _secondhandImageImage.image = [UIImage imageNamed:@"JY_sameCity_secondHand"];
    }
    return _secondhandImageImage;
}
//职场攻略
-(UIImageView *)strategyImage{
    if(!_strategyImage){
        _strategyImage = [[UIImageView alloc]init];
//        _strategyImage.image = [UIImage imageNamed:@"JY_sameCity_strategyImage"];
    }
    return _strategyImage;
}

-(UIView *)whiteView{
    if(!_whiteView){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

-(UIView *)blueView{
    if(!_blueView){
        _blueView = [[UIView alloc]init];
        _blueView.backgroundColor = [UIColor colorWithHexString:@"#0291FC"];
    }
    return _blueView;
}

-(UILabel *)hotLabel{
    if(!_hotLabel){
        _hotLabel = [[UILabel alloc]init];
        _hotLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
        _hotLabel.textColor = [UIColor colorWithHexString:@"#1A80CC"];
        _hotLabel.text = @"热门服务";
    }
    return _hotLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#C0BEBE"];
    }
    return _lineView;
}

-(void)setFastListArray:(NSArray *)fastListArray{
    _fastListArray = fastListArray;
    [self.collectionView reloadData];
}

-(void)setPhotoNavListArray:(NSArray *)photoNavListArray{
    _photoNavListArray = photoNavListArray;
    if(photoNavListArray.count == 3){
        NSDictionary *dict0 = photoNavListArray[0];
        NSDictionary *dict1 = photoNavListArray[1];
        NSDictionary *dict2 = photoNavListArray[2];
        [self.goodWorkImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict0[@"photoLink"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
        [self.secondhandImageImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict1[@"photoLink"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
        [self.strategyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict2[@"photoLink"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
    }

}

@end
