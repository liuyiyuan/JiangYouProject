//
//  WMGroupMemberViewController.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/19.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMGroupMemberViewController.h"
#import "WMGroupMemberViewCell.h"
#import "WMGroupMemberAPIManager.h"
#import "WMPatientDataViewController.h"
@interface WMGroupMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *memberArray;
@end

@implementation WMGroupMemberViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"群成员";
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self setupView];
    [self setData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)setData{
    
    if (self.groupMembers.count == 0) {
        self.groupMembers = [NSMutableArray array];
        [self loadGroupMembersRequest];
    } else{
        [_collectionView reloadData];
    }
}

-(void)setupView{
    self.memberArray=[[NSMutableArray alloc] initWithCapacity:0];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //最小列间距
    layout.minimumInteritemSpacing = 20;
    //最小行间距
    layout.minimumLineSpacing = 20;
    //layout.itemSize = CGSizeMake(50, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 0, 10);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"WMGroupMemberViewCell" bundle:nil] forCellWithReuseIdentifier:@"GroupMemberViewCell"];
    
}

#pragma mark--UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.groupMembers.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(70, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMOneMemberModel *model=self.groupMembers[indexPath.row];
    WMGroupMemberViewCell *item=[collectionView dequeueReusableCellWithReuseIdentifier:@"GroupMemberViewCell" forIndexPath:indexPath];
    [item setupViewWithModel:model];

    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WMOneMemberModel *member = self.groupMembers[indexPath.row];
    if ([member.userType intValue] == 3) {
        WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
        patientDataViewController.userId = member.weimaihao;
        patientDataViewController.groupId = self.groupID;
        [self.navigationController pushViewController:patientDataViewController animated:YES];
    }
    
}

- (void)loadGroupMembersRequest{
    WMGroupMemberAPIManager *groupMemberAPIManager=[[WMGroupMemberAPIManager alloc] init];
    NSDictionary *param = @{
                            @"qunbianhao" : self.groupID
                            };
    [groupMemberAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMGroupMemberModel *groupMembers = [[WMGroupMemberModel alloc] initWithDictionary:responseObject error:nil];
        [_groupMembers removeAllObjects];
        [_groupMembers addObjectsFromArray: groupMembers.result];
        [_collectionView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"群成员error = %@", errorResult);
    }];
}

@end
