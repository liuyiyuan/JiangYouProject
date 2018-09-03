//
//  JYHomeBBSHeader.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSHeader.h"
#import "JYHomeBeautyPictureHeaderCollectionViewCell.h"

@interface JYHomeBBSHeader()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
@implementation JYHomeBBSHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
//        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.hotLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.taskImageView];
    [self addSubview:self.shopImageView];
    [self addSubview:self.focusImageView];
    [self addSubview:self.recommendedLabel];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(80));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(172));
    }];

    
    [self.taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(120));
        make.width.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(20)) / 3);
    }];

    [self.shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.taskImageView.mas_top);
        make.width.mas_equalTo(self.taskImageView.mas_width);
        make.height.mas_equalTo(self.taskImageView.mas_height);
        make.left.mas_equalTo(self.taskImageView.mas_right).offset(pixelValue(10));
    }];

    [self.focusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.taskImageView.mas_top);
        make.width.mas_equalTo(self.taskImageView.mas_width);
        make.height.mas_equalTo(self.taskImageView.mas_height);
        make.left.mas_equalTo(self.shopImageView.mas_right).offset(pixelValue(10));
    }];

    [self.recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(80));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-pixelValue(2));
    }];
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYHomeBeautyPictureHeaderCollectionViewCell";
    JYHomeBeautyPictureHeaderCollectionViewCell * cell = (JYHomeBeautyPictureHeaderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeHolder_image"]];
    
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


//热门
-(UILabel *)hotLabel{
    if(!_hotLabel){
        _hotLabel = [[UILabel alloc]init];
        _hotLabel.text = @"  热门";
        _hotLabel.textColor = [UIColor blackColor];
        _hotLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
        _hotLabel.backgroundColor = [UIColor whiteColor];
    }
    return _hotLabel;
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
//每日任务图
-(UIImageView *)taskImageView{
    if(!_taskImageView){
        _taskImageView = [[UIImageView alloc]init];
        _taskImageView.image = [UIImage imageNamed:@"JY_BBS_task"];
    }
    return _taskImageView;
}

//金币商城图
-(UIImageView *)shopImageView{
    if(!_shopImageView){
        _shopImageView = [[UIImageView alloc]init];
        _shopImageView.image = [UIImage imageNamed:@"JY_BBS_shop"];
    }
    return _shopImageView;
}

//关注列表
-(UIImageView *)focusImageView{
    if(!_focusImageView){
        _focusImageView = [[UIImageView alloc]init];
        _focusImageView.image = [UIImage imageNamed:@"JY_BBS_focus_list"];
    }
    return _focusImageView;
}

-(UILabel *)recommendedLabel{
    if(!_recommendedLabel){
        _recommendedLabel = [[UILabel alloc]init];
        _recommendedLabel.text = @"  精选推荐";
        _recommendedLabel.textColor = [UIColor blackColor];
        _recommendedLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
        _recommendedLabel.backgroundColor = [UIColor whiteColor];
    }
    return _recommendedLabel;
}



-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self configUI];
    [self.collectionView reloadData];
}

@end
