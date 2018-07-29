//
//  JYPersonalInformationViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPersonalInformationViewController.h"
#import "JYPersonalInformationHeaderView.h"
#import "JYAboutUsTableViewCell.h"
#import "SelectPhotoManager.h"
#import "JYEditUserInfoAPIManager.h"
@interface JYPersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)JYPersonalInformationHeaderView *headerView;

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) SelectPhotoManager   *photoManager;//相册选择器
@end

@implementation JYPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self configUI];
    [self loadEditUserInfoRequest];
}


-(void)configUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(150);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(self.view.height - 150);
    }];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYAboutUsTableViewCell *cell = [[JYAboutUsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYAboutUsTableViewCell"];
    cell.versionLabel.textColor = [UIColor colorWithHexString:@"#A1A1A1"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        case 0:
            cell.versionLabel.text = @"放屁的怪咖";
            cell.typeLabel.text = @"昵称";
            break;
        case 1:
        {
            cell.versionLabel.text = @"13000000000";
            cell.typeLabel.text = @"手机号";
        }
            break;
        case 2:
            cell.versionLabel.text = @"女";
            cell.typeLabel.text = @"性别";
            break;
        case 3:
            cell.versionLabel.text = @"1000年1月1日";
            cell.typeLabel.text = @"生日";
            break;
        case 4:
            cell.versionLabel.text = @"个性签名";
            cell.typeLabel.text = @"个人简介";
            break;
        default:
            break;
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    cell.selectedBackgroundView = backView;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(JYPersonalInformationHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYPersonalInformationHeaderView alloc]init];
        [_headerView.imageButton addTarget:self action:@selector(click_imageButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
#pragma mark - 更换头像点击方法
-(void)click_imageButton{
        if (!_photoManager) {
            _photoManager =[[SelectPhotoManager alloc]init];
        }
        [_photoManager startSelectPhotoWithImageName:@"选择头像"];
        __weak typeof(self)mySelf=self;
        //选取照片成功
        _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
            [mySelf.headerView.imageButton setImage:image forState:UIControlStateNormal];
    
            //保存到本地
            NSData *data = UIImagePNGRepresentation(image);
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"headerImage"];
        };
    
        //这里是从本地取的，如果是上线项目一定要从服务器取头像地址加载
        UIImage *img = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"]];
        if (img) {
            [mySelf.headerView.imageButton setImage:img forState:UIControlStateNormal];
        }
}

- (void)loadEditUserInfoRequest{
    
    JYEditUserInfoAPIManager *editUserInfo = [[JYEditUserInfoAPIManager alloc] init];
    NSDictionary *param = @{
                            @"userId" : @"",
                            @"nickName" : @"",
                            @"sex" : @"",
                            @"introduce" : @"",
                            @"userName" : @"",
                            @"card" : @"",
                            @"workId" : @"",
                            @"workName" : @"",
                            @"annualIncomeId" : @"",
                            @"annualIncomeNum" : @""
                            };
    [editUserInfo loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"edit userinfo request response data : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"edit userinfo request error : %@", errorResult);
    }];
}

@end
