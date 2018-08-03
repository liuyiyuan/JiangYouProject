//
//  JYPanicBuyView.m
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPanicBuyView.h"
#import "JYPanicBuyCell.h"

@interface JYPanicBuyView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation JYPanicBuyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupView{
    
    //初始化布局类
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置每个item的大小
    flowlayout.itemSize = CGSizeMake(120, 60);
    //设置列的最小间距
    flowlayout.minimumInteritemSpacing = 10;
    //设置最小行间距
    flowlayout.minimumLineSpacing = 15;
    //设置布局的内边距
    flowlayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    //滚动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JYPanicBuyCell class]) bundle:nil] forCellWithReuseIdentifier:@"JYPanicBuyCell"];
    
    [self addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JYPanicBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYPanicBuyCell" forIndexPath:indexPath];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
