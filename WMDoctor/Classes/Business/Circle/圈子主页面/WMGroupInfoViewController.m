//
//  WMGroupInfoViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/3/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMGroupInfoViewController.h"
#import "WMGroupMemberViewCell.h"
#import "WMGroupMemberAPIManager.h"
#import "WMPatientDataViewController.h"
#import "WMGroupInfoRemindCell.h"
#import "WMGroupMemberViewController.h"

@interface WMGroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *memberArray;
@end

@implementation WMGroupInfoViewController

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
//    [self loadGroupMembersRequest];
    if (self.groupMembers.count == 0) {
        self.groupMembers = [NSMutableArray array];
        [self loadGroupMembersRequest];
    } else{
        [_collectionView reloadData];
        [_tableView reloadData];
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
    
    
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 310) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"WMGroupMemberViewCell" bundle:nil] forCellWithReuseIdentifier:@"GroupMemberViewCell"];
    
    //UItableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMGroupInfoRemindCell class]) bundle:nil] forCellReuseIdentifier:@"WMGroupInfoRemindCell"];
    [self.view addSubview:_tableView];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.groupMembers.count > 15) {
                _collectionView.frame = CGRectMake(0, 0, kScreen_width, 3*110);
                return 3*110;
            }else{
                _collectionView.frame = CGRectMake(0, 0, kScreen_width, (self.groupMembers.count/5 * 110)+ (((self.groupMembers.count % 5) == 0)?0:110));
                return (self.groupMembers.count/5 * 110)+ (((self.groupMembers.count % 5) == 0)?0:110);
            }
            
        }else{
            return 50;
        }
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.f;
    }else{
        return 50.f;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 150, 22)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"999999"];
        label.text = @"开启后接受群消息提醒";
        [view addSubview:label];
        return view;
    }else{
        return [[UIView alloc]init];
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.groupMembers.count > 15) {
            return 2;
        }
        return 1;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell * cell = [[UITableViewCell alloc]init];
            [cell addSubview:_collectionView];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        }else{
            UITableViewCell * cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, 100, 22)];
            label.center = CGPointMake(kScreen_width/2, 50/2);
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor colorWithHexString:@"666666"];
            label.text = @"查看全部成员";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:label];
            return cell;
        }
        
    }else{
        WMGroupInfoRemindCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMGroupInfoRemindCell"];
        //查询当前群聊屏蔽状态
        [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.groupID success:^(RCConversationNotificationStatus nStatus) {
            NSLog(@"获取到的群聊天状态：%lu",(unsigned long)nStatus);
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setValueforCell:nStatus];
            });
            
        } error:^(RCErrorCode status) {
            [WMHUDUntil showMessageToWindow:@"群消息屏蔽获取状态失败！"];
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagertId = self.groupID;
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {     //查看全部群成员
        WMGroupMemberViewController *groupMembersViewController = [[WMGroupMemberViewController alloc] init];
        groupMembersViewController.groupMembers = _groupMembers;
        groupMembersViewController.groupID = self.groupID;
        [self.navigationController pushViewController:groupMembersViewController animated:YES];
    }
}

#pragma mark--UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.groupMembers.count > 15) {
        return 15;
    }
    return self.groupMembers.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //原（70，80）
    return CGSizeMake((kScreen_width-50)/5, 80);
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
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"群成员error = %@", errorResult);
    }];
}

@end
