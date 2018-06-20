//
//  WMNewPictureSelectView.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/4.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMNewPictureSelectView.h"
#import <UIImageView+WebCache.h>
#import "WMGuidanceCollectionViewCell.h"
#import "WMIMFirstCollectionViewCell.h"
#import "WMIMComFirstCollectionViewCell.h"

#import "WMAddPictureViewCell.h"
#import "WMLeadPictureViewCell.h"
@interface WMNewPictureSelectView()
@property (nonatomic ,assign)PictureShowType picturetype;

@end

@implementation WMNewPictureSelectView

-(instancetype)initWithFrame:(CGRect) frame
                   withArray:(NSMutableArray *) array
           withWideHighScale:(CGFloat ) WideHighScal
                withShowType:(PictureShowType) showType
{
    self=[super initWithFrame:frame];
    if (self) {
        self.wide_High_Scale=WideHighScal;
        [self setupDataWithArray:array];
        //页面布局
        self.picturetype=showType;
        [self setupView];
    }
    
    return self;
}
-(void)setupDataWithArray:(NSMutableArray *)array{
    self.photos=[[NSMutableArray alloc]initWithArray:array];
    _guidanceImage=[UIImage imageNamed:@"ic_zaixianzixun_photo"];
    self.guidanceArray=[[NSMutableArray alloc]initWithObjects:_guidanceImage, nil];
}
-(void)setupView{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //最小列间距
    layout.minimumInteritemSpacing = 0;
    //最小行间距
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //位置的控制周边空出 10 的距离
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"WMAddPictureViewCell" bundle:nil] forCellWithReuseIdentifier:@"addPictureViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"WMPictureSelectViewCell" bundle:nil] forCellWithReuseIdentifier:@"pictureSelectViewCell"];
     [_collectionView registerNib:[UINib nibWithNibName:@"WMLeadPictureViewCell" bundle:nil] forCellWithReuseIdentifier:@"leadPictureViewCell"];
    
}
#pragma mark--UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.photos.count!=6) {
        if (self.picturetype==ShowPictureType) {
            if (self.photos.count==0) {
                return 1;
            }
            return self.photos.count;
            
        }else{
            return self.guidanceArray.count+self.photos.count;
        }
        
    }
    else{
        return self.photos.count;
    }

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.photos.count==0){
        
        return CGSizeMake(kScreen_width-20, guide_high-20);
        
    }else{
        //保证正方形
        return CGSizeMake(picture_width, picture_width);
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    if (self.photos.count==0) {
        WMLeadPictureViewCell *item=[collectionView dequeueReusableCellWithReuseIdentifier:@"leadPictureViewCell" forIndexPath:indexPath];
        //item.detailLable.text=self.reminderStr;
        return item;
        
        
    }else{
       
        if (indexPath.row+1>self.photos.count) {
            
            WMAddPictureViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"addPictureViewCell" forIndexPath:indexPath];
            return item;
        }
        else{
            
            WMPictureSelectViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureSelectViewCell" forIndexPath:indexPath];
            item.delegate=self;
            item.deleteButton.tag=indexPath.row;
            if (self.picturetype==ShowPictureType) {
                item.deleteButton.hidden=YES;
            }
            else{
                item.deleteButton.hidden=NO;
            }
            if ([self.photos[indexPath.row] isKindOfClass:[UIImage class]]) {
                item.showImageView.image =self.photos[indexPath.row];
            }
            else{
                [item.showImageView sd_setImageWithURL:[NSURL URLWithString:self.photos[indexPath.row]]];
            }
            
            return item;
        }
        
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row+1>self.photos.count) {
        //这个是点击增加图片的方法 需要用delegate传出去
        [self changedImageAction];
        return;
    }
    //点击这个是展示图片的方案 需要用delegate传出去
    [self setupView:indexPath.row];
}

#pragma mark--cell上删除按钮
-(void)removeAction:(UIButton *)button{
    NSLog(@"button.tag=%ld",(long)button.tag);
    //[self.photos removeObjectAtIndex:button.tag];
    //[_collectionView reloadData];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deletePictureWithIndex:)]) {
        [self.delegate deletePictureWithIndex:button.tag];
    }
    
 
}
#pragma mark--这个是点击增加图片的方法 需要用delegate传出去
-(void)changedImageAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpCamera)]) {
        [self.delegate jumpCamera];
    }
}

#pragma mark--点击cell跳转事件
-(void)setupView:(NSInteger)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewPictureWithTag:withShowType:)]) {
        [self.delegate previewPictureWithTag:indexPath withShowType:self.picturetype];
    }
    
}

@end
