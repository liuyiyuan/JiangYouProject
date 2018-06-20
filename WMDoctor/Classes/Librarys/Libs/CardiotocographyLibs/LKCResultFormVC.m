//
//  LKCResultFormVC.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/9.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "LKCResultFormVC.h"
#import "ASFTableView.h"
//#import "AppDelegate.h"
#import "ACOGCollectionViewCell.h"
#import "ACOGOneCollectionViewCell.h"
#import "ACOGTwoCollectionViewCell.h"
#import "ACOGThreeCollectionViewCell.h"
#import "ACOGFourCollectionViewCell.h"
#import "ACOGLayout.h"
#import "ACOGModel.h"
@interface LKCResultFormVC () <ASFTableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UIView * formBackView;

@property (nonatomic, retain) NSMutableArray *rowsArray;
@property (nonatomic , strong) AppDelegate * appDelegate;
@property (nonatomic , strong) NSArray * scoreArr;
@property (nonatomic , strong) NSArray * middleArr;

@property (nonatomic , strong) NSMutableArray * ACOGArr;
@end

@implementation LKCResultFormVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ ---  %@ ---- %@",self.scoreStr, self.totalScore,self.ScoreModel);
    if (self.scoreStr) {
        _scoreArr = [self.scoreStr componentsSeparatedByString:@","];
        _middleArr = [[_scoreArr objectAtIndex:7] componentsSeparatedByString:@"@"];
        NSLog(@"-- %@" ,_middleArr);

    }
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _appDelegate.allowRotation = 1;
    
    self.view.backgroundColor = RGBA(224, 230, 246, 1);
    _formBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-35)];
    [self.view addSubview:self.formBackView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
//    [backBtn setBackgroundColor:[UIColor yellowColor]];
    [backBtn setFrame:CGRectMake(10, 0, 35, 35)];
    [backBtn addTarget:self action:@selector(backToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel * modelLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 35)];
    [self.view addSubview:modelLable];
    
    _ACOGArr = [[NSMutableArray  alloc] init];
    _rowsArray = [[NSMutableArray alloc] init];

    if ([self.ScoreModel isEqual:[NSNumber numberWithInt:1]]) {
        [self addACOGTableviewProgrammatically];//ACOG分类
        modelLable.text = @"ACOG";

        
    } else if ([self.ScoreModel isEqual:[NSNumber numberWithInt:2]]) {
        modelLable.text = @"NST";
        [self addNSTTableViewProgrammatically];//NST评分

    } else if([self.ScoreModel isEqual:[NSNumber numberWithInt:3]]) {
        modelLable.text = @"Fischer";

            [self addFischerTableViewProgrammatically];//Fischer评分

    }else if ([self.ScoreModel isEqual:[NSNumber numberWithInt:4]]){
        modelLable.text = @"Krebs(10)";

            [self AddKrebs10TableViewProgrammatically];//Krebs10评分

    }else if ([self.ScoreModel isEqual:[NSNumber numberWithInt:5]]){
        modelLable.text = @"Krebs(12)";
            [self AddKrebs12TableViewProgrammatically];//Krebs12评分
    }
}

-(void)addACOGTableviewProgrammatically{
    [self getFormResult];
    
    ACOGLayout *flowLayout = [[ACOGLayout alloc]init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    UICollectionView * collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40) collectionViewLayout:flowLayout];
    collect.bounces = NO;
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor lightGrayColor];
    [collect registerClass:[ACOGCollectionViewCell class] forCellWithReuseIdentifier:@"ACOGCellID"];
    [collect registerClass:[ACOGOneCollectionViewCell class] forCellWithReuseIdentifier:@"ACOGONECellID"];
    [collect registerClass:[ACOGFourCollectionViewCell class] forCellWithReuseIdentifier:@"ACOGFourCellID"];
    [collect registerClass:[ACOGTwoCollectionViewCell class] forCellWithReuseIdentifier:@"ACOGTwoCellID"];
     [collect registerClass:[ACOGThreeCollectionViewCell class] forCellWithReuseIdentifier:@"ACOGThreeCellID"];
    [self.view addSubview:collect];
    
    
}
- (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    
    return preferredLang;
    
}


-(void)getFormResult{
    NSArray * typeArr  =_adviceArr ;
    NSArray * adviceArr  =_typeArr;
    NSLog(@" --- %@",typeArr);
    
    NSRange range = [[self getPreferredLanguage] rangeOfString:@"zh-Han"];
     NSString *plistPath = @"";
    if(range.length > 0){
        plistPath = [[NSBundle mainBundle] pathForResource:@"ACOGList" ofType:@"plist"];

    } else {
        plistPath = [[NSBundle mainBundle] pathForResource:@"EnACOGList" ofType:@"plist"];
    }
    
       NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * acoArr = [data objectForKey:@"scoreItem"];
    for (int i = 0; i < acoArr.count; i++) {
        ACOGModel * acoModel = [[ACOGModel alloc] initWithPicInfoDictionary:[acoArr objectAtIndex:i]];
        [_ACOGArr addObject:acoModel];
    }
    
    if ([typeArr[0] isEqual:[NSNumber numberWithInt:1]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:1];
        acModel.midMark = @"1";
    }else if ([typeArr[0] isEqual:[NSNumber numberWithInt:2]]){
        ACOGModel * acModel = [_ACOGArr objectAtIndex:2];
        acModel.topMark = @"1";
    }else if ([typeArr[0] isEqual:[NSNumber numberWithInt:3]]){
        ACOGModel * acModel = [_ACOGArr objectAtIndex:2];
        acModel.btmMark = @"1";
    }
    
    if ([typeArr[1] isEqual:[NSNumber numberWithInt:1]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:5];
        acModel.midMark = @"1";
    }else if ([typeArr[1] isEqual:[NSNumber numberWithInt:3]]){
        ACOGModel * acModel = [_ACOGArr objectAtIndex:6];
        acModel.topMark = @"1";
        
    }else if ([typeArr[1] isEqual:[NSNumber numberWithInt:2]]){
        ACOGModel * acModel = [_ACOGArr objectAtIndex:6];
        acModel.midMark = @"1";
        
    }else if ([typeArr[1] isEqual:[NSNumber numberWithInt:4]] && [typeArr[3] intValue]<6 ){
        ACOGModel * acModel = [_ACOGArr objectAtIndex:6];
        acModel.btmMark = @"1";
    }
    
    
    if ([typeArr[1] intValue]>2 && [typeArr[0] isEqual:[NSNumber numberWithInt:3]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:3];
        acModel.topMark = @"1";
    }
    if ([typeArr[1] intValue]>2 && [typeArr[3] isEqual:[NSNumber numberWithInt:6]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:3];
        acModel.midMark = @"1";
    }
    if ([typeArr[1] intValue]>2 && [typeArr[3] isEqual:[NSNumber numberWithInt:7]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:3];
        acModel.btmMark = @"1";
    }
    
    if (typeArr[2] && ![adviceArr[0] isEqual:[NSNumber numberWithInt:0]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:8];
        acModel.midMark = @"1";
    }
    
    if ([typeArr[3] isEqual:[NSNumber numberWithInt:1]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:11];
        acModel.midMark = @"1";
    }
    if ([typeArr[3] isEqual:[NSNumber numberWithInt:3]] ||[typeArr[3] isEqual:[NSNumber numberWithInt:4]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:12];
        acModel.midMark = @"1";
    }
    if ([typeArr[3] isEqual:[NSNumber numberWithInt:2]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:13];
        acModel.midMark = @"1";
    }
    if ([typeArr[1] isEqual:[NSNumber numberWithInt:1]] &&[typeArr[3] isEqual:[NSNumber numberWithInt:6]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:14];
        acModel.topMark = @"1";
    }
    if ([typeArr[1] isEqual:[NSNumber numberWithInt:1]] &&[typeArr[3] isEqual:[NSNumber numberWithInt:7]] ) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:14];
        acModel.btmMark = @"1";
    }
    
    if ([typeArr[3] isEqual:[NSNumber numberWithInt:8]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:15];
        acModel.midMark = @"1";
    }
    if ([typeArr[3] isEqual:[NSNumber numberWithInt:5]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:16];
        acModel.midMark = @"1";
    }
    
    if ([typeArr[4] isEqual:[NSNumber numberWithInt:1]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:18];
        acModel.midMark = @"1";
    }
    if ([typeArr[4] isEqual:[NSNumber numberWithInt:2]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:20];
        acModel.midMark = @"1";
    }
    
    if ([adviceArr[0] isEqual:[NSNumber numberWithInt:1]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:22];
        acModel.midMark = @"1";
    }
    if ([adviceArr[0] isEqual:[NSNumber numberWithInt:2]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:23];
        acModel.midMark = @"1";
    }
    if ([adviceArr[0] isEqual:[NSNumber numberWithInt:3]]) {
        ACOGModel * acModel = [_ACOGArr objectAtIndex:24];
        acModel.midMark = @"1";
    }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == 0 || indexPath.item == 4 || indexPath.item == 7 || indexPath.item == 10 || indexPath.item == 17 || indexPath.item == 21 ) {
        ACOGOneCollectionViewCell * cell = (ACOGOneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ACOGONECellID"forIndexPath:indexPath];
        if (!cell) {
            cell = [[ACOGOneCollectionViewCell alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40)];
        }
        ACOGModel * model = [_ACOGArr objectAtIndex:indexPath.item];
        cell.titleLable.text = model.boldTitle;
        cell.backgroundColor = [UIColor whiteColor];

        return cell;
    } else if( indexPath.item == 3){
        ACOGFourCollectionViewCell * cell = (ACOGFourCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ACOGFourCellID"forIndexPath:indexPath];
        if (!cell) {
            cell = [[ACOGFourCollectionViewCell alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40)];
        }
        ACOGModel * model = [_ACOGArr objectAtIndex:indexPath.item];
        cell.topTipLable.text = model.boldTitle;
        cell.topLable.text = model.topTitle;
        cell.tipLable.text = model.midTitle;
        cell.btmLable.text = model.btmTitle;
        cell.backgroundColor = [UIColor whiteColor];
        if ([model.topMark isEqualToString:@"1"]) {
            cell.topMarkBtn.selected = YES;
        }
        if ([model.btmMark isEqualToString:@"1"]) {
            cell.btmMarkBtn.selected = YES;
        }
        if ([model.midMark isEqualToString:@"1"]) {
            cell.markBtn.selected = YES;
        }


        return cell;

    }else if (indexPath.item == 6){
        ACOGThreeCollectionViewCell * cell = (ACOGThreeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ACOGThreeCellID"forIndexPath:indexPath];
        if (!cell) {
            cell = [[ACOGThreeCollectionViewCell alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40)];
        }
        ACOGModel * model = [_ACOGArr objectAtIndex:indexPath.item];
        cell.topLable.text = model.topTitle;
        cell.tipLable.text = model.midTitle;
        cell.btmLable.text = model.btmTitle;
        cell.backgroundColor = [UIColor whiteColor];
        if ([model.topMark isEqualToString:@"1"]) {
            cell.topMarkBtn.selected = YES;
        }
        if ([model.btmMark isEqualToString:@"1"]) {
            cell.btmMarkBtn.selected = YES;
        }
        if ([model.midMark isEqualToString:@"1"]) {
            cell.markBtn.selected = YES;
        }

        return cell;

    }else if (indexPath.item == 2 || indexPath.item == 14){
        ACOGTwoCollectionViewCell * cell = (ACOGTwoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ACOGTwoCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ACOGTwoCollectionViewCell alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40)];
        }
        ACOGModel * model = [_ACOGArr objectAtIndex:indexPath.item];
        cell.topLable.text = model.topTitle;
        cell.btmLable.text = model.btmTitle;
        cell.backgroundColor = [UIColor whiteColor];
        if ([model.topMark isEqualToString:@"1"]) {
            cell.topMarkBtn.selected = YES;
        }
        if ([model.btmMark isEqualToString:@"1"]) {
            cell.btmMarkBtn.selected = YES;
        }
        return cell;
        
    }else{
        ACOGCollectionViewCell * cell = (ACOGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ACOGCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ACOGCollectionViewCell alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH-40)];
        }
        if (cell) {
            [cell removeFromSuperview];
        }
        ACOGModel * model = [_ACOGArr objectAtIndex:indexPath.item];
        
        
        if (indexPath.item == 19) {
            cell.markBtn.hidden = YES;
            cell.tipLable.hidden = YES;
        } else {
            cell.markBtn.hidden = NO;
            cell.tipLable.hidden = NO;

            cell.tipLable.text = model.midTitle;
            if ([model.midMark isEqualToString:@"1"]) {
                cell.markBtn.selected = YES;
            }else{
                cell.markBtn.selected = NO;
            }

        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 25;
}
-(void)AddKrebs12TableViewProgrammatically{
    ASFTableView *asfTableView = [[ASFTableView alloc] init];
    asfTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_formBackView addSubview:asfTableView];
    [_formBackView addConstraints:@[
                                    
                                    //view1 constraints
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0],
                                    
                                    ]];
    
    //    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    
    NSArray *cols = @[@"  ",@"BFHR", @"VAR", @"CPM",@"ACC加速",@"DEC减速" , @"FM"];
    NSArray *weights = @[@(0.1f),@(0.2f),@(0.1f),@(0.1f),@(0.2f),@(0.2f),@(0.1F)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(13),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(true),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(1.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]};
    
    [asfTableView setDelegate:self];
    [asfTableView setBounces:NO];
    [asfTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [asfTableView setTitles:cols
                WithWeights:weights
                WithOptions:options
                  WitHeight:32 Floating:YES];
    
    [_rowsArray removeAllObjects];
    for (int i=0; i<6; i++) {
        
        if (i == 0 ) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<100/>180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<3", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<3", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString( @"无加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"重度变异减速，晚期减速，延长减速",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 1) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"1", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"100-119/161-180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"3-5 / >25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"3-6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"1-4/周期加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"轻度变异减速/中度变异减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"1-4", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 2) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(2),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"120-160", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"6-25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @">6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"≥5次非周期性加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"无减速，早期减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"≥5", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 3) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"参数",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:0], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:2], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:3], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :  [_scoreArr objectAtIndex:4], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :  [_scoreArr objectAtIndex:5], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}
                                          ],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 4) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"得分",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_middleArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:8], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:9], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:10], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:11], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:12], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}
                                          ],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 5) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"总分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          
                                          @{kASF_CELL_TITLE :[NSString stringWithFormat:@"%@",self.totalScore], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(10),
                                          //                                          kASF_OPTION_CELL_BORDER_SIZE:@(2),
                                          
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        
        
        
    }
    
    [asfTableView setRows:_rowsArray];
    

}
-(void)AddKrebs10TableViewProgrammatically{
    ASFTableView *asfTableView = [[ASFTableView alloc] init];
    asfTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    [_formBackView addSubview:asfTableView];
    [_formBackView addConstraints:@[
                                    
                                    //view1 constraints
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0],
                                    
                                    ]];
    
    //    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    
    NSArray *cols = @[@"  ",@"BFHR", @"VAR", @"FM",NSLocalizedString(@"ACC加速",nil ), NSLocalizedString(@"无加速",nil )];
    NSArray *weights = @[@(0.1f),@(0.2f),@(0.15f),@(0.15f),@(0.2f),@(0.2f)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(13),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(true),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(1.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]};
    
    [asfTableView setDelegate:self];
    [asfTableView setBounces:NO];
    [asfTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [asfTableView setTitles:cols
                WithWeights:weights
                WithOptions:options
                  WitHeight:32 Floating:YES];
    
    [_rowsArray removeAllObjects];
    for (int i=0; i<6; i++) {
        
        if (i == 0 ) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<100/>180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<3", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<3", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"无加速",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"重度变异减速，晚期减速，延长减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                           kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 1) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"1", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"100-119/161-180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"5-9 / >25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"3-6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"1-4/周期加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"轻度变异减速/中度变异减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 2) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(2),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"120-160", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"6-25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @">6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@">=5次非周期性加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"无减速，早期减速",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 3) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : NSLocalizedString(@"参数",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:0], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:2], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:3], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :  [_scoreArr objectAtIndex:4], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 4) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"得分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_middleArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:8], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:9], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:10], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:11], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    

                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 5) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"总分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                        
                                          @{kASF_CELL_TITLE : [NSString stringWithFormat:@"%@",self.totalScore], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(10),
                                          //                                          kASF_OPTION_CELL_BORDER_SIZE:@(2),
                                          
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        
    }
    
    [asfTableView setRows:_rowsArray];

    
}
-(void)addFischerTableViewProgrammatically{
    ASFTableView *asfTableView = [[ASFTableView alloc] init];
    asfTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    [_formBackView addSubview:asfTableView];
    [_formBackView addConstraints:@[
                                    
                                    //view1 constraints
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:asfTableView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_formBackView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0],
                                    
                                    ]];
    
//    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    
    NSArray *cols = @[@"  ",@"BFHR", @"VAR", @"FM",NSLocalizedString(@"ACC加速",nil ),NSLocalizedString(@"DEC减速",nil )];
    NSArray *weights = @[@(0.1f),@(0.2f),@(0.15f),@(0.15f),@(0.2f),@(0.2f)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(13),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(true),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(1.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]};
    
    [asfTableView setDelegate:self];
    [asfTableView setBounces:NO];
    [asfTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [asfTableView setTitles:cols
                WithWeights:weights
                WithOptions:options
                  WitHeight:32 Floating:YES];
    
    [_rowsArray removeAllObjects];
    for (int i=0; i<6; i++) {
        
        if (i == 0 ) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<100/>180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<5", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"无加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"晚期减速，延长减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                           kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 1) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"1", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"100-119/161-180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"5-9 / >30", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"2-6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"周期性加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :  NSLocalizedString(@"变异减速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 2) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(2),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"120-160", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"10-30", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @">6", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : NSLocalizedString(@"非周期性加速",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :NSLocalizedString(@"无减速，早期减速",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 3) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : NSLocalizedString(@"参数",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:0], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:2], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:3], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE :  [_scoreArr objectAtIndex:4], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 4) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"得分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_middleArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:8], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:9], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:10], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:11], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 5) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"总分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                       
                                          @{kASF_CELL_TITLE : [NSString stringWithFormat:@"%@",self.totalScore], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(10),
                                          //                                          kASF_OPTION_CELL_BORDER_SIZE:@(2),
                                          
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        
        
    }
    
    [asfTableView setRows:_rowsArray];

}
-(void)backToPreviousView{
    _appDelegate.allowRotation = 0;

//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addNSTTableViewProgrammatically {
    ASFTableView *asfTableView = [[ASFTableView alloc] init];
    asfTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    [_formBackView addSubview:asfTableView];
    [_formBackView addConstraints:@[
                                
                                //view1 constraints
                                [NSLayoutConstraint constraintWithItem:asfTableView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_formBackView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:asfTableView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_formBackView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:asfTableView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_formBackView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:asfTableView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_formBackView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0],
                                
                                ]];
    
//    [asfTableView setBackgroundColor:[UIColor greenColor]];
    
    
    NSArray *cols = @[@"  ",@"BFHR", @"VAR", @"FM",NSLocalizedString(@"加速幅度",nil ), NSLocalizedString(@"加速时间",nil)];
    NSArray *weights = @[@(0.1f),@(0.2f),@(0.15f),@(0.15f),@(0.2f),@(0.2f)];
    NSDictionary *options = @{kASF_OPTION_CELL_TEXT_FONT_SIZE : @(13),
                              kASF_OPTION_CELL_TEXT_FONT_BOLD : @(true),
                              kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor],
                              kASF_OPTION_CELL_BORDER_SIZE : @(1.0),
                              kASF_OPTION_BACKGROUND : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]};
    
    [asfTableView setDelegate:self];
    [asfTableView setBounces:NO];
    [asfTableView setSelectionColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f]];
    [asfTableView setTitles:cols
                WithWeights:weights
                WithOptions:options
                  WitHeight:32 Floating:YES];
    
    [_rowsArray removeAllObjects];
    for (int i=0; i<6; i++) {
        
        if (i == 0 ) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<100/>180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"≤5", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"0", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<10", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"<10", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(5),
                                           kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 1) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(1),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"1", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"100-109/161-180", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @">25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"1", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"10-14", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"10-14", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 2) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(2),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE : @"2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"110-160", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"6-25", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"≥2", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"≥15", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : @"≥15", kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 3) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"参数",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:0], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:5], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:6], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_middleArr objectAtIndex:0], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 4) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"得分",nil ) , kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_middleArr objectAtIndex:1], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:8], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:12], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:13], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                          @{kASF_CELL_TITLE : [_scoreArr objectAtIndex:14], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(2),
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        if (i == 5) {
            [_rowsArray addObject:@{
                                    kASF_ROW_ID :
                                        @(3),
                                    
                                    kASF_ROW_CELLS :
                                        @[@{kASF_CELL_TITLE :NSLocalizedString(@"总分",nil ), kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)},
                                         
                                          @{kASF_CELL_TITLE : [NSString stringWithFormat:@"%@",self.totalScore], kASF_OPTION_CELL_TEXT_ALIGNMENT : @(NSTextAlignmentCenter)}],
                                    
                                    kASF_ROW_OPTIONS :
                                        @{kASF_OPTION_BACKGROUND : [UIColor whiteColor],
                                          kASF_OPTION_CELL_PADDING : @(10),
                                          //                                          kASF_OPTION_CELL_BORDER_SIZE:@(2),
                                          
                                          kASF_OPTION_CELL_TEXT_FONT_SIZE:@(10),
                                          kASF_OPTION_CELL_BORDER_COLOR : [UIColor lightGrayColor]},
                                    
                                    @"some_other_data" : @(222)}];
            
        }
        
        
        
    }
    
    [asfTableView setRows:_rowsArray];
}

#pragma mark - ASFTableViewDelegate
- (void)ASFTableView:(ASFTableView *)tableView DidSelectRow:(NSDictionary *)rowDict WithRowIndex:(NSUInteger)rowIndex {
    NSLog(@"%lu", (unsigned long)rowIndex);
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
