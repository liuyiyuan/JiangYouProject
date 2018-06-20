//
//  WMTagGroupViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagGroupViewController.h"
#import "WMTagGroupGetAPIManager.h"
#import "WMTagSelectModel.h"
#import "WMTagGroupSaveAPIManager.h"

@interface WMTagGroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WMTagGroupCollectionViewCellDelegate,WMTagGroupSelectCollectionViewCellDelegate>
{
    WMTagSelectModel * _allModel;
    WMTagModelCustom * _customModel;
    float _cellSize;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UICollectionView *allCollection;

@property (strong,nonatomic) NSMutableArray<WMPatientTagModel> * dataSourceAll;

@property (nonatomic,strong) NSMutableArray<WMPatientTagModel> * dataSourcePatient;

@property (nonatomic, strong) NSMutableArray<WMPatientTagModel> * dataSourceSave;
@property (nonatomic, strong) UIButton *leftBarBtn;
@property (nonatomic, strong) UIButton *rightBarBtn;
@property (nonatomic, strong) NSString *textFieldStr;

@end

@implementation WMTagGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

- (void)setupUI{
    
    _cellSize = 100;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.allCollection.delegate = self;
    self.allCollection.dataSource = self;
    self.allCollection.backgroundColor = [UIColor colorWithHexString:@"f3f5f9"];
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 10;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 0;
    // 3.设置item块的大小 (可以用于自适应)
    layout.estimatedItemSize = CGSizeMake(0, 0);
    // 设置item的内边距
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    [_collection setCollectionViewLayout:layout];
    UICollectionViewFlowLayout  *alllayout = [[UICollectionViewFlowLayout alloc] init];
    alllayout.minimumLineSpacing = 10;
    alllayout. minimumInteritemSpacing  = 0;
    alllayout.estimatedItemSize = CGSizeMake(0, 0);
    alllayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    alllayout.headerReferenceSize = CGSizeMake(kScreen_width, 30);
    [_allCollection setCollectionViewLayout:alllayout];
    
    self.leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBarBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBarBtn addTarget:self action:@selector(leftBarBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
    
    //保存按钮
    self.rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    [self.rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBarBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.rightBarBtn.titleLabel.alpha = 0.5;
    self.rightBarBtn.userInteractionEnabled = NO;
    [self.rightBarBtn addTarget:self action:@selector(goSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    
}

- (void)leftBarBtnClickAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData{
    WMTagGroupGetAPIManager * apiManager = [WMTagGroupGetAPIManager new];
    [apiManager loadDataWithParams:@{@"weimaihao":self.weimaihao} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _allModel = [[WMTagSelectModel alloc]initWithDictionary:responseObject error:nil];
        for (int i = 0; i<_allModel.allTags.count; i++) {
            WMPatientTagModel* model = _allModel.allTags[i];
            model.isSelect = @"0";
        }
        
        for (int k = 0; k<_allModel.patientTags.count; k++) {
            WMPatientTagModel * theModel = _allModel.patientTags[k];
            for (int j = 0; j<_allModel.allTags.count; j++) {
                WMPatientTagModel * model = _allModel.allTags[j];
                if ([theModel.tagName isEqualToString:model.tagName]) {
                    model.isSelect = @"1";
                }
            }
            
        }
        
        self.dataSourceAll = _allModel.allTags;
        self.dataSourcePatient = _allModel.patientTags;
        self.dataSourceSave = [_allModel.patientTags mutableCopy];
        
        [_collection reloadData];
        [_allCollection reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView != _allCollection) {
        return self.dataSourcePatient.count + 1;
    }
    return self.dataSourceAll.count;
}

//cell渲染
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView != _allCollection) {
        WMTagGroupCollectionViewCell * cell = [_collection dequeueReusableCellWithReuseIdentifier:@"WMTagGroupCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.layer.borderWidth = 0;
        if (self.dataSourcePatient.count == indexPath.row) {
            [cell setValueForText];
            [cell setSize:CGSizeMake(_cellSize, 30)];
            return cell;
        }
        WMPatientTagModel * model = (WMPatientTagModel *)self.dataSourcePatient[indexPath.row];
        [cell setValueForTag:model];
        return cell;
    }else{
        WMTagGroupSelectCollectionViewCell * cell = [_allCollection dequeueReusableCellWithReuseIdentifier:@"WMTagGroupSelectCollectionViewCell" forIndexPath:indexPath];
        [cell setValueForTag:self.dataSourceAll[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _allCollection) {
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
            UICollectionReusableView *headerView = [_allCollection dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMTagGroupCollectionReusableView" forIndexPath:indexPath];
            if(headerView == nil){
                headerView = [[UICollectionReusableView alloc] init];
            }
            return headerView;
        } else{
            UICollectionReusableView *headerView = [[UICollectionReusableView alloc] init];
            return headerView;
        }
    } else{
        return [[UICollectionReusableView alloc] init];
    }
}

#pragma  mark - UICollectionViewDelegate
//cell尺寸调整
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (collectionView != _allCollection) {
        
        if (self.dataSourcePatient.count == indexPath.row) {
            return CGSizeMake(100, 30);
        }
        WMPatientTagModel * model = (WMPatientTagModel *)self.dataSourcePatient[indexPath.row];
        float textWidth = [CommonUtil widthForLabelWithText:model.tagName height:20 font:[UIFont systemFontOfSize:14]];
        return CGSizeMake(textWidth + 30, 30);
    }
    
    WMPatientTagModel * model = (WMPatientTagModel *)self.dataSourceAll[indexPath.row];
    float textWidth = [CommonUtil widthForLabelWithText:model.tagName height:20 font:[UIFont systemFontOfSize:14]];
    return CGSizeMake(textWidth + 30, 30);
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了didSelectItemAtIndexPath");
    if (collectionView != _allCollection) {
        if (indexPath.row == self.dataSourcePatient.count) {
            return;
        }
        //逻辑判断
        WMPatientTagModel * pModel = self.dataSourcePatient[indexPath.row];
        
        //去除选择状态
        for (int i =0; i<self.dataSourceAll.count; i++) {
            WMPatientTagModel * aModel = self.dataSourceAll[i];
            if ([pModel.tagName isEqualToString:aModel.tagName]) {
                aModel.isSelect = @"0";
            }
        }
        
        if ([pModel.flag isEqualToString:@"0"]) {
            for (int i=0; i<self.dataSourceSave.count; i++) {
                WMPatientTagModel * saveModel = self.dataSourceSave[i];
                if ([pModel.tagName isEqualToString:saveModel.tagName]) {  //查看是否存在且是否早就存在
                    if ([saveModel.flag isEqualToString:@"0"]) {
                        saveModel.flag = @"1";
                        [self.dataSourcePatient removeObjectAtIndex:indexPath.row];
                    }else{
                        [self.dataSourcePatient removeObjectAtIndex:indexPath.row];
                        [self.dataSourceSave removeObjectAtIndex:i];
                        return;
                    }
                }
            }
        } else{      //新增状态的删除
            [self.dataSourcePatient removeObjectAtIndex:indexPath.row];
            for (int i=0; i<self.dataSourceSave.count; i++) {
                WMPatientTagModel * saveModel = self.dataSourceSave[i];
                if ([pModel.tagName isEqualToString:saveModel.tagName]) {  //查看是否存在且是否早就存在
                    
                    [self.dataSourceSave removeObjectAtIndex:i];
                    
                }
            }
        }
        
        [_collection reloadData];
        [_allCollection reloadData];
    }
    
    
    else{
        //拿到点击的cell
        if (self.dataSourcePatient.count < indexPath.row) {
            return;
        }
         WMPatientTagModel * model = self.dataSourceAll[indexPath.row];
        
        if ([model.isSelect isEqualToString:@"1"]) {        //选中状态
            NSInteger theIndex = 0;
            for (int i=0; i<self.dataSourcePatient.count; i++) {
                WMPatientTagModel * theModel = self.dataSourcePatient[i];
                if ([model.tagName isEqualToString:theModel.tagName]) {
                    theIndex = i;
                }
            }
            
            //删除一个
            WMPatientTagModel * pModel = self.dataSourcePatient[theIndex];
            if ([pModel.flag isEqualToString:@"0"]) {
                for (int i=0; i<self.dataSourceSave.count; i++) {
                    WMPatientTagModel * saveModel = self.dataSourceSave[i];
                    if ([pModel.tagName isEqualToString:saveModel.tagName]) {  //查看是否存在且是否早就存在
                        if ([saveModel.flag isEqualToString:@"0"]) {
                            saveModel.flag = @"1";
                            [self.dataSourcePatient removeObjectAtIndex:theIndex];
                        }else{
                            [self.dataSourcePatient removeObjectAtIndex:theIndex];
                            [self.dataSourceSave removeObjectAtIndex:i];
                            return;
                        }
                    }
                }
            } else{      //新增状态的删除
                [self.dataSourcePatient removeObjectAtIndex:theIndex];
                for (int i=0; i<self.dataSourceSave.count; i++) {
                    WMPatientTagModel * saveModel = self.dataSourceSave[i];
                    if ([pModel.tagName isEqualToString:saveModel.tagName]) {  //查看是否存在且是否早就存在
                        
                        [self.dataSourceSave removeObjectAtIndex:i];
                       
                    }
                }
            }
            
        } else{      //新增一个
            //判断saveModel中是否包含
            BOOL theflag = NO;
            for (int i=0; i<self.dataSourceSave.count; i++) {
                WMPatientTagModel * saveModel = self.dataSourceSave[i];
                if ([model.tagName isEqualToString:saveModel.tagName]) {
                    saveModel.flag = @"0";
                    theflag = YES;
                }
            }
            
            if (!theflag) {
                model.flag = @"2";
                [self.dataSourceSave addObject:model];
            } else{
                model.flag = @"0";
            }
            
            [self.dataSourcePatient addObject:model];
        }
        
        if ([model.isSelect isEqualToString:@"0"]) {
            model.isSelect = @"1";
        } else{
            model.isSelect = @"0";
        }
        [_collection reloadData];
        [_allCollection reloadData];
    }
    [self hiddenOrShowBarBtn];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了didDeselectItemAtIndexPath");
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了didHighlightItemAtIndexPath");
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了didUnhighlightItemAtIndexPath");
}

- (void)EnterText:(WMPatientTagModel *)model{
    model.flag = @"2";
    if (self.dataSourcePatient.count >= 10) {
        [WMHUDUntil showMessageToWindow:@"每位患者最多只能设置10个标签"];
        return;
    }
    [self.dataSourcePatient addObject:model];
    [self.dataSourceSave addObject:model];

    [_collection reloadData];
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourcePatient.count inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)textFieldDidChange:(NSString *)text{
    self.textFieldStr = text;
    [self hiddenOrShowBarBtn];
}

- (void)hiddenOrShowBarBtn{
    if (!stringIsEmpty(self.textFieldStr) || self.tagGroups != _dataSourceSave) {
        self.rightBarBtn.titleLabel.alpha = 1;
        self.rightBarBtn.userInteractionEnabled = YES;
    } else{
        self.rightBarBtn.titleLabel.alpha = 0.5;
        self.rightBarBtn.userInteractionEnabled = NO;
    }
}


- (void)selectTag:(NSString *)text{
    
}

- (void)goSave{
    WMTagGroupSaveAPIManager * apiManager = [WMTagGroupSaveAPIManager new];
    _customModel = [[WMTagModelCustom alloc]init];
    
    _customModel.patientTags = self.dataSourceSave;
    _customModel.weimaihao = self.weimaihao;
    [apiManager loadDataWithParams:_customModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.patientData.tags = self.dataSourceSave;
        [self.navigationController popViewControllerAnimated:YES];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
