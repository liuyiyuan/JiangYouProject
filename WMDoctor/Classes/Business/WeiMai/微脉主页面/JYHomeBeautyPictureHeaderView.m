//
//  JYHomeBeautyPictureHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPictureHeaderView.h"
#import "JYHomeBeautyPictureHeaderCollectionViewCell.h"

@interface JYHomeBeautyPictureHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation JYHomeBeautyPictureHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        
//        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    [self addSubview:self.oldPicture];
    [self.oldPicture addSubview:self.oldPictureLabel];
    [self addSubview:self.bigBeautyJy];
    [self.bigBeautyJy addSubview:self.bigBeautyJyLabel];
    [self addSubview:self.BTW];
    [self.BTW addSubview:self.BTWLabel];
    [self addSubview:self.hotLabel];
    [self addSubview:self.collection];
    
    [self.oldPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(20));
        make.left.mas_equalTo(pixelValue(20));
        make.height.mas_equalTo(pixelValue(102));
        make.width.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(80)) / 3);
    }];
    
    [self.oldPictureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
    }];
    
    [self.bigBeautyJy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPicture.mas_top);
        make.width.mas_equalTo(self.oldPicture.mas_width);
        make.height.mas_equalTo(self.oldPicture.mas_height);
        make.left.mas_equalTo(self.oldPicture.mas_right).offset(pixelValue(20));
    }];
    
    [self.bigBeautyJyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
    }];
    
    [self.BTW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPicture.mas_top);
        make.width.mas_equalTo(self.oldPicture.mas_width);
        make.height.mas_equalTo(self.oldPicture.mas_height);
        make.left.mas_equalTo(self.bigBeautyJy.mas_right).offset(pixelValue(20));
    }];
    
    [self.BTWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
    }];
    
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPicture.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(20));
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(172));
    }];
}

//老照片
-(UIImageView *)oldPicture{
    if(!_oldPicture){
        _oldPicture = [[UIImageView alloc]init];
        _oldPicture.image = [UIImage imageNamed:@"圆角矩形 4"];
        _oldPicture.userInteractionEnabled = YES;
    }
    return _oldPicture;
}
//老照片label
-(UILabel *)oldPictureLabel{
    if(!_oldPictureLabel){
        _oldPictureLabel = [[UILabel alloc]init];
        _oldPictureLabel.textColor = [UIColor whiteColor];
        _oldPictureLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _oldPictureLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _oldPictureLabel;
}



//大美江油
-(UIImageView *)bigBeautyJy{
    if(!_bigBeautyJy){
        _bigBeautyJy = [[UIImageView alloc]init];
        _bigBeautyJy.image = [UIImage imageNamed:@"圆角矩形 4"];
        _bigBeautyJy.userInteractionEnabled = YES;
    }
    return _bigBeautyJy;
}
//大美江油label
-(UILabel *)bigBeautyJyLabel{
    if(!_bigBeautyJyLabel){
        _bigBeautyJyLabel = [[UILabel alloc]init];
        _bigBeautyJyLabel.textColor = [UIColor whiteColor];
        _bigBeautyJyLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _bigBeautyJyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bigBeautyJyLabel;
}
//随手拍
-(UIImageView *)BTW{
    if(!_BTW){
        _BTW = [[UIImageView alloc]init];
        _BTW.image = [UIImage imageNamed:@"圆角矩形 4"];
        _BTW.userInteractionEnabled = YES;
    }
    return _BTW;
}
//随手拍label
-(UILabel *)BTWLabel{
    if(!_BTWLabel){
        _BTWLabel = [[UILabel alloc]init];
        _BTWLabel.textColor = [UIColor whiteColor];
        _BTWLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _BTWLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _BTWLabel;
}
//热门推荐
-(UILabel *)hotLabel{
    if(!_hotLabel){
        _hotLabel = [[UILabel alloc]init];
        _hotLabel.text = @"  热门推荐";
        _hotLabel.textColor = [UIColor blackColor];
        _hotLabel.backgroundColor = [UIColor whiteColor];
        _hotLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _hotLabel;
}

-(UICollectionView *)collection{
    if(!_collection){
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//确定是水平滚动，还是垂直滚动
        flowLayout.minimumLineSpacing = pixelValue(0);
        flowLayout.minimumInteritemSpacing = pixelValue(10);
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.scrollEnabled = YES;
        [_collection registerClass:[JYHomeBeautyPictureHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"JYHomeBeautyPictureHeaderCollectionViewCell"];
    }
    return _collection;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotDataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYHomeBeautyPictureHeaderCollectionViewCell";
    JYHomeBeautyPictureHeaderCollectionViewCell * cell = (JYHomeBeautyPictureHeaderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.hotDataArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
    
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

-(void)setHotDataArray:(NSArray *)hotDataArray{
    _hotDataArray = hotDataArray;
    [self configUI];
    [self.collection reloadData];
}

-(void)setPictureTagArray:(NSArray *)PictureTagArray{
    _PictureTagArray = PictureTagArray;
    if(PictureTagArray.count == 3){
        NSDictionary *dict0 = PictureTagArray[0];
        NSDictionary *dict1 = PictureTagArray[1];
        NSDictionary *dict2 = PictureTagArray[2];
        [self.oldPicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict0[@"channelImg"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
        self.oldPictureLabel.text = dict0[@"captions"];
        [self.bigBeautyJy sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict1[@"channelImg"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
        self.bigBeautyJyLabel.text = dict1[@"captions"];
        [self.BTW sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict2[@"channelImg"]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
        self.BTWLabel.text = dict2[@"captions"];
    }


    
}

@end
