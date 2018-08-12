//
//  JYGroupBuyView.m
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYGroupBuyView.h"
#import "JYPanicBuyCell.h"
#import "JYGroupBuyAPIManager.h"
#import "JYLoginNewModel.h"
#import "JYGroupBuyModel.h"

@interface JYGroupBuyView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation JYGroupBuyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupView];
        [self loadGroupBuyRequest];
    }
    return self;
}

- (void)setupData{
    self.dataSource = [NSMutableArray array];
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
//    flowlayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
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
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JYGroupBuyOneGoodsModel *groupBuyGoods = [self.dataSource objectAtIndex:indexPath.row];
    JYPanicBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYPanicBuyCell" forIndexPath:indexPath];
    [cell setValueWithGroupBuyGoodsModel:groupBuyGoods];
    return cell;
}

- (void)loadGroupBuyRequest{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"JYLoginUserInfo"];
    JYLoginNewModel *loginUser = [[JYLoginNewModel alloc] initWithDictionary:dic error:nil];
    NSDictionary *param = @{
                            @"userId" : loginUser.userId,
                            @"typeId" : @"0",
                            @"pageNow" : @"1",
                            @"pageLimit" : @"10"
                            };
    JYGroupBuyAPIManager *groupBuyAPIManager = [[JYGroupBuyAPIManager alloc] init];
    [groupBuyAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"group buy : %@", responseObject);
        JYGroupBuyModel *groupBuyModel = [[JYGroupBuyModel alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:groupBuyModel.GroupArray];
        [self.collectionView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"group buy error : %@", errorResult);
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
