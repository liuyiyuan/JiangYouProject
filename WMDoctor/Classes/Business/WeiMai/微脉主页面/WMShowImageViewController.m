//
//  WMShowImageViewController.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMShowImageViewController.h"
#import "UIImageView+WebCache.h"
#import "WMImageView.h"
#import "WMShowImageCollectionViewCell.h"

#define KHEIGHT kScreen_height-64
@interface WMShowImageViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SingTapActionDelegate>
{
    CGFloat _scrollOriginOffX;
}
@property (nonatomic,strong)UIScrollView *scrollViewOne;
@property (nonatomic,strong)UILabel *numberLble;
@property (nonatomic,strong)UIButton *deleteButton;

@property (nonatomic,strong)UICollectionView *collectionView;

@property(nonnull,strong)UIBarButtonItem * clearItem;
@end

@implementation WMShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setUICollectionView];
    if (self.isSupportDelete==1) {
       [self setClearBarButtonItems]; 
    }
    
//    [self overwriteBackBarButtonItems];
    [self overwriteTitleBarButtonItems];
}

#pragma mark--重写title
-(void)overwriteTitleBarButtonItems{
    self.numberLble=[[UILabel alloc]init];
    self.numberLble.frame=CGRectMake(0.0f,0.0f, 120.0f, 36.0f);
    self.numberLble.textAlignment=NSTextAlignmentCenter;
    self.numberLble.text=[NSString stringWithFormat:@"%d/%lu",_currentIndex+1,(unsigned long)self.array.count];
    self.numberLble.textColor=[UIColor whiteColor];
    self.navigationItem.titleView = _numberLble;
}
#pragma mark--重写返回按钮
//-(void)overwriteBackBarButtonItems
//{
//
//    //自定义返回按钮
//    UIImage *backButtonImage = [[UIImage imageNamed:@"bt_backarrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//
//    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet)];
//    item.width=50;
//    self.navigationItem.leftBarButtonItems = @[item];
//}
#pragma mark--重写返回按钮的点击事件
-(void)showActionSheet{
    if (_isImageData==YES) {
        [self backToTaget];
    }
    else{
         [self back];
    }
   
}
#pragma mark--设置左边的的删除按钮
-(void)setClearBarButtonItems
{
    //UIBarButtonItem *pushItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showActionSheet:)];
    
    self.clearItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"weimai_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    self.clearItem.width=50;
    self.navigationItem.rightBarButtonItems = @[self.clearItem];
    
}
#pragma mark--设置左边的的删除按钮的点击事件
- (void)showActionSheet:(id)sender{
    
    [self.array removeObjectAtIndex:_currentIndex];
    if (self.array.count==0) {
        self.numberLble.hidden=YES;
        [self back];
        return;
    }
    self.numberLble.text=[NSString stringWithFormat:@"%d/%lu",_currentIndex+1,(unsigned long)self.array.count];
    
    [self.collectionView reloadData];
    NSIndexPath* cellIndexPath=nil;
    if (self.array.count<=_currentIndex) {
        cellIndexPath= [NSIndexPath indexPathForItem:self.array.count-1 inSection:0];
    }
    else{
        cellIndexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    }
    //指定到滚动的目标页面
    [self.collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}
#pragma mark--创建CollectionView容器
-(void)setUICollectionView{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //设置容器横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //最小列间距
    layout.minimumInteritemSpacing = 0;
    //最小行间距
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) collectionViewLayout:layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.pagingEnabled=YES;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"WMShowImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageCollectionViewCell"];
    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    
}
#pragma mark--返回事件重写

-(void)backToTaget{
    
    
   
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--CollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.array.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kScreen_width, kScreen_height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMShowImageCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCollectionViewCell" forIndexPath:indexPath];
    item.backgroundColor = [UIColor whiteColor];
    item.delegate=self;
    if (_isImageData==YES) {
        [item setupImageView:self.array[indexPath.row]];
    }
    else{
         [item setupView:self.array[indexPath.row]];
    }
   
    return item;
}
#pragma mark--图片单击事件
-(void)SingTapAction
{
    //[self back];
    
}
-(void)deleteAction:(UIButton *)button{
    NSLog(@"button.tag=%ld",(long)button.tag);
    [self.array removeObjectAtIndex:button.tag];
    [self.collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark--scrollView的Delegate
// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int number=_collectionView.contentOffset.x/kScreen_width;
    NSLog(@"number11111=%d",number);
    _currentIndex=number;
    //因为涉及到向前滚动和向后滚动 所以要把临近的两张图都变成原来尺寸
    _numberLble.text=[NSString stringWithFormat:@"%d/%lu",number+1,(unsigned long)self.array.count];
    /*
     if (number==0) {
     
     }
     else{
     JBImageView *viewOne=[_scrollViewOne viewWithTag:200+number-1];
     [viewOne setScaleImageToNormal];
     JBImageView *view=[_scrollViewOne viewWithTag:200+number];
     [view setScaleImageToNormal];
     JBImageView *viewTWO=[_scrollViewOne viewWithTag:200+number+1];
     [viewTWO setScaleImageToNormal];
     }
     */
    
    //NSLog(@"_scrollView.contentOffset.x=%f",_scrollView.contentOffset.x);
    //int number=_scrollView.contentOffset.x/kScreen_width;
    // NSLog(@"number=%d",number);
}

-(void)dealloc{
    
    NSLog(@"释放吗");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
