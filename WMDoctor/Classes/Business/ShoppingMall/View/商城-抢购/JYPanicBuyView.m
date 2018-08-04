//
//  JYPanicBuyView.m
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPanicBuyView.h"
#import "JYPanicBuyCell.h"
#import "JYPanicBuyAPIManager.h"

@interface JYPanicBuyView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation JYPanicBuyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self loadPanicBuyAPIManager];
    }
    return self;
}

- (void)setupView{
    
    //初始化布局类
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置每个item的大小
    flowlayout.itemSize = CGSizeMake((kScreenWidth - 3) / 2, 295);
    //设置列的最小间距
    flowlayout.minimumInteritemSpacing = 3;
    //设置最小行间距
    flowlayout.minimumLineSpacing = 5;
    //设置布局的内边距
//    flowlayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    //滚动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
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
    [cell setValueWithModel];
    return cell;
}


- (void)loadPanicBuyAPIManager{
    JYPanicBuyAPIManager *spanicBuyAPIManager = [[JYPanicBuyAPIManager alloc] init];
    [spanicBuyAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"panic : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"panic error : %@", errorResult);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
