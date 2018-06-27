//
//  JYMyWalletViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMyWalletViewController.h"
#import "JYMyWalletCollectionViewCell.h"
@interface JYMyWalletViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *WalletCollectionView;

@end

@implementation JYMyWalletViewController{
    NSArray *_titleArr;
    NSArray *_picArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    
    _titleArr = @[@"会员卡",@"我的团购",@"我的抢购",@"我的订单",@"我的收藏"];
    _picArray = @[@"gift_card",@"friends_list",@"delivery",@"my_order",@"my_Collection"];
    [self configUI];
}


-(void)configUI{
    [self.view addSubview:self.WalletCollectionView];
    [self.WalletCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.top.mas_equalTo(pixelValue(0));
    }];
}


#pragma mark -- UICollectionViewDataSource ---定义展示的UICollectionViewCell的个数---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"JYMyWalletCollectionViewCell";
    JYMyWalletCollectionViewCell * cell = (JYMyWalletCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.picImg.image = [UIImage imageNamed:_picArray[indexPath.row]];
    cell.nameLab.text = _titleArr[indexPath.row];
    
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UI_SCREEN_WIDTH / 4, pixelValue(140));
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
   
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UICollectionView *)WalletCollectionView{
    if (!_WalletCollectionView) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = pixelValue(0);
        flowLayout.minimumInteritemSpacing = pixelValue(0);
        _WalletCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _WalletCollectionView.delegate = self;
        _WalletCollectionView.dataSource = self;
        _WalletCollectionView.backgroundColor = [UIColor whiteColor];
        _WalletCollectionView.showsVerticalScrollIndicator = NO;
        _WalletCollectionView.showsHorizontalScrollIndicator = NO;
        _WalletCollectionView.scrollEnabled = NO;
        [self.WalletCollectionView registerClass:[JYMyWalletCollectionViewCell class] forCellWithReuseIdentifier:@"JYMyWalletCollectionViewCell"];
    }
    return _WalletCollectionView;
}


@end
