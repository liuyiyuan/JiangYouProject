//
//  WMEvaluateLabelView.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMEvaluateLabelView.h"

@interface WMEvaluateLabelView() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView           *_collectionView;
    NSMutableArray             *_labelArr;
    int                        _showTpe;
    
    NSMutableArray             *_selectArr;
    float                      _distance;
}

@end
@implementation WMEvaluateLabelView


-(void)configeWithData:(NSArray*)arr
{
    _showTpe = 1;
    _distance = 0;
    _labelArr = [[NSMutableArray alloc] initWithArray:arr];
    
    _selectArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.estimatedItemSize = CGSizeMake(10, 10);
    
    if (_collectionView) {
        [_collectionView removeFromSuperview];
    }
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _distance, kScreen_width - 15*2, self.frame.size.height - _distance) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    NSLog(@"_distance:%f",self.frame.size.width);
    //注册Cell，必须要有
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self addSubview:_collectionView];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //    _collectionView.frame = CGRectMake(0, _distance, self.frame.size.width, self.frame.size.height - _distance);
    _collectionView.frame = CGRectMake(0, _distance, kScreen_width - 15*2, self.frame.size.height);
    
    
}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_labelArr count] >= 3?3:[_labelArr count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGSize size = CGSizeMake(80, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"%@", [_labelArr objectAtIndex:indexPath.row]];
    label.layer.cornerRadius = 4;
    
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    
    [cell.contentView addSubview:label];
    
    label.textColor = [UIColor colorWithHexString:@"a7a7a7"];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor colorWithHexString:@"a7a7a7"].CGColor;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 20);
}

//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//    //    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
