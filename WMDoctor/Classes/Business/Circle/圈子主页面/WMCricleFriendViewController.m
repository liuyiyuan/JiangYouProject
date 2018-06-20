//
//  WMCricleFriendViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCricleFriendViewController.h"
#import "WMDoctorFirendDetailModel.h"
#import "WMDoctorFirendCell.h"

@interface WMCricleFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray * _allFriendArray;//放城市的数组。
}
@property (nonatomic,strong) NSMutableArray * sections;//放区的数组

@end

@implementation WMCricleFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
    // Do any additional setup after loading the view.
}
-(void)setupView{
    _tableView=[[UITableView alloc] init];
    _tableView.frame=CGRectMake(0, 0, kScreen_width, kScreen_height);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
    
}
-(void)setupData{
    _allFriendArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self getXiuNIData];
}
//获取虚拟数据
- (void)getXiuNIData{
    //NSMutableArray *xiuNIArray=[[NSMutableArray alloc] initWithObjects:@"阿宝",@"荸荠",@"出错",@"大宝",@"饿了吗",@"飞机",@"茭白",@"竹叶",@"玛卡",@"益智仁",@"五味子",@"艾叶",@"爬山虎",@"徐长卿",@"青果", nil];
    WMDoctorFirendDetailModel *a=[[WMDoctorFirendDetailModel alloc]init];
    a.name=@"阿宝";
    WMDoctorFirendDetailModel *b=[[WMDoctorFirendDetailModel alloc]init];
    b.name=@"荸荠";
    WMDoctorFirendDetailModel *c=[[WMDoctorFirendDetailModel alloc]init];
    c.name=@"茭白";
    WMDoctorFirendDetailModel *j=[[WMDoctorFirendDetailModel alloc]init];
    j.name=@"益智仁";
    WMDoctorFirendDetailModel *y=[[WMDoctorFirendDetailModel alloc]init];
    y.name=@"焦新伟";
     NSMutableArray *xiuNIArray=[[NSMutableArray alloc] initWithObjects:a,b,c,j,y,nil];
    [_allFriendArray addObjectsFromArray:xiuNIArray];
    [self processSearchList];
    
}
//全部数据进行分组
- (void)processSearchList{
    _sections = [NSMutableArray new];
/*
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    //将每个人按name分到某个section下
    
    for (WMDoctorFirendDetailModel *p in _allFriendArray) {
        　　//获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:p collationStringSelector:@selector(name)];
        　　//把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:p];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index =0; index < sectionTitlesCount; index++) {
       
            NSMutableArray *personArrayForSection = newSectionsArray[index];
            NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
            newSectionsArray[index] = sortedPersonArrayForSection;

    }*/
    ///**************//////

    /******************************************/

    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *unsortedSections = [[NSMutableArray alloc]initWithCapacity:[[theCollation sectionTitles] count]+1];
    
    
    for (NSUInteger i = 0 ; i < [[theCollation sectionTitles] count]; i ++){
        [unsortedSections addObject:[NSMutableArray array]];
    }
    for (WMDoctorFirendDetailModel *model in _allFriendArray){
        NSInteger index = [theCollation sectionForObject:model collationStringSelector:@selector(name)];
        [[unsortedSections objectAtIndex:index] addObject:model];
    }
    
    self.sections = unsortedSections;
    [_tableView reloadData];
    


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMDoctorFirendCell *doctorFirendCell=(WMDoctorFirendCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!doctorFirendCell) {
        doctorFirendCell=[[[NSBundle mainBundle]loadNibNamed:@"WMDoctorFirendCell" owner:self options:Nil] lastObject];
    }
    return doctorFirendCell;
    
}

#pragma - mark - UITabelViewDelegate/UITabelViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tableView) {
        return _sections.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView) {
        if (section == 0) {
            return 1;
        }
        return [_sections[section] count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        if (indexPath.section==0) {
            return 80.f;
        }
        return 80.f;
    }else{
        return 80.f;
    }
}
//返回右侧的字母列表
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        
            NSArray * abcarr = [[NSArray array] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionTitles]];
            return abcarr;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 0 ) {
            return 110.f;
        }else{
            if ([[self.sections objectAtIndex:section] count] > 0) {
                return 30.f;
            }else{
                return 0;
            }
        }
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section==0) {
            UIView * firstSectionV = [[UIView alloc] init];
            firstSectionV.frame=CGRectMake(0, 0, kScreen_width, 110);
            firstSectionV.backgroundColor=[UIColor lightGrayColor];
            UIView * cellView = [[UIView alloc]init];
            cellView.frame = CGRectMake(0, 0, kScreen_width, 80);
            cellView.backgroundColor=[UIColor whiteColor];
            [firstSectionV addSubview:cellView];
            
            UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
            headImage.layer.cornerRadius=20;
            headImage.layer.masksToBounds=YES;
            headImage.backgroundColor=[UIColor redColor];
            [cellView addSubview:headImage];
            
            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 29, 100, 22)];
            nameLabel.text=@"新朋友";
            
            [cellView addSubview:nameLabel];
            
            
            UILabel * cityName = [[UILabel alloc] initWithFrame:CGRectMake(15,82, 90, 25)];
            
            [firstSectionV addSubview:cityName];
            if ([[self.sections objectAtIndex:section] count] > 0) {
                cityName.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
            }else{
                return nil;
            }

            return firstSectionV;
        }
        else{
            UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            myView.backgroundColor = [UIColor lightGrayColor];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 25)];
            //titleLabel.textColor=[UIColor lightBackColor];
            //    titleLabel.backgroundColor = [UIColor redColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [myView addSubview:titleLabel];
            
            
            
            if ([[self.sections objectAtIndex:section] count] > 0) {
                titleLabel.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
            }else{
                return nil;
            }
            
            
            
            
            return myView;
        }
        
    }else{
        return nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
